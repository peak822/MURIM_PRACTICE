import 'package:flutter_test/flutter_test.dart';
import 'package:murim_app/core/services/daily_reset_manager.dart';
import 'package:murim_app/data/models/cultivation_category.dart';
import 'package:murim_app/data/models/mission_model.dart';

void main() {
  group('DailyResetManager Tests', () {
    test('resets completed isDaily missions when current date is past last active date', () {
      final lastActive = DateTime(2026, 10, 1, 10, 0);
      final today = DateTime(2026, 10, 2, 8, 0);

      final dailyMission = Mission(
        id: 'daily_1',
        title: 'Daily Scripture Reading',
        category: CultivationCategory.mind,
        xpReward: 30,
        isDaily: true,
        isCompleted: true,
        completedAt: lastActive,
        createdAt: lastActive,
      );

      final normalMission = Mission(
        id: 'normal_1',
        title: 'One-off Mission',
        category: CultivationCategory.martial,
        xpReward: 50,
        isDaily: false,
        isCompleted: true,
        completedAt: lastActive,
        createdAt: lastActive,
      );

      final result = DailyResetManager.evaluateDailyReset(
        missions: [dailyMission, normalMission],
        lastActiveDate: lastActive,
        currentTime: today,
      );

      expect(result.hasReset, isTrue);
      expect(result.resetCount, equals(1));

      final updatedDaily = result.updatedMissions.firstWhere((m) => m.id == 'daily_1');
      expect(updatedDaily.isCompleted, isFalse);
      expect(updatedDaily.completedAt, isNull);

      final updatedNormal = result.updatedMissions.firstWhere((m) => m.id == 'normal_1');
      expect(updatedNormal.isCompleted, isTrue);
    });

    test('does not reset if called multiple times on the same calendar day', () {
      final todayMorning = DateTime(2026, 10, 2, 8, 0);
      final todayEvening = DateTime(2026, 10, 2, 20, 0);

      final dailyMission = Mission(
        id: 'daily_1',
        title: 'Daily Meditation',
        category: CultivationCategory.spiritual,
        xpReward: 30,
        isDaily: true,
        isCompleted: true,
        completedAt: todayMorning,
        createdAt: todayMorning,
      );

      final result = DailyResetManager.evaluateDailyReset(
        missions: [dailyMission],
        lastActiveDate: todayMorning,
        currentTime: todayEvening,
      );

      expect(result.hasReset, isFalse);
      expect(result.resetCount, equals(0));
    });
  });
}
