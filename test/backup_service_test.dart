import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:murim_app/core/services/backup_service.dart';
import 'package:murim_app/data/models/cultivation_category.dart';
import 'package:murim_app/data/models/cultivation_log.dart';
import 'package:murim_app/data/models/mission_model.dart';
import 'package:murim_app/data/models/user_stats_model.dart';

void main() {
  group('BackupService Tests', () {
    test('serializes state payload to valid JSON with schemaVersion 1', () {
      final now = DateTime(2026, 10, 7, 12, 0);
      final stats = const UserStats(userName: 'Master Ling', totalQi: 1500);
      final missions = [
        Mission(
          id: 'm1',
          title: 'Sword Stance',
          category: CultivationCategory.martial,
          xpReward: 50,
          createdAt: now,
        )
      ];
      final logs = [
        CultivationLog(
          id: 'l1',
          title: 'Breakthrough',
          description: 'Reached Tier 2',
          qiGained: 100,
          type: CultivationLogType.realmBreakthrough,
          timestamp: now,
        )
      ];

      final jsonStr = BackupService.buildBackupJson(
        stats: stats,
        missions: missions,
        logs: logs,
        settings: {'sound_enabled': true},
        exportedAt: now,
      );

      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      expect(decoded['schemaVersion'], equals(1));
      expect(decoded['userStats']['userName'], equals('Master Ling'));
      expect(decoded['missions'], hasLength(1));
      expect(decoded['cultivationLogs'], hasLength(1));
    });

    test('validates backup JSON and catches malformed payloads', () {
      const invalidJson = '{"schemaVersion": 2}'; // missing userStats
      final validation = BackupService.validateBackupJson(invalidJson);
      expect(validation.isValid, isFalse);
      expect(validation.errorMessage, isNotNull);

      final validMap = {
        'schemaVersion': 1,
        'exportedAt': DateTime.now().toIso8601String(),
        'userStats': const UserStats().toMap(),
        'missions': [],
        'cultivationLogs': [],
      };
      final validValidation = BackupService.validateBackupJson(jsonEncode(validMap));
      expect(validValidation.isValid, isTrue);
      expect(validValidation.errorMessage, isNull);
    });
  });
}
