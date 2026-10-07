import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import '../../data/datasources/hive_storage_service.dart';
import '../../data/models/cultivation_log.dart';
import '../../data/models/mission_model.dart';
import '../../data/models/user_stats_model.dart';

class BackupValidationResult {
  final bool isValid;
  final String? errorMessage;
  final Map<String, dynamic>? data;

  const BackupValidationResult({
    required this.isValid,
    this.errorMessage,
    this.data,
  });
}

class BackupService {
  BackupService._();

  static const int currentSchemaVersion = 1;

  /// Pure serialization to JSON String
  static String buildBackupJson({
    required UserStats stats,
    required List<Mission> missions,
    required List<CultivationLog> logs,
    required Map<String, dynamic> settings,
    DateTime? exportedAt,
  }) {
    final payload = {
      'schemaVersion': currentSchemaVersion,
      'exportedAt': (exportedAt ?? DateTime.now()).toIso8601String(),
      'appVersion': AppConstants.appVersion,
      'userStats': stats.toMap(),
      'missions': missions.map((m) => m.toMap()).toList(),
      'cultivationLogs': logs.map((l) => l.toMap()).toList(),
      'settings': settings,
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  /// Pure validation of backup JSON
  static BackupValidationResult validateBackupJson(String jsonString) {
    try {
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        return const BackupValidationResult(
          isValid: false,
          errorMessage: 'โครงสร้างไฟล์สำรองไม่ถูกต้อง (Invalid root format)',
        );
      }

      final schemaVersion = decoded['schemaVersion'];
      if (schemaVersion != 1) {
        return BackupValidationResult(
          isValid: false,
          errorMessage: 'เวอร์ชันไฟล์สำรองไม่รองรับ (Schema version: $schemaVersion)',
        );
      }

      if (decoded['userStats'] is! Map) {
        return const BackupValidationResult(
          isValid: false,
          errorMessage: 'ข้อมูลสเตตัสผู้ฝึกตนสูญหายหรือเสียหาย',
        );
      }

      if (decoded['missions'] is! List) {
        return const BackupValidationResult(
          isValid: false,
          errorMessage: 'ข้อมูลเทียบภารกิจไม่ถูกต้อง',
        );
      }

      return BackupValidationResult(isValid: true, data: decoded);
    } catch (e) {
      return BackupValidationResult(
        isValid: false,
        errorMessage: 'ไม่สามารถอ่านไฟล์ JSON ได้: ${e.toString()}',
      );
    }
  }

  /// Export current state from HiveStorageService
  static String exportStorageToJson(HiveStorageService storage) {
    final stats = storage.getUserStats();
    final missions = storage.getAllMissions();
    final logs = storage.getAllLogs();
    final settings = {
      'sound_enabled': storage.getSetting(AppConstants.keySoundEnabled, true),
      'haptic_enabled': storage.getSetting(AppConstants.keyHapticEnabled, true),
    };

    return buildBackupJson(
      stats: stats,
      missions: missions,
      logs: logs,
      settings: settings,
    );
  }

  /// Restore state into HiveStorageService
  static Future<bool> restoreJsonToStorage({
    required HiveStorageService storage,
    required String jsonString,
  }) async {
    final validation = validateBackupJson(jsonString);
    if (!validation.isValid || validation.data == null) {
      return false;
    }

    try {
      final data = validation.data!;
      final statsMap = data['userStats'] as Map<dynamic, dynamic>;
      final missionsList = data['missions'] as List<dynamic>;
      final logsList = (data['cultivationLogs'] as List<dynamic>?) ?? [];
      final settingsMap = (data['settings'] as Map<dynamic, dynamic>?) ?? {};

      // Clear existing state
      await storage.resetAllData();

      // Restore User Stats
      final stats = UserStats.fromMap(statsMap);
      await storage.saveUserStats(stats);

      // Restore Missions
      for (final m in missionsList) {
        if (m is Map) {
          final mission = Mission.fromMap(m);
          await storage.saveMission(mission);
        }
      }

      // Restore Logs
      for (final l in logsList) {
        if (l is Map) {
          final log = CultivationLog.fromMap(l);
          await storage.addLog(log);
        }
      }

      // Restore Settings
      if (settingsMap.containsKey('sound_enabled')) {
        await storage.setSetting(AppConstants.keySoundEnabled, settingsMap['sound_enabled']);
      }
      if (settingsMap.containsKey('haptic_enabled')) {
        await storage.setSetting(AppConstants.keyHapticEnabled, settingsMap['haptic_enabled']);
      }

      return true;
    } catch (e) {
      debugPrint('Error restoring backup to storage: $e');
      return false;
    }
  }
}
