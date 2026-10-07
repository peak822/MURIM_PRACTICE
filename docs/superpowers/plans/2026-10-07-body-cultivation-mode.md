# Body Cultivation Mode (โหมดบ่มเพาะกาย) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement the complete Body Cultivation Mode (โหมดบ่มเพาะกาย) combining real progressive bodyweight calisthenics, 5 Body Cultivation Realms, an active training timer session, searchable exercise codex, and seamless integration with `UserStats.bodyXp` and `BaguaRadarChart`.

**Architecture:** Domain models (`Exercise`, `BodyRealm`, `TrainingRecord`), pure calculation engine (`BodyCultivationCalculator`), repository layer with Hive persistence (`BodyCultivationRepository`), reactive provider (`BodyCultivationProvider`), and Wuxia-themed presentation screens.

**Tech Stack:** Flutter 3.44.5, Dart 3.12.2, Provider, Hive, GoogleFonts, fl_chart, intl, uuid.

## Global Constraints
- Real-world, safe exercises only: no medically unverified or dangerous movements.
- Built-in regression (easier alternative) for all major movements.
- Full offline-first support with Hive local storage.
- Preserve all existing 26 unit tests and zero `dart analyze` warnings.
- Seamless credit to `UserStats.bodyXp` and `UserStats.totalQi`.

---

### Task 1: Body Cultivation Data Models & Calculator

**Files:**
- Create: `lib/data/models/body_cultivation_models.dart`
- Create: `lib/core/utils/body_cultivation_calculator.dart`
- Test: `test/body_cultivation_test.dart`

**Interfaces:**
- Consumes: None (Pure Domain Models)
- Produces: `Exercise`, `BodyRealm`, `TrainingSessionTemplate`, `TrainingRecord`, `BodyCultivationCalculator`

- [ ] **Step 1: Write failing unit tests for Body Cultivation Models & Calculator**

Create `test/body_cultivation_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:murim_app/core/utils/body_cultivation_calculator.dart';
import 'package:murim_app/data/models/body_cultivation_models.dart';

void main() {
  group('Body Cultivation Domain Tests', () {
    test('BodyRealm correctly maps cumulative bodyXp to 5 realms', () {
      final realm0 = BodyCultivationCalculator.getBodyRealm(0);
      expect(realm0.level, equals(1));
      expect(realm0.thaiName, equals('เบิกเนตรกายา'));

      final realm1 = BodyCultivationCalculator.getBodyRealm(600);
      expect(realm1.level, equals(2));
      expect(realm1.thaiName, equals('หลอมรวมเส้นเอ็น'));

      final realm4 = BodyCultivationCalculator.getBodyRealm(12000);
      expect(realm4.level, equals(5));
      expect(realm4.thaiName, equals('กายาวชิระไร้พ่าย'));
    });

    test('calculates accurate session Qi and Body XP', () {
      final reward = BodyCultivationCalculator.calculateSessionReward(
        durationMinutes: 20,
        completedSets: 12,
        difficulty: ExerciseDifficulty.beginner,
      );
      // (20 * 2.5) + (12 * 3) + 10 = 50 + 36 + 10 = 96
      expect(reward.baseQi, equals(96));
      expect(reward.bodyXp, equals(96));
    });

    test('Exercise serialization and regression link works', () {
      final pushup = Exercise(
        id: 'pushup_std',
        name: 'Standard Push-up',
        murimName: 'วิชาฝ่ามือผลักภูผา',
        category: ExerciseCategory.upperBody,
        difficulty: ExerciseDifficulty.intermediate,
        targetMuscles: ['หน้าอก', 'หัวไหล่'],
        equipment: 'ไม่ต้องใช้อุปกรณ์',
        startingPosition: 'ตั้งท่าวิดพื้น แขนกว้างเท่าช่วงไหล่',
        movementInstruction: 'หย่อนลำตัวลงจนอกเกือบแตะพื้น แล้วดันตัวกลับขึ้น',
        breathingInstruction: 'หายใจเข้าขณะหย่อนตัว หายใจออกขณะดันขึ้น',
        safetyNotes: ['เกร็งหน้าท้อง ห้ามหลังแอ่น'],
        commonMistakes: ['กางศอกกว้างเกินไป'],
        easierVariationId: 'pushup_knee',
        defaultSets: 3,
        defaultReps: 10,
        defaultRestSeconds: 45,
      );

      final map = pushup.toMap();
      final fromMap = Exercise.fromMap(map);
      expect(fromMap.id, equals('pushup_std'));
      expect(fromMap.easierVariationId, equals('pushup_knee'));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/body_cultivation_test.dart`
Expected: FAIL with compilation error (Classes not found).

- [ ] **Step 3: Implement Models and Calculator**

Create `lib/data/models/body_cultivation_models.dart`:
```dart
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
```

Create `lib/core/utils/body_cultivation_calculator.dart`:
```dart
import '../../data/models/body_cultivation_models.dart';

class BodyCultivationCalculator {
  BodyCultivationCalculator._();

  static const List<BodyRealm> allBodyRealms = [
    BodyRealm(
      level: 1,
      thaiName: 'เบิกเนตรกายา',
      englishName: 'Body Awakening',
      description: 'ปรับสมดุลข้อต่อ เส้นเอ็น และสร้างความคุ้นเคยกับท่วงท่าพื้นฐาน',
      minBodyXp: 0,
      maxBodyXp: 500,
    ),
    BodyRealm(
      level: 2,
      thaiName: 'หลอมรวมเส้นเอ็น',
      englishName: 'Body Tempering',
      description: 'เสริมสร้างความแข็งแกร่งของกล้ามเนื้อมัดหลักและแกนกลางลำตัว',
      minBodyXp: 500,
      maxBodyXp: 2000,
    ),
    BodyRealm(
      level: 3,
      thaiName: 'เสริมสร้างชีพจรกาย',
      englishName: 'Meridian Strengthening',
      description: 'ควบคุมการเคลื่อนไหวอย่างสมบูรณ์ เพิ่มพละกำลังและความทนทาน',
      minBodyXp: 2000,
      maxBodyXp: 5500,
    ),
    BodyRealm(
      level: 4,
      thaiName: 'หลอมกระดูกทองแดง',
      englishName: 'Bone Forging',
      description: 'ก้าวข้ามขีดจำกัดเดิมด้วยแรงระเบิดกล้ามเนื้อและการโอเวอร์โหลด',
      minBodyXp: 5500,
      maxBodyXp: 11000,
    ),
    BodyRealm(
      level: 5,
      thaiName: 'กายาวชิระไร้พ่าย',
      englishName: 'Vajra Physique (Iron Body)',
      description: 'ร่างกายแกร่งดุจเหล็กไหล ควบคุมน้ำหนักตัวได้อย่างไร้เทียมทาน',
      minBodyXp: 11000,
      maxBodyXp: 999999,
    ),
  ];

  static BodyRealm getBodyRealm(int bodyXp) {
    for (final realm in allBodyRealms) {
      if (bodyXp >= realm.minBodyXp && bodyXp < realm.maxBodyXp) {
        return realm;
      }
    }
    return allBodyRealms.last;
  }

  static double getBodyRealmProgress(int bodyXp) {
    final realm = getBodyRealm(bodyXp);
    if (realm.maxBodyXp <= realm.minBodyXp) return 1.0;
    final progress = (bodyXp - realm.minBodyXp) / (realm.maxBodyXp - realm.minBodyXp);
    return progress.clamp(0.0, 1.0);
  }

  static ({int baseQi, int bodyXp}) calculateSessionReward({
    required int durationMinutes,
    required int completedSets,
    required ExerciseDifficulty difficulty,
  }) {
    final double durationPart = durationMinutes * 2.5;
    final double setsPart = completedSets * 3.0;
    final double tierBonus = difficulty.tier * 10.0;
    final int totalEarned = (durationPart + setsPart + tierBonus).round();

    return (
      baseQi: totalEarned,
      bodyXp: totalEarned,
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/body_cultivation_test.dart`
Expected: PASS

- [ ] **Step 5: Commit Task 1**

```bash
git add lib/data/models/body_cultivation_models.dart lib/core/utils/body_cultivation_calculator.dart test/body_cultivation_test.dart
git commit -m "feat: implement Body Cultivation data models and progression calculator"
```

---

### Task 2: Exercise Database and Repository

**Files:**
- Create: `lib/data/datasources/exercise_database.dart`
- Create: `lib/data/repositories/body_cultivation_repository.dart`
- Test: `test/exercise_repository_test.dart`

**Interfaces:**
- Consumes: `ExerciseDatabase.defaultExercises`, `ExerciseDatabase.defaultSessions`, `HiveStorageService`
- Produces: `BodyCultivationRepository.getAllExercises()`, `BodyCultivationRepository.getExerciseById()`, `BodyCultivationRepository.getAllTemplates()`, `BodyCultivationRepository.saveTrainingRecord()`

- [ ] **Step 1: Write failing unit test for Exercise Database & Repository**

Create `test/exercise_repository_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:murim_app/data/datasources/exercise_database.dart';
import 'package:murim_app/data/repositories/body_cultivation_repository.dart';

void main() {
  group('Exercise Database & Repository Tests', () {
    test('ExerciseDatabase contains 18 structured exercises with valid regressions', () {
      final exercises = ExerciseDatabase.defaultExercises;
      expect(exercises.length, greaterThanOrEqualTo(15));

      for (final ex in exercises) {
        expect(ex.id, isNotEmpty);
        expect(ex.name, isNotEmpty);
        expect(ex.murimName, isNotEmpty);
        expect(ex.targetMuscles, isNotEmpty);
        expect(ex.startingPosition, isNotEmpty);
        expect(ex.movementInstruction, isNotEmpty);
        expect(ex.breathingInstruction, isNotEmpty);

        if (ex.easierVariationId != null) {
          final easier = exercises.any((e) => e.id == ex.easierVariationId);
          expect(easier, isTrue, reason: 'Missing easier variation: ${ex.easierVariationId}');
        }
      }
    });

    test('ExerciseDatabase contains default training session templates', () {
      final sessions = ExerciseDatabase.defaultSessions;
      expect(sessions.length, greaterThanOrEqualTo(4));
      for (final s in sessions) {
        expect(s.exerciseIds, isNotEmpty);
      }
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/exercise_repository_test.dart`
Expected: FAIL (Database and repo not found).

- [ ] **Step 3: Implement ExerciseDatabase and BodyCultivationRepository**

Create `lib/data/datasources/exercise_database.dart` with 18 authentic bodyweight exercises (Push-ups, Squats, Lunges, Planks, Glute bridges, Dead bugs, Bird dogs, Calves, Mobility) and 4 session templates.
Create `lib/data/repositories/body_cultivation_repository.dart`.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/exercise_repository_test.dart`
Expected: PASS

- [ ] **Step 5: Commit Task 2**

```bash
git add lib/data/datasources/exercise_database.dart lib/data/repositories/body_cultivation_repository.dart test/exercise_repository_test.dart
git commit -m "feat: implement 18-exercise database and BodyCultivationRepository"
```

---

### Task 3: BodyCultivationProvider for Session State & Timer

**Files:**
- Create: `lib/presentation/providers/body_cultivation_provider.dart`
- Test: `test/body_cultivation_provider_test.dart`

**Interfaces:**
- Consumes: `BodyCultivationRepository`, `CultivationProvider`
- Produces: `BodyCultivationProvider` (`startSession()`, `completeSet()`, `skipExercise()`, `finishSession()`, `switchToEasierVariation()`)

- [ ] **Step 1: Write failing unit test for BodyCultivationProvider**

Create `test/body_cultivation_provider_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:murim_app/data/repositories/body_cultivation_repository.dart';
import 'package:murim_app/presentation/providers/body_cultivation_provider.dart';

void main() {
  group('BodyCultivationProvider Tests', () {
    test('initializes with default session template and exercises', () {
      final repo = BodyCultivationRepositoryImpl();
      final provider = BodyCultivationProvider(repository: repo);

      expect(provider.exercises, isNotEmpty);
      expect(provider.templates, isNotEmpty);
      expect(provider.isSessionActive, isFalse);
    });

    test('starts session and advances sets properly', () {
      final repo = BodyCultivationRepositoryImpl();
      final provider = BodyCultivationProvider(repository: repo);

      final template = provider.templates.first;
      provider.startSession(template);

      expect(provider.isSessionActive, isTrue);
      expect(provider.currentExerciseIndex, equals(0));
      expect(provider.completedSetsInCurrentExercise, equals(0));

      provider.completeSet();
      expect(provider.completedSetsInCurrentExercise, equals(1));
      expect(provider.isResting, isTrue);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/body_cultivation_provider_test.dart`
Expected: FAIL (Provider not found).

- [ ] **Step 3: Implement BodyCultivationProvider**

Create `lib/presentation/providers/body_cultivation_provider.dart` with complete session lifecycle, timer ticker, and set tracker.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/body_cultivation_provider_test.dart`
Expected: PASS

- [ ] **Step 5: Commit Task 3**

```bash
git add lib/presentation/providers/body_cultivation_provider.dart test/body_cultivation_provider_test.dart
git commit -m "feat: implement BodyCultivationProvider session controller and timer"
```

---

### Task 4: Active Session Screen & Follow-Along Workflow

**Files:**
- Create: `lib/presentation/screens/body_cultivation/active_session_screen.dart`
- Create: `lib/presentation/screens/body_cultivation/widgets/session_summary_dialog.dart`

**Interfaces:**
- Consumes: `BodyCultivationProvider`, `CultivationProvider`
- Produces: `ActiveSessionScreen`, `SessionSummaryDialog`

- [ ] **Step 1: Implement ActiveSessionScreen**

Create `active_session_screen.dart` featuring:
- Large legible countdown timer / rep tracker
- Animated rest timer with progress ring
- One-tap "เปลี่ยนเป็นท่ายากขึ้น/ง่ายลง (Regression/Progression Switcher)"
- Set checkboxes and exercise progression bar

- [ ] **Step 2: Implement SessionSummaryDialog**

Create `session_summary_dialog.dart` celebrating workout completion with Qi gained, Body XP awarded, and log entry.

- [ ] **Step 3: Commit Task 4**

```bash
git add lib/presentation/screens/body_cultivation/active_session_screen.dart lib/presentation/screens/body_cultivation/widgets/session_summary_dialog.dart
git commit -m "feat: implement ActiveSessionScreen follow-along and SessionSummaryDialog"
```

---

### Task 5: Exercise Library & Detail Dialog

**Files:**
- Create: `lib/presentation/screens/body_cultivation/exercise_library_screen.dart`
- Create: `lib/presentation/screens/body_cultivation/widgets/exercise_detail_dialog.dart`

**Interfaces:**
- Consumes: `BodyCultivationProvider`, `Exercise`
- Produces: `ExerciseLibraryScreen`, `ExerciseDetailDialog`

- [ ] **Step 1: Implement ExerciseLibraryScreen**

Category filters (Lower, Upper, Core, Mobility, Conditioning), search box, and difficulty badges.

- [ ] **Step 2: Implement ExerciseDetailDialog**

Form instructions (Starting pos, Movement, Breathing, Safety tips, Regression/Progression links).

- [ ] **Step 3: Commit Task 5**

```bash
git add lib/presentation/screens/body_cultivation/exercise_library_screen.dart lib/presentation/screens/body_cultivation/widgets/exercise_detail_dialog.dart
git commit -m "feat: implement ExerciseLibraryScreen and ExerciseDetailDialog"
```

---

### Task 6: Body Cultivation Dashboard Screen & Shell Integration

**Files:**
- Create: `lib/presentation/screens/body_cultivation/body_cultivation_screen.dart`
- Modify: `lib/presentation/screens/main_shell_screen.dart`
- Modify: `lib/presentation/providers/cultivation_provider.dart`
- Modify: `lib/main.dart`

**Interfaces:**
- Consumes: `BodyCultivationProvider`, `CultivationProvider`
- Produces: Navigation tab "บ่มเพาะกาย" in MainShell and MultiProvider setup.

- [ ] **Step 1: Implement BodyCultivationScreen Dashboard**

Displays:
- Body Cultivation Realm Hero Card with Body XP Progress
- Today's Recommended Routine Banner
- Category Quick Launch Cards
- Recent Workout Records History List

- [ ] **Step 2: Update MainShellScreen & CultivationProvider**

- Add `BodyCultivationProvider` to `main.dart` `MultiProvider`.
- Add `BodyCultivationScreen` as a core tab in `MainShellScreen`.
- Add `recordBodyTrainingSession` method in `CultivationProvider` to credit `bodyXp` and `totalQi`.

- [ ] **Step 3: Commit Task 6**

```bash
git add lib/presentation/screens/body_cultivation/body_cultivation_screen.dart lib/presentation/screens/main_shell_screen.dart lib/presentation/providers/cultivation_provider.dart lib/main.dart
git commit -m "feat: integrate Body Cultivation dashboard into MainShell navigation and provider tree"
```

---

### Task 7: Comprehensive Verification & Analyzer Gate

**Files:**
- Run: `dart analyze`
- Run: `flutter test`

- [ ] **Step 1: Run Dart Analyze**

Run: `dart analyze`
Expected: 0 issues found.

- [ ] **Step 2: Run Full Flutter Test Suite**

Run: `flutter test`
Expected: All tests pass (26 original tests + new body cultivation tests).

- [ ] **Step 3: Final Release Commit**

```bash
git add .
git commit -m "release: complete Body Cultivation Mode feature"
```
