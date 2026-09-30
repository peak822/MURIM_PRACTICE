import 'package:flutter_test/flutter_test.dart';
import 'package:murim_app/data/models/cultivation_category.dart';
import 'package:murim_app/data/models/cultivation_log.dart';
import 'package:murim_app/data/models/mission_model.dart';
import 'package:murim_app/data/models/user_stats_model.dart';

void main() {
  group('Mission Model Tests', () {
    test('Mission serialization toMap and fromMap works seamlessly', () {
      final now = DateTime(2026, 9, 30, 12, 0);
      final mission = Mission(
        id: 'mission_123',
        title: 'ฝึกเพลงกระบี่ 9 สาย',
        description: 'ทบทวนกระบวนท่าและเขียนโค้ด',
        category: CultivationCategory.martial,
        xpReward: 75,
        difficulty: 3,
        estimatedMinutes: 45,
        isCompleted: true,
        completedAt: now,
        createdAt: now,
        isDaily: true,
        tags: ['กระบี่', 'วรยุทธ์'],
      );

      final map = mission.toMap();
      final fromMap = Mission.fromMap(map);

      expect(fromMap.id, mission.id);
      expect(fromMap.title, mission.title);
      expect(fromMap.category, CultivationCategory.martial);
      expect(fromMap.xpReward, 75);
      expect(fromMap.difficulty, 3);
      expect(fromMap.isCompleted, true);
      expect(fromMap.isDaily, true);
      expect(fromMap.tags, ['กระบี่', 'วรยุทธ์']);
    });

    test('Mission copyWith updates specific fields properly', () {
      final mission = Mission(
        id: '1',
        title: 'อ่านหนังสือ',
        category: CultivationCategory.mind,
        xpReward: 30,
        createdAt: DateTime.now(),
      );

      final completed = mission.copyWith(isCompleted: true);
      expect(completed.isCompleted, true);
      expect(completed.title, 'อ่านหนังสือ');
    });
  });

  group('UserStats Model Tests', () {
    test('UserStats serialization and progress calculations', () {
      final stats = const UserStats(
        userName: 'หลินเฟิง',
        sectName: 'สำนักกระบี่เมฆา',
        bodyXp: 50,
        mindXp: 80,
        martialXp: 120,
        spiritualXp: 30,
        totalQi: 280, // Level 3: 250 - 450 Qi
        currentStreak: 5,
        longestStreak: 7,
      );

      expect(stats.currentRealm.level, 3);
      expect(stats.realmProgress, greaterThan(0.0));
      expect(stats.realmProgress, lessThan(1.0));
      expect(stats.qiNeededForNextRealm, 450 - 280);

      final map = stats.toMap();
      final restored = UserStats.fromMap(map);

      expect(restored.userName, 'หลินเฟิง');
      expect(restored.sectName, 'สำนักกระบี่เมฆา');
      expect(restored.totalQi, 280);
      expect(restored.currentStreak, 5);
    });
  });

  group('CultivationLog Model Tests', () {
    test('CultivationLog serialization toMap and fromMap', () {
      final log = CultivationLog(
        id: 'log_1',
        title: 'ทะลวงด่านสำเร็จ',
        description: 'ขึ้นสู่ขั้นกลาง',
        qiGained: 50,
        category: CultivationCategory.spiritual,
        type: CultivationLogType.realmBreakthrough,
        timestamp: DateTime(2026, 9, 30),
      );

      final map = log.toMap();
      final restored = CultivationLog.fromMap(map);

      expect(restored.id, 'log_1');
      expect(restored.type, CultivationLogType.realmBreakthrough);
      expect(restored.qiGained, 50);
    });
  });
}
