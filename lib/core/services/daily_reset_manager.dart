import 'package:flutter/foundation.dart';
import '../../data/datasources/hive_storage_service.dart';
import '../../data/models/mission_model.dart';

class DailyResetResult {
  final bool hasReset;
  final int resetCount;
  final List<Mission> updatedMissions;

  const DailyResetResult({
    required this.hasReset,
    required this.resetCount,
    required this.updatedMissions,
  });
}

class DailyResetManager {
  DailyResetManager._();

  /// Pure evaluation logic for daily mission reset
  static DailyResetResult evaluateDailyReset({
    required List<Mission> missions,
    required DateTime? lastActiveDate,
    required DateTime currentTime,
  }) {
    if (lastActiveDate == null) {
      return DailyResetResult(
        hasReset: false,
        resetCount: 0,
        updatedMissions: missions,
      );
    }

    final currentDate = DateTime(currentTime.year, currentTime.month, currentTime.day);
    final lastDate = DateTime(lastActiveDate.year, lastActiveDate.month, lastActiveDate.day);

    if (currentDate.isAfter(lastDate)) {
      int resetCount = 0;
      final updatedList = missions.map((mission) {
        if (mission.isDaily && mission.isCompleted) {
          resetCount++;
          return mission.copyWith(
            isCompleted: false,
            clearCompletedAt: true,
          );
        }
        return mission;
      }).toList();

      return DailyResetResult(
        hasReset: resetCount > 0,
        resetCount: resetCount,
        updatedMissions: updatedList,
      );
    }

    return DailyResetResult(
      hasReset: false,
      resetCount: 0,
      updatedMissions: missions,
    );
  }

  /// Stateful execution against Hive storage
  static Future<DailyResetResult> checkAndResetDailyMissions({
    required HiveStorageService storage,
    DateTime? currentTime,
  }) async {
    try {
      final now = currentTime ?? DateTime.now();
      final stats = storage.getUserStats();
      final missions = storage.getAllMissions();

      final result = evaluateDailyReset(
        missions: missions,
        lastActiveDate: stats.lastActiveDate,
        currentTime: now,
      );

      if (result.hasReset) {
        for (final mission in result.updatedMissions) {
          if (mission.isDaily && !mission.isCompleted) {
            await storage.saveMission(mission);
          }
        }
        await storage.setSetting('last_daily_reset', now.toIso8601String());
      }

      return result;
    } catch (e) {
      debugPrint('Error executing DailyResetManager: $e');
      return DailyResetResult(
        hasReset: false,
        resetCount: 0,
        updatedMissions: storage.getAllMissions(),
      );
    }
  }
}
