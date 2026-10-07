import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../core/utils/body_cultivation_calculator.dart';
import '../../data/models/body_cultivation_models.dart';
import '../../data/repositories/body_cultivation_repository.dart';

class BodyCultivationProvider extends ChangeNotifier {
  final BodyCultivationRepository _repository;
  final Uuid _uuid = const Uuid();

  List<Exercise> _exercises = [];
  List<TrainingSessionTemplate> _templates = [];
  List<TrainingRecord> _records = [];

  // Active Session State
  bool _isSessionActive = false;
  TrainingSessionTemplate? _currentTemplate;
  List<Exercise> _sessionExercises = [];
  int _currentExerciseIndex = 0;
  int _completedSetsInCurrentExercise = 0;
  int _totalSetsCompleted = 0;
  int _sessionDurationSeconds = 0;

  bool _isResting = false;
  int _restTimeRemaining = 0;
  int _maxRestTime = 45;

  bool _isTimedExerciseRunning = false;
  int _timedExerciseRemaining = 0;

  bool _isTimerPaused = false;
  Timer? _sessionTimer;

  // Filter State for Library
  ExerciseCategory? _selectedCategory;
  String _searchQuery = '';

  BodyCultivationProvider({BodyCultivationRepository? repository})
      : _repository = repository ?? BodyCultivationRepositoryImpl() {
    _init();
  }

  void _init() {
    _exercises = _repository.getAllExercises();
    _templates = _repository.getAllTemplates();
    _records = _repository.getTrainingRecords();
  }

  // Getters
  List<Exercise> get exercises => _exercises;
  List<TrainingSessionTemplate> get templates => _templates;
  List<TrainingRecord> get records => _records;

  bool get isSessionActive => _isSessionActive;
  TrainingSessionTemplate? get currentTemplate => _currentTemplate;
  List<Exercise> get sessionExercises => _sessionExercises;
  int get currentExerciseIndex => _currentExerciseIndex;
  int get completedSetsInCurrentExercise => _completedSetsInCurrentExercise;
  int get totalSetsCompleted => _totalSetsCompleted;
  int get sessionDurationSeconds => _sessionDurationSeconds;

  bool get isResting => _isResting;
  int get restTimeRemaining => _restTimeRemaining;
  int get maxRestTime => _maxRestTime;

  bool get isTimedExerciseRunning => _isTimedExerciseRunning;
  int get timedExerciseRemaining => _timedExerciseRemaining;
  bool get isTimerPaused => _isTimerPaused;

  ExerciseCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  Exercise get currentExercise {
    if (_sessionExercises.isEmpty) {
      return _exercises.first;
    }
    if (_currentExerciseIndex >= _sessionExercises.length) {
      return _sessionExercises.last;
    }
    return _sessionExercises[_currentExerciseIndex];
  }

  int get totalSessionSets {
    return _sessionExercises.fold<int>(0, (sum, ex) => sum + ex.defaultSets);
  }

  double get overallSessionProgress {
    final total = totalSessionSets;
    if (total == 0) return 0.0;
    return (_totalSetsCompleted / total).clamp(0.0, 1.0);
  }

  List<Exercise> get filteredExercises {
    return _exercises.where((ex) {
      final matchesCategory = _selectedCategory == null || ex.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          ex.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ex.murimName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ex.targetMuscles.any((m) => m.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchesCategory && matchesQuery;
    }).toList();
  }

  // Filter setters
  void setSelectedCategory(ExerciseCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // --- Session Lifecycle ---

  void startSession(TrainingSessionTemplate template) {
    _currentTemplate = template;
    _sessionExercises = template.exerciseIds
        .map((id) => _repository.getExerciseById(id))
        .whereType<Exercise>()
        .toList();

    if (_sessionExercises.isEmpty) {
      _sessionExercises = [_exercises.first];
    }

    _currentExerciseIndex = 0;
    _completedSetsInCurrentExercise = 0;
    _totalSetsCompleted = 0;
    _sessionDurationSeconds = 0;
    _isResting = false;
    _restTimeRemaining = 0;
    _isTimedExerciseRunning = false;
    _timedExerciseRemaining = currentExercise.defaultDurationSeconds;
    _isTimerPaused = false;
    _isSessionActive = true;

    _startTicker();
    notifyListeners();
  }

  void startCustomSession({
    required String title,
    required String murimTitle,
    required List<Exercise> exercises,
    int targetRealmLevel = 1,
  }) {
    final template = TrainingSessionTemplate(
      id: 'custom_${_uuid.v4()}',
      title: title,
      murimTitle: murimTitle,
      targetRealmLevel: targetRealmLevel,
      estimatedMinutes: exercises.length * 4,
      exerciseIds: exercises.map((e) => e.id).toList(),
      description: 'รูทีนฝึกฝนปรับแต่งเฉพาะตน',
    );

    _currentTemplate = template;
    _sessionExercises = List<Exercise>.from(exercises);
    _currentExerciseIndex = 0;
    _completedSetsInCurrentExercise = 0;
    _totalSetsCompleted = 0;
    _sessionDurationSeconds = 0;
    _isResting = false;
    _restTimeRemaining = 0;
    _isTimedExerciseRunning = false;
    _timedExerciseRemaining = currentExercise.defaultDurationSeconds;
    _isTimerPaused = false;
    _isSessionActive = true;

    _startTicker();
    notifyListeners();
  }

  void _startTicker() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isSessionActive || _isTimerPaused) return;

      _sessionDurationSeconds++;

      if (_isResting) {
        if (_restTimeRemaining > 0) {
          _restTimeRemaining--;
        } else {
          _isResting = false;
        }
      } else if (_isTimedExerciseRunning) {
        if (_timedExerciseRemaining > 0) {
          _timedExerciseRemaining--;
        } else {
          _isTimedExerciseRunning = false;
          completeSet();
        }
      }

      notifyListeners();
    });
  }

  void completeSet() {
    if (!_isSessionActive) return;

    _completedSetsInCurrentExercise++;
    _totalSetsCompleted++;
    _isTimedExerciseRunning = false;

    // Check if exercise completed
    if (_completedSetsInCurrentExercise >= currentExercise.defaultSets) {
      if (_currentExerciseIndex < _sessionExercises.length - 1) {
        _currentExerciseIndex++;
        _completedSetsInCurrentExercise = 0;
        _timedExerciseRemaining = currentExercise.defaultDurationSeconds;
        _startRestTimer(currentExercise.defaultRestSeconds);
      } else {
        // Last set of last exercise
        _isResting = false;
      }
    } else {
      _startRestTimer(currentExercise.defaultRestSeconds);
    }

    notifyListeners();
  }

  void _startRestTimer(int durationSeconds) {
    _maxRestTime = durationSeconds > 0 ? durationSeconds : 30;
    _restTimeRemaining = _maxRestTime;
    _isResting = true;
  }

  void skipRest() {
    _isResting = false;
    _restTimeRemaining = 0;
    notifyListeners();
  }

  void adjustRestTime(int deltaSeconds) {
    _restTimeRemaining = (_restTimeRemaining + deltaSeconds).clamp(0, 300);
    if (_restTimeRemaining > _maxRestTime) {
      _maxRestTime = _restTimeRemaining;
    }
    notifyListeners();
  }

  void startTimedExercise() {
    if (currentExercise.defaultDurationSeconds > 0) {
      _isTimedExerciseRunning = true;
      if (_timedExerciseRemaining <= 0) {
        _timedExerciseRemaining = currentExercise.defaultDurationSeconds;
      }
      notifyListeners();
    }
  }

  void pauseResumeTimer() {
    _isTimerPaused = !_isTimerPaused;
    notifyListeners();
  }

  bool switchToEasierVariation() {
    final easierId = currentExercise.easierVariationId;
    if (easierId == null) return false;

    final easierEx = _repository.getExerciseById(easierId);
    if (easierEx == null) return false;

    _sessionExercises[_currentExerciseIndex] = easierEx;
    _timedExerciseRemaining = easierEx.defaultDurationSeconds;
    notifyListeners();
    return true;
  }

  bool switchToHarderVariation() {
    final harderId = currentExercise.harderVariationId;
    if (harderId == null) return false;

    final harderEx = _repository.getExerciseById(harderId);
    if (harderEx == null) return false;

    _sessionExercises[_currentExerciseIndex] = harderEx;
    _timedExerciseRemaining = harderEx.defaultDurationSeconds;
    notifyListeners();
    return true;
  }

  void nextExercise() {
    if (_currentExerciseIndex < _sessionExercises.length - 1) {
      _currentExerciseIndex++;
      _completedSetsInCurrentExercise = 0;
      _isResting = false;
      _isTimedExerciseRunning = false;
      _timedExerciseRemaining = currentExercise.defaultDurationSeconds;
      notifyListeners();
    }
  }

  void previousExercise() {
    if (_currentExerciseIndex > 0) {
      _currentExerciseIndex--;
      _completedSetsInCurrentExercise = 0;
      _isResting = false;
      _isTimedExerciseRunning = false;
      _timedExerciseRemaining = currentExercise.defaultDurationSeconds;
      notifyListeners();
    }
  }

  Future<TrainingRecord?> finishSession({String? userNotes}) async {
    if (!_isSessionActive) return null;

    final durationMin = (_sessionDurationSeconds / 60).ceil().clamp(1, 180);
    final difficulty = currentExercise.difficulty;

    final reward = BodyCultivationCalculator.calculateSessionReward(
      durationMinutes: durationMin,
      completedSets: _totalSetsCompleted,
      difficulty: difficulty,
    );

    final record = TrainingRecord(
      id: _uuid.v4(),
      sessionId: _currentTemplate?.id ?? 'custom_session',
      sessionTitle: _currentTemplate?.murimTitle ?? 'การฝึกฝนกายาอิสระ',
      completedAt: DateTime.now(),
      durationMinutes: durationMin,
      totalSetsCompleted: _totalSetsCompleted,
      earnedQi: reward.baseQi,
      earnedBodyXp: reward.bodyXp,
      userNotes: userNotes,
    );

    await _repository.saveTrainingRecord(record);
    _records = _repository.getTrainingRecords();

    _cleanupSession();
    notifyListeners();
    return record;
  }

  void cancelSession() {
    _cleanupSession();
    notifyListeners();
  }

  void _cleanupSession() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
    _isSessionActive = false;
    _currentTemplate = null;
    _sessionExercises = [];
    _currentExerciseIndex = 0;
    _completedSetsInCurrentExercise = 0;
    _totalSetsCompleted = 0;
    _sessionDurationSeconds = 0;
    _isResting = false;
    _restTimeRemaining = 0;
    _isTimedExerciseRunning = false;
    _timedExerciseRemaining = 0;
    _isTimerPaused = false;
  }

  Future<void> deleteRecord(String id) async {
    await _repository.deleteTrainingRecord(id);
    _records = _repository.getTrainingRecords();
    notifyListeners();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    super.dispose();
  }
}
