import 'cultivation_realm.dart';

class UserStats {
  final String userName;
  final String sectName;
  final int bodyXp;
  final int mindXp;
  final int martialXp;
  final int spiritualXp;
  final int totalQi;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActiveDate;
  final int completedMissionsCount;
  final int meditationMinutes;

  const UserStats({
    this.userName = 'จอมยุทธ์ไร้นาม',
    this.sectName = 'สำนักกระบี่ฟ้า',
    this.bodyXp = 0,
    this.mindXp = 0,
    this.martialXp = 0,
    this.spiritualXp = 0,
    this.totalQi = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActiveDate,
    this.completedMissionsCount = 0,
    this.meditationMinutes = 0,
  });

  CultivationRealm get currentRealm => CultivationRealm.fromQi(totalQi);

  double get realmProgress {
    final realm = currentRealm;
    if (realm.maxQi <= realm.minQi) return 1.0;
    final progress = (totalQi - realm.minQi) / (realm.maxQi - realm.minQi);
    return progress.clamp(0.0, 1.0);
  }

  int get qiNeededForNextRealm {
    final realm = currentRealm;
    return (realm.maxQi - totalQi).clamp(0, 999999);
  }

  UserStats copyWith({
    String? userName,
    String? sectName,
    int? bodyXp,
    int? mindXp,
    int? martialXp,
    int? spiritualXp,
    int? totalQi,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActiveDate,
    int? completedMissionsCount,
    int? meditationMinutes,
  }) {
    return UserStats(
      userName: userName ?? this.userName,
      sectName: sectName ?? this.sectName,
      bodyXp: bodyXp ?? this.bodyXp,
      mindXp: mindXp ?? this.mindXp,
      martialXp: martialXp ?? this.martialXp,
      spiritualXp: spiritualXp ?? this.spiritualXp,
      totalQi: totalQi ?? this.totalQi,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      completedMissionsCount: completedMissionsCount ?? this.completedMissionsCount,
      meditationMinutes: meditationMinutes ?? this.meditationMinutes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'sectName': sectName,
      'bodyXp': bodyXp,
      'mindXp': mindXp,
      'martialXp': martialXp,
      'spiritualXp': spiritualXp,
      'totalQi': totalQi,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastActiveDate': lastActiveDate?.toIso8601String(),
      'completedMissionsCount': completedMissionsCount,
      'meditationMinutes': meditationMinutes,
    };
  }

  factory UserStats.fromMap(Map<dynamic, dynamic> map) {
    return UserStats(
      userName: map['userName'] as String? ?? 'จอมยุทธ์ไร้นาม',
      sectName: map['sectName'] as String? ?? 'สำนักกระบี่ฟ้า',
      bodyXp: (map['bodyXp'] as num?)?.toInt() ?? 0,
      mindXp: (map['mindXp'] as num?)?.toInt() ?? 0,
      martialXp: (map['martialXp'] as num?)?.toInt() ?? 0,
      spiritualXp: (map['spiritualXp'] as num?)?.toInt() ?? 0,
      totalQi: (map['totalQi'] as num?)?.toInt() ?? 0,
      currentStreak: (map['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (map['longestStreak'] as num?)?.toInt() ?? 0,
      lastActiveDate: map['lastActiveDate'] != null
          ? DateTime.tryParse(map['lastActiveDate'] as String)
          : null,
      completedMissionsCount: (map['completedMissionsCount'] as num?)?.toInt() ?? 0,
      meditationMinutes: (map['meditationMinutes'] as num?)?.toInt() ?? 0,
    );
  }
}
