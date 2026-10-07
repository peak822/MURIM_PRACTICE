import 'dart:math' as math;
import '../../data/models/cultivation_category.dart';
import '../../data/models/cultivation_realm.dart';
import '../../data/models/user_stats_model.dart';

class CultivationCalculator {
  CultivationCalculator._();

  /// Calculate suggested Qi for a new mission based on difficulty and estimated duration
  static int calculateMissionXp({
    required int difficulty,
    required int estimatedMinutes,
    bool isDaily = false,
  }) {
    // Base XP by difficulty: 1 -> 25, 2 -> 50, 3 -> 100, 4 -> 200
    int base;
    switch (difficulty) {
      case 1:
        base = 25;
        break;
      case 2:
        base = 50;
        break;
      case 3:
        base = 100;
        break;
      case 4:
        base = 200;
        break;
      default:
        base = 25;
    }

    // Time bonus: 5 Qi for every 15 minutes of dedicated effort
    final int timeBonus = ((estimatedMinutes / 15).floor() * 5).clamp(0, 50);

    // Daily mission bonus
    final int dailyBonus = isDaily ? 10 : 0;

    return base + timeBonus + dailyBonus;
  }

  /// Calculate streak bonus percentage (capped at 30%)
  static double getStreakBonusMultiplier(int streakDays) {
    if (streakDays <= 0) return 1.0;
    // 2% per streak day, max 30% bonus
    final double bonus = math.min(streakDays * 0.02, 0.30);
    return 1.0 + bonus;
  }

  /// Calculate effective Qi gained with streak bonus applied
  static int calculateEffectiveQi(int baseQi, int streakDays) {
    final double multiplier = getStreakBonusMultiplier(streakDays);
    return (baseQi * multiplier).round();
  }

  /// Convert individual Stat XP into a Stat Level (1 - 99)
  /// Uses a smooth progressive formula: Level = floor(sqrt(statXp / 15)) + 1
  static int getStatLevel(int statXp) {
    if (statXp <= 0) return 1;
    final int level = (math.sqrt(statXp / 15)).floor() + 1;
    return level.clamp(1, 99);
  }

  /// Calculate percentage progress to next stat level (0.0 to 1.0)
  static double getStatLevelProgress(int statXp) {
    final int currentLevel = getStatLevel(statXp);
    final int currentLevelMinXp = (math.pow(currentLevel - 1, 2) * 15).round();
    final int nextLevelMinXp = (math.pow(currentLevel, 2) * 15).round();

    if (nextLevelMinXp <= currentLevelMinXp) return 1.0;
    final double progress = (statXp - currentLevelMinXp) / (nextLevelMinXp - currentLevelMinXp);
    return progress.clamp(0.0, 1.0);
  }

  /// Apply mission completion to UserStats and return updated stats + whether breakthrough happened
  static ({UserStats updatedStats, bool hasBreakthrough, CultivationRealm newRealm, int gainedQi})
      applyMissionCompletion({
    required UserStats currentStats,
    required CultivationCategory category,
    required int baseQiReward,
    required DateTime completionTime,
  }) {
    final int gainedQi = calculateEffectiveQi(baseQiReward, currentStats.currentStreak);

    // Update streak logic
    int newStreak = currentStats.currentStreak;
    final DateTime now = completionTime;
    final DateTime today = DateTime(now.year, now.month, now.day);

    if (currentStats.lastActiveDate == null) {
      newStreak = 1;
    } else {
      final DateTime lastActive = DateTime(
        currentStats.lastActiveDate!.year,
        currentStats.lastActiveDate!.month,
        currentStats.lastActiveDate!.day,
      );
      final int differenceDays = today.difference(lastActive).inDays;

      if (differenceDays == 0) {
        // Same day activity: keep streak
        newStreak = currentStats.currentStreak == 0 ? 1 : currentStats.currentStreak;
      } else if (differenceDays == 1) {
        // Consecutive day activity: increment streak
        newStreak = currentStats.currentStreak + 1;
      } else {
        // Streak broken (> 1 day gap): reset to 1
        newStreak = 1;
      }
    }

    final int newLongestStreak = math.max(currentStats.longestStreak, newStreak);

    // Calculate category XP increments
    int newBodyXp = currentStats.bodyXp;
    int newMindXp = currentStats.mindXp;
    int newMartialXp = currentStats.martialXp;
    int newSpiritualXp = currentStats.spiritualXp;

    switch (category) {
      case CultivationCategory.body:
        newBodyXp += gainedQi;
        break;
      case CultivationCategory.mind:
        newMindXp += gainedQi;
        break;
      case CultivationCategory.martial:
        newMartialXp += gainedQi;
        break;
      case CultivationCategory.spiritual:
        newSpiritualXp += gainedQi;
        break;
    }

    final int newTotalQi = currentStats.totalQi + gainedQi;
    final CultivationRealm oldRealm = currentStats.currentRealm;
    final CultivationRealm newRealm = CultivationRealm.fromQi(newTotalQi);
    final bool hasBreakthrough = newRealm.level > oldRealm.level;

    final UserStats updated = currentStats.copyWith(
      bodyXp: newBodyXp,
      mindXp: newMindXp,
      martialXp: newMartialXp,
      spiritualXp: newSpiritualXp,
      totalQi: newTotalQi,
      currentStreak: newStreak,
      longestStreak: newLongestStreak,
      lastActiveDate: now,
      completedMissionsCount: currentStats.completedMissionsCount + 1,
    );

    return (
      updatedStats: updated,
      hasBreakthrough: hasBreakthrough,
      newRealm: newRealm,
      gainedQi: gainedQi,
    );
  }

  /// Revert mission completion from UserStats (deducts Qi, stat XP, decrements completed count, clamped at 0)
  static ({UserStats updatedStats, int deductedQi}) revertMissionCompletion({
    required UserStats currentStats,
    required CultivationCategory category,
    required int baseQiReward,
  }) {
    final int deductedQi = calculateEffectiveQi(baseQiReward, currentStats.currentStreak);

    int newBodyXp = currentStats.bodyXp;
    int newMindXp = currentStats.mindXp;
    int newMartialXp = currentStats.martialXp;
    int newSpiritualXp = currentStats.spiritualXp;

    switch (category) {
      case CultivationCategory.body:
        newBodyXp = math.max(0, newBodyXp - deductedQi);
        break;
      case CultivationCategory.mind:
        newMindXp = math.max(0, newMindXp - deductedQi);
        break;
      case CultivationCategory.martial:
        newMartialXp = math.max(0, newMartialXp - deductedQi);
        break;
      case CultivationCategory.spiritual:
        newSpiritualXp = math.max(0, newSpiritualXp - deductedQi);
        break;
    }

    final int newTotalQi = math.max(0, currentStats.totalQi - deductedQi);
    final int newCompletedCount = math.max(0, currentStats.completedMissionsCount - 1);

    final UserStats updated = currentStats.copyWith(
      bodyXp: newBodyXp,
      mindXp: newMindXp,
      martialXp: newMartialXp,
      spiritualXp: newSpiritualXp,
      totalQi: newTotalQi,
      completedMissionsCount: newCompletedCount,
    );

    return (
      updatedStats: updated,
      deductedQi: deductedQi,
    );
  }

  /// Calculate 6 Radar Chart values normalized to 0.0 - 100.0
  /// Attributes:
  /// 1. พลังกาย (Body Vigor)
  /// 2. สติปัญญา (Mind & Wisdom)
  /// 3. วรยุทธ์ (Martial Skills)
  /// 4. สมาธิภาวนา (Meditation & Spiritual)
  /// 5. วินัยฝึกตน (Discipline & Streak)
  /// 6. พลังลมปราณ (Qi Density)
  static Map<String, double> calculateRadarAttributes(UserStats stats) {
    // Normalization scale factor (gradual logarithmic progression so high stats don't saturate instantly)
    double normalizeXp(int xp) {
      if (xp <= 0) return 10.0;
      // 100 xp -> ~30%, 500 xp -> ~60%, 1500 xp -> ~85%, 3000 xp -> ~95%
      final double val = 15.0 + (math.log(xp + 1) / math.log(5000)) * 85.0;
      return val.clamp(10.0, 100.0);
    }

    final double bodyScore = normalizeXp(stats.bodyXp);
    final double mindScore = normalizeXp(stats.mindXp);
    final double martialScore = normalizeXp(stats.martialXp);
    final double spiritualScore = normalizeXp(stats.spiritualXp + stats.meditationMinutes * 2);

    // Discipline based on streak and completed missions
    final double streakPart = math.min(stats.currentStreak * 8.0, 50.0);
    final double missionPart = math.min(stats.completedMissionsCount * 3.0, 50.0);
    final double disciplineScore = (10.0 + streakPart + missionPart).clamp(10.0, 100.0);

    // Qi density based on realm progress and total Qi
    final double qiScore = normalizeXp(stats.totalQi);

    return {
      'พลังกาย': bodyScore,
      'สติปัญญา': mindScore,
      'วรยุทธ์': martialScore,
      'สมาธิ': spiritualScore,
      'วินัย': disciplineScore,
      'ลมปราณ': qiScore,
    };
  }
}
