# Murim Study Tracker: Phase 1 & 2 Evolution Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement Phase 1 & 2 systems: automated daily mission resets with streak preservation, full offline JSON backup/restore, Daoist title registry with hero banner integration, and reflective Tribulation Gate breakthrough trials.

**Architecture:** Clean domain services (`DailyResetManager`, `BackupService`, `DaoistTitleRegistry`) interfacing cleanly with existing Hive boxes, `CultivationProvider`, and `MissionProvider` without altering core calculation math or breaking existing unit tests.

**Tech Stack:** Flutter 3.44.5, Dart 3.12.2, Provider, Hive, GoogleFonts, fl_chart, intl, uuid.

## Global Constraints
- Target platform: Mobile (Android/iOS) + Windows Desktop.
- Offline-first: Zero mandatory cloud dependencies.
- Zero regression on existing 19 unit tests in `test/`.
- Preserve all existing formula constants in `CultivationCalculator`.
- Backward-compatible Hive map serialization using default values for new fields.

---

### Task 1: DailyResetManager Service

**Files:**
- Create: `lib/core/services/daily_reset_manager.dart`
- Test: `test/daily_reset_manager_test.dart`

**Interfaces:**
- Consumes: `HiveStorageService`, `Mission`, `UserStats`
- Produces: `DailyResetManager.checkAndResetDailyMissions({required HiveStorageService storage, required DateTime currentTime})`

- [ ] **Step 1: Write failing unit test for DailyResetManager**

Create `test/daily_reset_manager_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:murim_app/core/services/daily_reset_manager.dart';
import 'package:murim_app/data/models/cultivation_category.dart';
import 'package:murim_app/data/models/mission_model.dart';
import 'package:murim_app/data/models/user_stats_model.dart';

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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/daily_reset_manager_test.dart`
Expected: FAIL with compilation error (DailyResetManager not found).

- [ ] **Step 3: Implement DailyResetManager**

Create `lib/core/services/daily_reset_manager.dart`:
```dart
import 'package:flutter/foundation.dart';
import '../../data/datasources/hive_storage_service.dart';
import '../../data/models/mission_model.dart';

class DailyResetResult {
  final bool hasReset;
  final int resetCount;
  final List<Mission> updatedMissions;

  const DailyResetResult({
    required this.hasReset,
    required this.resetCount,
    required this.updatedMissions,
  });
}

class DailyResetManager {
  DailyResetManager._();

  /// Pure evaluation logic for daily mission reset
  static DailyResetResult evaluateDailyReset({
    required List<Mission> missions,
    required DateTime? lastActiveDate,
    required DateTime currentTime,
  }) {
    if (lastActiveDate == null) {
      return DailyResetResult(
        hasReset: false,
        resetCount: 0,
        updatedMissions: missions,
      );
    }

    final currentDate = DateTime(currentTime.year, currentTime.month, currentTime.day);
    final lastDate = DateTime(lastActiveDate.year, lastActiveDate.month, lastActiveDate.day);

    if (currentDate.isAfter(lastDate)) {
      int resetCount = 0;
      final updatedList = missions.map((mission) {
        if (mission.isDaily && mission.isCompleted) {
          resetCount++;
          return mission.copyWith(
            isCompleted: false,
            completedAt: null,
          );
        }
        return mission;
      }).toList();

      return DailyResetResult(
        hasReset: resetCount > 0,
        resetCount: resetCount,
        updatedMissions: updatedList,
      );
    }

    return DailyResetResult(
      hasReset: false,
      resetCount: 0,
      updatedMissions: missions,
    );
  }

  /// Stateful execution against Hive storage
  static Future<DailyResetResult> checkAndResetDailyMissions({
    required HiveStorageService storage,
    DateTime? currentTime,
  }) async {
    try {
      final now = currentTime ?? DateTime.now();
      final stats = storage.getUserStats();
      final missions = storage.getAllMissions();

      final result = evaluateDailyReset(
        missions: missions,
        lastActiveDate: stats.lastActiveDate,
        currentTime: now,
      );

      if (result.hasReset) {
        for (final mission in result.updatedMissions) {
          if (mission.isDaily && !mission.isCompleted) {
            await storage.saveMission(mission);
          }
        }
        await storage.setSetting('last_daily_reset', now.toIso8601String());
      }

      return result;
    } catch (e) {
      debugPrint('Error executing DailyResetManager: $e');
      return DailyResetResult(
        hasReset: false,
        resetCount: 0,
        updatedMissions: storage.getAllMissions(),
      );
    }
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/daily_reset_manager_test.dart`
Expected: PASS

- [ ] **Step 5: Commit Task 1**

```bash
git add lib/core/services/daily_reset_manager.dart test/daily_reset_manager_test.dart
git commit -m "feat: implement DailyResetManager with automated daily mission resets"
```

---

### Task 2: BackupService for Offline JSON Export & Restore

**Files:**
- Create: `lib/core/services/backup_service.dart`
- Test: `test/backup_service_test.dart`

**Interfaces:**
- Consumes: `HiveStorageService`, `UserStats`, `Mission`, `CultivationLog`
- Produces: `BackupService.exportToJsonString()`, `BackupService.validateBackupJson()`, `BackupService.restoreFromJsonString()`

- [ ] **Step 1: Write failing unit test for BackupService**

Create `test/backup_service_test.dart`:
```dart
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
      final stats = UserStats(userName: 'Master Ling', totalQi: 1500);
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/backup_service_test.dart`
Expected: FAIL with compilation error (BackupService not found).

- [ ] **Step 3: Implement BackupService**

Create `lib/core/services/backup_service.dart`:
```dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import '../../data/datasources/hive_storage_service.dart';
import '../../data/models/cultivation_log.dart';
import '../../data/models/mission_model.dart';
import '../../data/models/user_stats_model.dart';

class BackupValidationResult {
  final bool isValid;
  final String? errorMessage;
  final Map<String, dynamic>? data;

  const BackupValidationResult({
    required this.isValid,
    this.errorMessage,
    this.data,
  });
}

class BackupService {
  BackupService._();

  static const int currentSchemaVersion = 1;

  /// Pure serialization to JSON String
  static String buildBackupJson({
    required UserStats stats,
    required List<Mission> missions,
    required List<CultivationLog> logs,
    required Map<String, dynamic> settings,
    DateTime? exportedAt,
  }) {
    final payload = {
      'schemaVersion': currentSchemaVersion,
      'exportedAt': (exportedAt ?? DateTime.now()).toIso8601String(),
      'appVersion': AppConstants.appVersion,
      'userStats': stats.toMap(),
      'missions': missions.map((m) => m.toMap()).toList(),
      'cultivationLogs': logs.map((l) => l.toMap()).toList(),
      'settings': settings,
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  /// Pure validation of backup JSON
  static BackupValidationResult validateBackupJson(String jsonString) {
    try {
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        return const BackupValidationResult(
          isValid: false,
          errorMessage: 'โครงสร้างไฟล์สำรองไม่ถูกต้อง (Invalid root format)',
        );
      }

      final schemaVersion = decoded['schemaVersion'];
      if (schemaVersion != 1) {
        return BackupValidationResult(
          isValid: false,
          errorMessage: 'เวอร์ชันไฟล์สำรองไม่รองรับ (Schema version: $schemaVersion)',
        );
      }

      if (decoded['userStats'] is! Map) {
        return const BackupValidationResult(
          isValid: false,
          errorMessage: 'ข้อมูลสเตตัสผู้ฝึกตนสูญหายหรือเสียหาย',
        );
      }

      if (decoded['missions'] is! List) {
        return const BackupValidationResult(
          isValid: false,
          errorMessage: 'ข้อมูลเทียบภารกิจไม่ถูกต้อง',
        );
      }

      return BackupValidationResult(isValid: true, data: decoded);
    } catch (e) {
      return BackupValidationResult(
        isValid: false,
        errorMessage: 'ไม่สามารถอ่านไฟล์ JSON ได้: ${e.toString()}',
      );
    }
  }

  /// Export current state from HiveStorageService
  static String exportStorageToJson(HiveStorageService storage) {
    final stats = storage.getUserStats();
    final missions = storage.getAllMissions();
    final logs = storage.getAllLogs();
    final settings = {
      'sound_enabled': storage.getSetting(AppConstants.keySoundEnabled, true),
      'haptic_enabled': storage.getSetting(AppConstants.keyHapticEnabled, true),
    };

    return buildBackupJson(
      stats: stats,
      missions: missions,
      logs: logs,
      settings: settings,
    );
  }

  /// Restore state into HiveStorageService
  static Future<bool> restoreJsonToStorage({
    required HiveStorageService storage,
    required String jsonString,
  }) async {
    final validation = validateBackupJson(jsonString);
    if (!validation.isValid || validation.data == null) {
      return false;
    }

    try {
      final data = validation.data!;
      final statsMap = data['userStats'] as Map<dynamic, dynamic>;
      final missionsList = data['missions'] as List<dynamic>;
      final logsList = (data['cultivationLogs'] as List<dynamic>?) ?? [];
      final settingsMap = (data['settings'] as Map<dynamic, dynamic>?) ?? {};

      // Clear existing state
      await storage.resetAllData();

      // Restore User Stats
      final stats = UserStats.fromMap(statsMap);
      await storage.saveUserStats(stats);

      // Restore Missions
      for (final m in missionsList) {
        if (m is Map) {
          final mission = Mission.fromMap(m);
          await storage.saveMission(mission);
        }
      }

      // Restore Logs
      for (final l in logsList) {
        if (l is Map) {
          final log = CultivationLog.fromMap(l);
          await storage.addLog(log);
        }
      }

      // Restore Settings
      if (settingsMap.containsKey('sound_enabled')) {
        await storage.setSetting(AppConstants.keySoundEnabled, settingsMap['sound_enabled']);
      }
      if (settingsMap.containsKey('haptic_enabled')) {
        await storage.setSetting(AppConstants.keyHapticEnabled, settingsMap['haptic_enabled']);
      }

      return true;
    } catch (e) {
      debugPrint('Error restoring backup to storage: $e');
      return false;
    }
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/backup_service_test.dart`
Expected: PASS

- [ ] **Step 5: Commit Task 2**

```bash
git add lib/core/services/backup_service.dart test/backup_service_test.dart
git commit -m "feat: implement BackupService with JSON export, schema validation and restore"
```

---

### Task 3: Daoist Titles & Accolades Registry

**Files:**
- Create: `lib/data/models/daoist_title.dart`
- Modify: `lib/data/models/user_stats_model.dart`
- Test: `test/daoist_titles_test.dart`

**Interfaces:**
- Consumes: `UserStats`
- Produces: `DaoistTitleRegistry.allTitles`, `DaoistTitleRegistry.getUnlockedTitles()`, `UserStats.equippedTitleId`

- [ ] **Step 1: Write failing unit test for Daoist Titles**

Create `test/daoist_titles_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:murim_app/data/models/daoist_title.dart';
import 'package:murim_app/data/models/user_stats_model.dart';

void main() {
  group('DaoistTitleRegistry Tests', () {
    test('unlocks novice_seeker by default if at least 1 mission completed', () {
      final stats = const UserStats(completedMissionsCount: 1);
      final unlocked = DaoistTitleRegistry.getUnlockedTitles(stats);
      expect(unlocked.any((t) => t.id == 'novice_seeker'), isTrue);
      expect(unlocked.any((t) => t.id == 'seven_day_flame'), isFalse);
    });

    test('unlocks seven_day_flame when streak reaches 7', () {
      final stats = const UserStats(currentStreak: 7, completedMissionsCount: 10);
      final unlocked = DaoistTitleRegistry.getUnlockedTitles(stats);
      expect(unlocked.any((t) => t.id == 'seven_day_flame'), isTrue);
    });

    test('returns equipped title object from stats id', () {
      final stats = const UserStats(equippedTitleId: 'seven_day_flame');
      final title = DaoistTitleRegistry.getTitleById(stats.equippedTitleId);
      expect(title, isNotNull);
      expect(title!.name, equals('จอมยุทธ์เจ็ดทิวาไม่ดับสูญ'));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/daoist_titles_test.dart`
Expected: FAIL with compilation error (DaoistTitle not found).

- [ ] **Step 3: Create DaoistTitle and Update UserStats**

Create `lib/data/models/daoist_title.dart`:
```dart
import 'user_stats_model.dart';

class DaoistTitle {
  final String id;
  final String name;
  final String description;
  final String categoryName;
  final bool Function(UserStats stats) isUnlocked;

  const DaoistTitle({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryName,
    required this.isUnlocked,
  });
}

class DaoistTitleRegistry {
  DaoistTitleRegistry._();

  static final List<DaoistTitle> allTitles = [
    DaoistTitle(
      id: 'novice_seeker',
      name: 'ศิษย์ใหม่ผู้ขยันหมั่นเพียร',
      description: 'ก้าวแรกสู่มรรคายุทธ ทำภารกิจแรกสำเร็จ',
      categoryName: 'จุดเริ่มต้น',
      isUnlocked: (stats) => stats.completedMissionsCount >= 1,
    ),
    DaoistTitle(
      id: 'seven_day_flame',
      name: 'จอมยุทธ์เจ็ดทิวาไม่ดับสูญ',
      description: 'รักษาเพลิงแห่งความเพียรต่อเนื่อง 7 วัน',
      categoryName: 'วินัยเต๋า',
      isUnlocked: (stats) => stats.currentStreak >= 7 || stats.longestStreak >= 7,
    ),
    DaoistTitle(
      id: 'thirty_day_dragon',
      name: 'มังกรจำศีลสามสิบทิวา',
      description: 'สั่งสมวินัยไม่ขาดสายถึง 30 วัน',
      categoryName: 'วินัยเต๋า',
      isUnlocked: (stats) => stats.currentStreak >= 30 || stats.longestStreak >= 30,
    ),
    DaoistTitle(
      id: 'pure_qi_adept',
      name: 'ผู้โคจรลมปราณร้อยลี้',
      description: 'สั่งสมพลังปราณบริสุทธิ์ทะลุ 1,000 Qi',
      categoryName: 'พลังปราณ',
      isUnlocked: (stats) => stats.totalQi >= 1000,
    ),
    DaoistTitle(
      id: 'golden_core_master',
      name: 'ปรมาจารย์แก่นทองคำ',
      description: 'บรรลุขอบเขตแก่นแท้ทองคำ (Level 13+)',
      categoryName: 'ขอบเขตพลัง',
      isUnlocked: (stats) => stats.currentRealm.level >= 13,
    ),
    DaoistTitle(
      id: 'meditation_hermit',
      name: 'ผู้ตัดกิเลสในถ้ำลึก',
      description: 'ปิดด่านสมาธิภาวนาสะสมเกิน 120 นาที',
      categoryName: 'สมาธิภาวนา',
      isUnlocked: (stats) => stats.meditationMinutes >= 120,
    ),
    DaoistTitle(
      id: 'hundred_decrees',
      name: 'ผู้บรรลุร้อยเทียบภารกิจ',
      description: 'พิชิตเทียบภารกิจสำนักสำเร็จครบ 100 รายการ',
      categoryName: 'ภารกิจยุทธ',
      isUnlocked: (stats) => stats.completedMissionsCount >= 100,
    ),
    DaoistTitle(
      id: 'grand_dao_scholar',
      name: 'มหาปราชญ์แห่งหอคัมภีร์',
      description: 'สั่งสมค่าประสบการณ์ปัญญา (Mind XP) เกิน 2,000',
      categoryName: 'สติปัญญา',
      isUnlocked: (stats) => stats.mindXp >= 2000,
    ),
  ];

  static List<DaoistTitle> getUnlockedTitles(UserStats stats) {
    return allTitles.where((title) => title.isUnlocked(stats)).toList();
  }

  static DaoistTitle? getTitleById(String? id) {
    if (id == null || id.isEmpty) return null;
    try {
      return allTitles.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
```

Update `lib/data/models/user_stats_model.dart` to include `equippedTitleId`:
```dart
  final String? equippedTitleId;
```
Ensure `copyWith`, `toMap`, and `fromMap` handle `equippedTitleId` with default `null`.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/daoist_titles_test.dart`
Expected: PASS

- [ ] **Step 5: Commit Task 3**

```bash
git add lib/data/models/daoist_title.dart lib/data/models/user_stats_model.dart test/daoist_titles_test.dart
git commit -m "feat: implement DaoistTitle registry and equipped title field in UserStats"
```

---

### Task 4: Tribulation Gate & Epiphany Reflection Integration

**Files:**
- Modify: `lib/presentation/widgets/breakthrough_dialog.dart`
- Modify: `lib/presentation/providers/cultivation_provider.dart`

**Interfaces:**
- Consumes: `BreakthroughDialog`, `CultivationProvider.recordBreakthroughReflection()`
- Produces: Enhanced `CultivationLog` with user-entered Epiphany notes.

- [ ] **Step 1: Update BreakthroughDialog with Epiphany input form**

In `lib/presentation/widgets/breakthrough_dialog.dart`:
Add an optional `TextField` inside the dialog allowing users to enter their "จารึกความรู้แจ้งแห่งเต๋า (Epiphany Reflection)". If submitted, call `cultivationProvider.recordBreakthroughReflection(realm, note)` to save alongside the log.

- [ ] **Step 2: Update CultivationProvider with title equip and reflection logging**

In `lib/presentation/providers/cultivation_provider.dart`:
Add methods:
```dart
Future<void> equipTitle(String? titleId) async {
  _stats = _stats.copyWith(equippedTitleId: titleId);
  await _repository.saveUserStats(_stats);
  notifyListeners();
}

Future<void> recordBreakthroughEpiphany(String reflectionText) async {
  if (reflectionText.trim().isEmpty) return;
  final log = CultivationLog(
    id: _uuid.v4(),
    title: 'จารึกความรู้แจ้ง: ${_stats.currentRealm.fullThaiTitle}',
    description: reflectionText.trim(),
    qiGained: 0,
    type: CultivationLogType.realmBreakthrough,
    timestamp: DateTime.now(),
  );
  await _repository.addLog(log);
  _logs.insert(0, log);
  notifyListeners();
}
```

- [ ] **Step 3: Run existing tests to verify zero regressions**

Run: `flutter test`
Expected: PASS (All 19+ existing tests pass)

- [ ] **Step 4: Commit Task 4**

```bash
git add lib/presentation/widgets/breakthrough_dialog.dart lib/presentation/providers/cultivation_provider.dart
git commit -m "feat: integrate Tribulation Gate reflection input and title equip in CultivationProvider"
```

---

### Task 5: UI Integrations (Settings Backup & Titles + RealmHeroCard)

**Files:**
- Modify: `lib/presentation/screens/settings/settings_screen.dart`
- Modify: `lib/presentation/screens/dashboard/widgets/realm_hero_card.dart`
- Modify: `lib/main.dart`

**Interfaces:**
- Consumes: `BackupService`, `DailyResetManager`, `DaoistTitleRegistry`
- Produces: Visual backup export dialog, title selection modal, and startup reset call.

- [ ] **Step 1: Integrate DailyResetManager in `main.dart`**

In `lib/main.dart`:
Add `await DailyResetManager.checkAndResetDailyMissions(storage: storageService);` after `storageService.init()`.

- [ ] **Step 2: Add Backup Export/Import & Title Selection in SettingsScreen**

In `lib/presentation/screens/settings/settings_screen.dart`:
- Add "สำรองและกู้คืนม้วนคัมภีร์ (Backup & Restore)" card with JSON Export copy-to-clipboard / file download and JSON Import dialog.
- Add "ฉายาจอมยุทธ์แห่งเต๋า (Daoist Titles)" selection dialog showing unlocked vs locked titles.

- [ ] **Step 3: Display Equipped Title on RealmHeroCard**

In `lib/presentation/screens/dashboard/widgets/realm_hero_card.dart`:
Display the user's equipped Daoist Title (e.g. `[ จอมยุทธ์เจ็ดทิวาไม่ดับสูญ ]`) beneath their user name in golden script.

- [ ] **Step 4: Commit Task 5**

```bash
git add lib/main.dart lib/presentation/screens/settings/settings_screen.dart lib/presentation/screens/dashboard/widgets/realm_hero_card.dart
git commit -m "feat: integrate backup export/restore, title selector in settings and hero banner"
```

---

### Task 6: Comprehensive Verification & Analyzer Gate

**Files:**
- Run: `dart analyze`
- Run: `flutter test`

- [ ] **Step 1: Run Dart Analyze**

Run: `dart analyze`
Expected: 0 issues found.

- [ ] **Step 2: Run Full Flutter Test Suite**

Run: `flutter test`
Expected: All tests pass (19 original tests + new DailyReset, Backup, and DaoistTitle tests).

- [ ] **Step 3: Final Git Commit and Tag**

```bash
git add .
git commit -m "release: complete Phase 1 and Phase 2 evolution features"
```
