import 'cultivation_category.dart';

enum CultivationLogType {
  missionCompleted,
  realmBreakthrough,
  meditationCompleted,
  streakMilestone,
}

class CultivationLog {
  final String id;
  final String title;
  final String description;
  final int qiGained;
  final CultivationCategory? category;
  final CultivationLogType type;
  final DateTime timestamp;

  const CultivationLog({
    required this.id,
    required this.title,
    required this.description,
    required this.qiGained,
    this.category,
    required this.type,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'qiGained': qiGained,
      'category': category?.id,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CultivationLog.fromMap(Map<dynamic, dynamic> map) {
    return CultivationLog(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      qiGained: (map['qiGained'] as num?)?.toInt() ?? 0,
      category: map['category'] != null
          ? CultivationCategoryExtension.fromString(map['category'] as String)
          : null,
      type: CultivationLogType.values.firstWhere(
        (t) => t.name == map['type'],
        orElse: () => CultivationLogType.missionCompleted,
      ),
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
