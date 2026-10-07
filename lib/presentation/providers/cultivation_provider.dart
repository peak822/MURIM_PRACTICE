import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/utils/cultivation_calculator.dart';
import '../../data/models/cultivation_category.dart';
import '../../data/models/cultivation_realm.dart';
import '../../data/models/user_stats_model.dart';
import '../../data/models/cultivation_log.dart';
import '../../data/repositories/stats_repository.dart';

class CultivationProvider extends ChangeNotifier {
  final StatsRepository _repository;
  final _uuid = const Uuid();

  UserStats _stats = const UserStats();
  List<CultivationLog> _logs = [];
  bool _isLoading = false;

  // Breakthrough notification event for UI
  CultivationRealm? _latestBreakthroughRealm;
  CultivationRealm? get latestBreakthroughRealm => _latestBreakthroughRealm;

  CultivationProvider({StatsRepository? repository})
      : _repository = repository ?? StatsRepositoryImpl() {
    loadStats();
  }

  UserStats get stats => _stats;
  List<CultivationLog> get logs => _logs;
  bool get isLoading => _isLoading;
  CultivationRealm get currentRealm => _stats.currentRealm;
  double get realmProgress => _stats.realmProgress;
  int get qiNeeded => _stats.qiNeededForNextRealm;

  Map<String, double> get radarAttributes =>
      CultivationCalculator.calculateRadarAttributes(_stats);

  Future<void> loadStats() async {
    _isLoading = true;
    notifyListeners();

    _stats = _repository.getUserStats();
    _logs = _repository.getLogs();

    _isLoading = false;
    notifyListeners();
  }

  void clearBreakthroughNotice() {
    _latestBreakthroughRealm = null;
    notifyListeners();
  }

  /// Triggered when a mission is completed
  Future<({bool hasBreakthrough, CultivationRealm newRealm, int gainedQi})>
      recordMissionCompletion({
    required CultivationCategory category,
    required int baseQiReward,
    required String missionTitle,
  }) async {
    final result = CultivationCalculator.applyMissionCompletion(
      currentStats: _stats,
      category: category,
      baseQiReward: baseQiReward,
      completionTime: DateTime.now(),
    );

    _stats = result.updatedStats;
    await _repository.saveUserStats(_stats);

    // Create a cultivation log entry
    final log = CultivationLog(
      id: _uuid.v4(),
      title: 'ทำภารกิจสำเร็จ: $missionTitle',
      description: 'ได้รับพลังปราณ +${result.gainedQi} Qi (${category.thaiTitle})',
      qiGained: result.gainedQi,
      category: category,
      type: CultivationLogType.missionCompleted,
      timestamp: DateTime.now(),
    );

    await _repository.addLog(log);
    _logs.insert(0, log);

    // Check for breakthrough
    if (result.hasBreakthrough) {
      _latestBreakthroughRealm = result.newRealm;

      final breakthroughLog = CultivationLog(
        id: _uuid.v4(),
        title: 'ทะลวงด่านขอบเขต: ${result.newRealm.fullThaiTitle}!',
        description: result.newRealm.breakthroughQuote,
        qiGained: 0,
        type: CultivationLogType.realmBreakthrough,
        timestamp: DateTime.now(),
      );

      await _repository.addLog(breakthroughLog);
      _logs.insert(0, breakthroughLog);
    }

    notifyListeners();

    return (
      hasBreakthrough: result.hasBreakthrough,
      newRealm: result.newRealm,
      gainedQi: result.gainedQi,
    );
  }

  /// Triggered when a mission is unchecked/reverted
  Future<int> revertMissionCompletion({
    required CultivationCategory category,
    required int baseQiReward,
    required String missionTitle,
  }) async {
    final result = CultivationCalculator.revertMissionCompletion(
      currentStats: _stats,
      category: category,
      baseQiReward: baseQiReward,
    );

    _stats = result.updatedStats;
    await _repository.saveUserStats(_stats);

    // Add a log entry for reversion
    final log = CultivationLog(
      id: _uuid.v4(),
      title: 'ยกเลิกภารกิจ: $missionTitle',
      description: 'ปรับลดพลังปราณ -${result.deductedQi} Qi (${category.thaiTitle})',
      qiGained: -result.deductedQi,
      category: category,
      type: CultivationLogType.missionCompleted,
      timestamp: DateTime.now(),
    );

    await _repository.addLog(log);
    _logs.insert(0, log);

    notifyListeners();
    return result.deductedQi;
  }

  /// Triggered when completing a meditation / secluded cultivation session
  Future<int> recordMeditationSession({
    required int minutes,
  }) async {
    if (minutes <= 0) return 0;

    // 2 Qi per minute of focused meditation + small bonus for sessions >= 25 mins
    final int baseQi = (minutes * 2) + (minutes >= 25 ? 15 : 0);
    final int gainedQi = CultivationCalculator.calculateEffectiveQi(baseQi, _stats.currentStreak);

    final oldRealm = _stats.currentRealm;
    final int newTotalQi = _stats.totalQi + gainedQi;
    final int newSpiritualXp = _stats.spiritualXp + gainedQi;
    final int newMeditationMinutes = _stats.meditationMinutes + minutes;
    final newRealm = CultivationRealm.fromQi(newTotalQi);
    final bool hasBreakthrough = newRealm.level > oldRealm.level;

    _stats = _stats.copyWith(
      totalQi: newTotalQi,
      spiritualXp: newSpiritualXp,
      meditationMinutes: newMeditationMinutes,
    );

    await _repository.saveUserStats(_stats);

    final log = CultivationLog(
      id: _uuid.v4(),
      title: 'ปิดด่านบำเพ็ญสมาธิ $minutes นาที',
      description: 'ได้รับพลังปราณบริสุทธิ์ +$gainedQi Qi',
      qiGained: gainedQi,
      category: CultivationCategory.spiritual,
      type: CultivationLogType.meditationCompleted,
      timestamp: DateTime.now(),
    );

    await _repository.addLog(log);
    _logs.insert(0, log);

    if (hasBreakthrough) {
      _latestBreakthroughRealm = newRealm;

      final breakthroughLog = CultivationLog(
        id: _uuid.v4(),
        title: 'ทะลวงด่านขอบเขต: ${newRealm.fullThaiTitle}!',
        description: newRealm.breakthroughQuote,
        qiGained: 0,
        type: CultivationLogType.realmBreakthrough,
        timestamp: DateTime.now(),
      );

      await _repository.addLog(breakthroughLog);
      _logs.insert(0, breakthroughLog);
    }

    notifyListeners();
    return gainedQi;
  }

  Future<void> updateProfile({String? userName, String? sectName}) async {
    _stats = _stats.copyWith(
      userName: userName ?? _stats.userName,
      sectName: sectName ?? _stats.sectName,
    );
    await _repository.saveUserStats(_stats);
    notifyListeners();
  }

  Future<void> resetAllProgress() async {
    await _repository.resetAllData();
    await loadStats();
  }
}
