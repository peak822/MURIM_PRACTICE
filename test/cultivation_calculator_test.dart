import 'package:flutter_test/flutter_test.dart';
import 'package:murim_app/core/utils/cultivation_calculator.dart';
import 'package:murim_app/data/models/cultivation_category.dart';
import 'package:murim_app/data/models/user_stats_model.dart';

void main() {
  group('CultivationCalculator - Mission XP Calculation', () {
    test('calculateMissionXp calculates correct base XP for difficulties', () {
      expect(CultivationCalculator.calculateMissionXp(difficulty: 1, estimatedMinutes: 0), 25);
      expect(CultivationCalculator.calculateMissionXp(difficulty: 2, estimatedMinutes: 0), 50);
      expect(CultivationCalculator.calculateMissionXp(difficulty: 3, estimatedMinutes: 0), 100);
      expect(CultivationCalculator.calculateMissionXp(difficulty: 4, estimatedMinutes: 0), 200);
    });

    test('calculateMissionXp adds duration bonus and daily bonus', () {
      // 30 mins = 2 blocks of 15m -> +10 Qi
      final xp = CultivationCalculator.calculateMissionXp(
        difficulty: 1,
        estimatedMinutes: 30,
        isDaily: true,
      );
      // 25 (base) + 10 (time) + 10 (daily) = 45
      expect(xp, 45);
    });

    test('calculateEffectiveQi applies streak multiplier correctly', () {
      expect(CultivationCalculator.calculateEffectiveQi(100, 0), 100);
      // 5 streak days = 5 * 2% = 10% bonus -> 110 Qi
      expect(CultivationCalculator.calculateEffectiveQi(100, 5), 110);
      // Max streak bonus capped at 30%
      expect(CultivationCalculator.calculateEffectiveQi(100, 50), 130);
    });
  });

  group('CultivationCalculator - Stat Leveling Curve', () {
    test('getStatLevel returns progressive levels', () {
      expect(CultivationCalculator.getStatLevel(0), 1);
      expect(CultivationCalculator.getStatLevel(15), 2);
      expect(CultivationCalculator.getStatLevel(60), 3);
      expect(CultivationCalculator.getStatLevel(135), 4);
    });

    test('getStatLevelProgress returns value between 0.0 and 1.0', () {
      final progress = CultivationCalculator.getStatLevelProgress(50);
      expect(progress, greaterThanOrEqualTo(0.0));
      expect(progress, lessThanOrEqualTo(1.0));
    });
  });

  group('CultivationCalculator - applyMissionCompletion & Breakthrough', () {
    test('applyMissionCompletion updates stats, adds Qi and increments streak', () {
      const initialStats = UserStats(
        bodyXp: 0,
        mindXp: 10,
        totalQi: 50,
        currentStreak: 0,
      );

      final result = CultivationCalculator.applyMissionCompletion(
        currentStats: initialStats,
        category: CultivationCategory.mind,
        baseQiReward: 40,
        completionTime: DateTime(2026, 9, 30),
      );

      expect(result.updatedStats.mindXp, 50);
      expect(result.updatedStats.totalQi, 90);
      expect(result.updatedStats.currentStreak, 1);
      expect(result.updatedStats.completedMissionsCount, 1);
      expect(result.hasBreakthrough, false); // Still within level 1 (0-100 Qi)
    });

    test('applyMissionCompletion detects realm breakthrough when Qi exceeds threshold', () {
      const initialStats = UserStats(
        totalQi: 90, // Level 1 is 0-100 Qi
        currentStreak: 1,
      );

      final result = CultivationCalculator.applyMissionCompletion(
        currentStats: initialStats,
        category: CultivationCategory.martial,
        baseQiReward: 50, // +50 Qi -> totalQi = 141 (with 2% streak bonus)
        completionTime: DateTime(2026, 9, 30),
      );

      expect(result.hasBreakthrough, true);
      expect(result.newRealm.level, 2); // Qi Condensation (Mid stage)
    });
  });

  group('CultivationCalculator - revertMissionCompletion', () {
    test('revertMissionCompletion deducts Qi and stat XP cleanly and clamps at 0', () {
      const initialStats = UserStats(
        bodyXp: 100,
        mindXp: 50,
        totalQi: 150,
        completedMissionsCount: 3,
        currentStreak: 0,
      );

      final result = CultivationCalculator.revertMissionCompletion(
        currentStats: initialStats,
        category: CultivationCategory.mind,
        baseQiReward: 50,
      );

      expect(result.updatedStats.mindXp, 0);
      expect(result.updatedStats.totalQi, 100);
      expect(result.updatedStats.completedMissionsCount, 2);
      expect(result.deductedQi, 50);
    });

    test('revertMissionCompletion never produces negative stats', () {
      const initialStats = UserStats(
        bodyXp: 10,
        totalQi: 10,
        completedMissionsCount: 1,
      );

      final result = CultivationCalculator.revertMissionCompletion(
        currentStats: initialStats,
        category: CultivationCategory.body,
        baseQiReward: 100,
      );

      expect(result.updatedStats.bodyXp, 0);
      expect(result.updatedStats.totalQi, 0);
      expect(result.updatedStats.completedMissionsCount, 0);
    });
  });

  group('CultivationCalculator - Radar Attributes', () {
    test('calculateRadarAttributes returns 6 valid attributes', () {
      const stats = UserStats(
        bodyXp: 100,
        mindXp: 200,
        martialXp: 150,
        spiritualXp: 50,
        totalQi: 500,
        currentStreak: 3,
        completedMissionsCount: 5,
      );

      final radar = CultivationCalculator.calculateRadarAttributes(stats);

      expect(radar.keys.length, 6);
      expect(radar.containsKey('พลังกาย'), true);
      expect(radar.containsKey('สติปัญญา'), true);
      expect(radar.containsKey('วรยุทธ์'), true);
      expect(radar.containsKey('สมาธิ'), true);
      expect(radar.containsKey('วินัย'), true);
      expect(radar.containsKey('ลมปราณ'), true);

      for (final value in radar.values) {
        expect(value, greaterThanOrEqualTo(10.0));
        expect(value, lessThanOrEqualTo(100.0));
      }
    });
  });
}
