import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/utils/cultivation_calculator.dart';
import '../../data/models/cultivation_category.dart';
import '../../data/models/mission_model.dart';
import '../../data/repositories/mission_repository.dart';
import 'cultivation_provider.dart';

enum MissionStatusFilter {
  all,
  pending,
  completed,
}

class MissionProvider extends ChangeNotifier {
  final MissionRepository _repository;
  final _uuid = const Uuid();

  List<Mission> _missions = [];
  CultivationCategory? _selectedCategory;
  MissionStatusFilter _statusFilter = MissionStatusFilter.all;
  String _searchQuery = '';
  bool _isLoading = false;

  MissionProvider({MissionRepository? repository})
      : _repository = repository ?? MissionRepositoryImpl() {
    loadMissions();
  }

  List<Mission> get allMissions => _missions;
  CultivationCategory? get selectedCategory => _selectedCategory;
  MissionStatusFilter get statusFilter => _statusFilter;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  List<Mission> get filteredMissions {
    return _missions.where((m) {
      // Category filter
      if (_selectedCategory != null && m.category != _selectedCategory) {
        return false;
      }
      // Status filter
      if (_statusFilter == MissionStatusFilter.pending && m.isCompleted) {
        return false;
      }
      if (_statusFilter == MissionStatusFilter.completed && !m.isCompleted) {
        return false;
      }
      // Search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = m.title.toLowerCase().contains(query);
        final matchesDesc = m.description.toLowerCase().contains(query);
        final matchesTags = m.tags.any((t) => t.toLowerCase().contains(query));
        if (!matchesTitle && !matchesDesc && !matchesTags) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  int get completedCount => _missions.where((m) => m.isCompleted).length;
  int get pendingCount => _missions.where((m) => !m.isCompleted).length;

  int countByCategory(CultivationCategory category) {
    return _missions.where((m) => m.category == category && !m.isCompleted).length;
  }

  Future<void> loadMissions() async {
    _isLoading = true;
    notifyListeners();

    _missions = _repository.getMissions();

    _isLoading = false;
    notifyListeners();
  }

  void setCategoryFilter(CultivationCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setStatusFilter(MissionStatusFilter filter) {
    _statusFilter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> createMission({
    required String title,
    required String description,
    required CultivationCategory category,
    required int difficulty,
    required int estimatedMinutes,
    bool isDaily = false,
    List<String> tags = const [],
    DateTime? dueDate,
  }) async {
    final int calculatedXp = CultivationCalculator.calculateMissionXp(
      difficulty: difficulty,
      estimatedMinutes: estimatedMinutes,
      isDaily: isDaily,
    );

    final mission = Mission(
      id: _uuid.v4(),
      title: title,
      description: description,
      category: category,
      xpReward: calculatedXp,
      difficulty: difficulty,
      estimatedMinutes: estimatedMinutes,
      isCompleted: false,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      isDaily: isDaily,
      tags: tags,
    );

    await _repository.addMission(mission);
    _missions.insert(0, mission);
    notifyListeners();
  }

  Future<void> updateMission(Mission mission) async {
    final index = _missions.indexWhere((m) => m.id == mission.id);
    if (index != -1) {
      _missions[index] = mission;
      await _repository.updateMission(mission);
      notifyListeners();
    }
  }

  Future<void> deleteMission(String id) async {
    _missions.removeWhere((m) => m.id == id);
    await _repository.deleteMission(id);
    notifyListeners();
  }

  /// Toggle mission completion state
  Future<({bool wasCompleted, int gainedQi, bool hasBreakthrough})>
      toggleMission(String id, CultivationProvider cultivationProvider) async {
    final index = _missions.indexWhere((m) => m.id == id);
    if (index == -1) {
      return (wasCompleted: false, gainedQi: 0, hasBreakthrough: false);
    }

    final mission = _missions[index];
    final bool willBeCompleted = !mission.isCompleted;

    if (willBeCompleted) {
      final updatedMission = mission.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
      );
      _missions[index] = updatedMission;
      await _repository.updateMission(updatedMission);

      // Award Qi and log achievement
      final result = await cultivationProvider.recordMissionCompletion(
        category: mission.category,
        baseQiReward: mission.xpReward,
        missionTitle: mission.title,
      );

      notifyListeners();
      return (
        wasCompleted: true,
        gainedQi: result.gainedQi,
        hasBreakthrough: result.hasBreakthrough,
      );
    } else {
      // Revert completion
      final updatedMission = mission.copyWith(
        isCompleted: false,
        completedAt: null,
      );
      _missions[index] = updatedMission;
      await _repository.updateMission(updatedMission);

      notifyListeners();
      return (wasCompleted: false, gainedQi: 0, hasBreakthrough: false);
    }
  }
}
