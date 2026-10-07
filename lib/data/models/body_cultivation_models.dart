enum ExerciseCategory {
  lowerBody('ช่วงล่าง (ขาและสะโพก)'),
  upperBody('ช่วงบน (อก ไหล่ แขน)'),
  core('แกนกลางลำตัว'),
  mobility('ยืดเหยียดและข้อต่อ'),
  conditioning('ความทนทานหัวใจ');

  final String thaiLabel;
  const ExerciseCategory(this.thaiLabel);
}

enum ExerciseDifficulty {
  beginner('ขั้นต้น (Beginner)', 1),
  novice('ขั้นรากฐาน (Novice)', 2),
  intermediate('ขั้นกลาง (Intermediate)', 3),
  advanced('ขั้นสูง (Advanced)', 4);

  final String thaiLabel;
  final int tier;
  const ExerciseDifficulty(this.thaiLabel, this.tier);
}

class Exercise {
  final String id;
  final String name;
  final String murimName;
  final ExerciseCategory category;
  final ExerciseDifficulty difficulty;
  final List<String> targetMuscles;
  final String equipment;
  final String startingPosition;
  final String movementInstruction;
  final String breathingInstruction;
  final List<String> safetyNotes;
  final List<String> commonMistakes;
  final String? easierVariationId;
  final String? harderVariationId;
  final int defaultSets;
  final int defaultReps;
  final int defaultDurationSeconds;
  final int defaultRestSeconds;

  const Exercise({
    required this.id,
    required this.name,
    required this.murimName,
    required this.category,
    required this.difficulty,
    required this.targetMuscles,
    this.equipment = 'ไม่ต้องใช้อุปกรณ์',
    required this.startingPosition,
    required this.movementInstruction,
    required this.breathingInstruction,
    this.safetyNotes = const [],
    this.commonMistakes = const [],
    this.easierVariationId,
    this.harderVariationId,
    this.defaultSets = 3,
    this.defaultReps = 10,
    this.defaultDurationSeconds = 0,
    this.defaultRestSeconds = 45,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'murimName': murimName,
      'category': category.name,
      'difficulty': difficulty.name,
      'targetMuscles': targetMuscles,
      'equipment': equipment,
      'startingPosition': startingPosition,
      'movementInstruction': movementInstruction,
      'breathingInstruction': breathingInstruction,
      'safetyNotes': safetyNotes,
      'commonMistakes': commonMistakes,
      'easierVariationId': easierVariationId,
      'harderVariationId': harderVariationId,
      'defaultSets': defaultSets,
      'defaultReps': defaultReps,
      'defaultDurationSeconds': defaultDurationSeconds,
      'defaultRestSeconds': defaultRestSeconds,
    };
  }

  factory Exercise.fromMap(Map<dynamic, dynamic> map) {
    return Exercise(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      murimName: map['murimName'] as String? ?? '',
      category: ExerciseCategory.values.firstWhere(
        (c) => c.name == map['category'],
        orElse: () => ExerciseCategory.upperBody,
      ),
      difficulty: ExerciseDifficulty.values.firstWhere(
        (d) => d.name == map['difficulty'],
        orElse: () => ExerciseDifficulty.beginner,
      ),
      targetMuscles: (map['targetMuscles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      equipment: map['equipment'] as String? ?? 'ไม่ต้องใช้อุปกรณ์',
      startingPosition: map['startingPosition'] as String? ?? '',
      movementInstruction: map['movementInstruction'] as String? ?? '',
      breathingInstruction: map['breathingInstruction'] as String? ?? '',
      safetyNotes: (map['safetyNotes'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      commonMistakes: (map['commonMistakes'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      easierVariationId: map['easierVariationId'] as String?,
      harderVariationId: map['harderVariationId'] as String?,
      defaultSets: (map['defaultSets'] as num?)?.toInt() ?? 3,
      defaultReps: (map['defaultReps'] as num?)?.toInt() ?? 10,
      defaultDurationSeconds: (map['defaultDurationSeconds'] as num?)?.toInt() ?? 0,
      defaultRestSeconds: (map['defaultRestSeconds'] as num?)?.toInt() ?? 45,
    );
  }
}

class BodyRealm {
  final int level;
  final String thaiName;
  final String englishName;
  final String description;
  final int minBodyXp;
  final int maxBodyXp;

  const BodyRealm({
    required this.level,
    required this.thaiName,
    required this.englishName,
    required this.description,
    required this.minBodyXp,
    required this.maxBodyXp,
  });
}

class TrainingSessionTemplate {
  final String id;
  final String title;
  final String murimTitle;
  final int targetRealmLevel;
  final int estimatedMinutes;
  final List<String> exerciseIds;
  final String description;

  const TrainingSessionTemplate({
    required this.id,
    required this.title,
    required this.murimTitle,
    required this.targetRealmLevel,
    required this.estimatedMinutes,
    required this.exerciseIds,
    required this.description,
  });
}

class TrainingRecord {
  final String id;
  final String sessionId;
  final String sessionTitle;
  final DateTime completedAt;
  final int durationMinutes;
  final int totalSetsCompleted;
  final int earnedQi;
  final int earnedBodyXp;
  final String? userNotes;

  const TrainingRecord({
    required this.id,
    required this.sessionId,
    required this.sessionTitle,
    required this.completedAt,
    required this.durationMinutes,
    required this.totalSetsCompleted,
    required this.earnedQi,
    required this.earnedBodyXp,
    this.userNotes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sessionId': sessionId,
      'sessionTitle': sessionTitle,
      'completedAt': completedAt.toIso8601String(),
      'durationMinutes': durationMinutes,
      'totalSetsCompleted': totalSetsCompleted,
      'earnedQi': earnedQi,
      'earnedBodyXp': earnedBodyXp,
      'userNotes': userNotes,
    };
  }

  factory TrainingRecord.fromMap(Map<dynamic, dynamic> map) {
    return TrainingRecord(
      id: map['id'] as String? ?? '',
      sessionId: map['sessionId'] as String? ?? '',
      sessionTitle: map['sessionTitle'] as String? ?? '',
      completedAt: map['completedAt'] != null
          ? DateTime.tryParse(map['completedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      durationMinutes: (map['durationMinutes'] as num?)?.toInt() ?? 0,
      totalSetsCompleted: (map['totalSetsCompleted'] as num?)?.toInt() ?? 0,
      earnedQi: (map['earnedQi'] as num?)?.toInt() ?? 0,
      earnedBodyXp: (map['earnedBodyXp'] as num?)?.toInt() ?? 0,
      userNotes: map['userNotes'] as String?,
    );
  }
}
