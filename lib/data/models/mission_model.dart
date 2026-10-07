import 'cultivation_category.dart';

class Mission {
  final String id;
  final String title;
  final String description;
  final CultivationCategory category;
  final int xpReward;
  final int difficulty; // 1: Easy, 2: Medium, 3: Hard, 4: Boss
  final int estimatedMinutes;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime? dueDate;
  final bool isDaily;
  final List<String> tags;

  const Mission({
    required this.id,
    required this.title,
    this.description = '',
    required this.category,
    required this.xpReward,
    this.difficulty = 1,
    this.estimatedMinutes = 25,
    this.isCompleted = false,
    this.completedAt,
    required this.createdAt,
    this.dueDate,
    this.isDaily = false,
    this.tags = const [],
  });

  Mission copyWith({
    String? id,
    String? title,
    String? description,
    CultivationCategory? category,
    int? xpReward,
    int? difficulty,
    int? estimatedMinutes,
    bool? isCompleted,
    DateTime? completedAt,
    bool clearCompletedAt = false,
    DateTime? createdAt,
    DateTime? dueDate,
    bool? isDaily,
    List<String>? tags,
  }) {
    return Mission(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      xpReward: xpReward ?? this.xpReward,
      difficulty: difficulty ?? this.difficulty,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      isDaily: isDaily ?? this.isDaily,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.id,
      'xpReward': xpReward,
      'difficulty': difficulty,
      'estimatedMinutes': estimatedMinutes,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'isDaily': isDaily,
      'tags': tags,
    };
  }

  factory Mission.fromMap(Map<dynamic, dynamic> map) {
    return Mission(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      category: CultivationCategoryExtension.fromString(map['category'] as String? ?? 'spiritual'),
      xpReward: (map['xpReward'] as num?)?.toInt() ?? 20,
      difficulty: (map['difficulty'] as num?)?.toInt() ?? 1,
      estimatedMinutes: (map['estimatedMinutes'] as num?)?.toInt() ?? 25,
      isCompleted: map['isCompleted'] as bool? ?? false,
      completedAt: map['completedAt'] != null ? DateTime.tryParse(map['completedAt'] as String) : null,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      dueDate: map['dueDate'] != null ? DateTime.tryParse(map['dueDate'] as String) : null,
      isDaily: map['isDaily'] as bool? ?? false,
      tags: (map['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  String get difficultyThaiLabel {
    switch (difficulty) {
      case 1:
        return 'ภารกิจระดับต่ำ (ฝึกก้าวแรก)';
      case 2:
        return 'ภารกิจระดับกลาง (ฝึกฝนจริง)';
      case 3:
        return 'ภารกิจระดับสูง (ท้าทายตนเอง)';
      case 4:
        return 'ภารกิจระดับสุดยอด (ทะลวงขีดจำกัด)';
      default:
        return 'ภารกิจทั่วไป';
    }
  }
}
