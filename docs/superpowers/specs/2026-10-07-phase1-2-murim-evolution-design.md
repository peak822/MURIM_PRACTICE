# Murim Study Tracker: Phase 1 & 2 Evolution Design Specification

- **Date:** 2026-10-07
- **Target Scope:** Phase 1 (Data Safety & Daily Engine) + Phase 2 (Meaningful Cultivation & Daoist Titles)
- **Status:** Approved for Implementation Planning

---

## 1. Goal & Architectural Overview

This specification establishes the architectural foundation for Phase 1 and Phase 2 of the **Murim Study Tracker** evolution without breaking any existing calculations or UI contracts.

The design adheres to the **Clean Domain Services & Modular Hive Expansion** approach:
1. **DailyResetManager**: Automated midnight detection and daily mission state recycling without deleting historical logs.
2. **BackupService**: Comprehensive JSON schema serialization, export, validation, and restoration for offline data safety.
3. **Tribulation Gate & Epiphany Reflections**: Meaningful progression gating where users record reflections upon major realm breakthroughs.
4. **Daoist Titles & Accolades System**: Thematic title unlocks based on verifiable cultivation milestones, equipped to the Realm Hero banner.

---

## 2. Component Specifications

### 2.1 DailyResetManager (`lib/core/services/daily_reset_manager.dart`)
* **Responsibility**: Checks date continuity upon application startup and lifecycle resume.
* **Behaviors**:
  - Compares `DateTime.now()` with `UserStats.lastActiveDate`.
  - When the date changes (`today.difference(lastActiveDay).inDays >= 1`):
    - Identifies all missions where `isDaily == true` and `isCompleted == true`.
    - Resets `isCompleted = false` and `completedAt = null`.
    - Updates `lastResetDate` in settings box.
    - Evaluates streak continuity: if gap is 1 day, keeps streak active until day ends; if gap > 1 day without activity, handles streak reset cleanly.
  - Pure, defensive, and idempotent execution.

### 2.2 BackupService (`lib/core/services/backup_service.dart`)
* **Responsibility**: Offline JSON export, validation, and restore.
* **Schema Definition (`MurimBackupV1`)**:
  ```json
  {
    "schemaVersion": 1,
    "exportedAt": "2026-10-07T12:00:00.000Z",
    "appVersion": "1.0.0",
    "userStats": { ... },
    "missions": [ ... ],
    "cultivationLogs": [ ... ],
    "settings": { ... }
  }
  ```
* **Behaviors**:
  - `exportToJsonString()`: Exports all 4 boxes (`missions`, `user_stats`, `cultivation_logs`, `settings`).
  - `validateBackupJson(String jsonStr)`: Validates JSON structure, required keys, and types. Returns structured result `({bool isValid, String? errorMessage})`.
  - `restoreFromJsonString(String jsonStr)`: Clears existing boxes and populates validated payload, triggering provider reloads.

### 2.3 Tribulation Gate & Breakthrough Reflections
* **Files Affected**:
  - `lib/data/models/user_stats_model.dart` (Add `equippedTitleId`, `reflectionNote` support)
  - `lib/presentation/widgets/breakthrough_dialog.dart` (Add optional epiphany/reflection input form with poetic Daoist styling)
  - `lib/presentation/providers/cultivation_provider.dart` (Enhance breakthrough log with user's reflection text)
* **Behaviors**:
  - When a breakthrough occurs, the `BreakthroughDialog` presents the breakthrough poem and allows the user to write their "Epiphany / Realization (ความรู้แจ้งแห่งเต๋า)" before sealing the breakthrough.
  - The reflection is permanently recorded into `CultivationLog` with `CultivationLogType.realmBreakthrough`.

### 2.4 Daoist Titles & Accolades Registry (`lib/data/models/daoist_title.dart`)
* **Model**:
  ```dart
  class DaoistTitle {
    final String id;
    final String name;
    final String description;
    final String category; // 'streak', 'qi', 'meditation', 'missions'
    final bool Function(UserStats stats) unlockCondition;
  }
  ```
* **Initial 8 Thematic Titles**:
  1. `novice_seeker`: *ศิษย์ใหม่ผู้ขยันหมั่นเพียร* (Default / 1 completed mission)
  2. `seven_day_flame`: *จอมยุทธ์เจ็ดทิวาไม่ดับสูญ* (Streak $\ge 7$)
  3. `thirty_day_dragon`: *มังกรจำศีลสามสิบทิวา* (Streak $\ge 30$)
  4. `pure_qi_adept`: *ผู้โคจรลมปราณร้อยลี้* (Total Qi $\ge 1,000$)
  5. `golden_core_master`: *ปรมาจารย์แก่นทองคำ* (Realm level $\ge 13$)
  6. `meditation_hermit`: *ผู้ตัดกิเลสในถ้ำลึก* (Meditation minutes $\ge 120$)
  7. `hundred_decrees`: *ผู้บรรลุร้อยเทียบภารกิจ* (Completed missions $\ge 100$)
  8. `grand_dao_scholar`: *มหาปราชญ์แห่งหอคัมภีร์* (Mind XP $\ge 2,000$)
* **UI Integration**:
  - Users can view and equip unlocked titles in `SettingsScreen` or via profile dialog.
  - The equipped title displays gracefully below the user's name on `RealmHeroCard` and `MainShellScreen`.

---

## 3. Data Flow & State Integrations

```
[Application Startup]
       │
       ▼
[HiveStorageService.init()] ➔ [DailyResetManager.checkAndResetDailyMissions()]
       │
       ▼
[MultiProvider Setup] ➔ [MissionProvider] & [CultivationProvider] Loaded
       │
       ├─► [User Actions: Complete Mission / Secluded Meditation]
       │         │
       │         ▼
       │   [CultivationProvider] checks Qi Threshold & Title Unlocks
       │         │
       │         ▼
       │   [BreakthroughDialog] captures Epiphany Note ➔ Saves to [CultivationLog]
       │
       └─► [User Actions: Settings ➔ Export / Import Backup]
                 │
                 ▼
           [BackupService] validates & serializes JSON
```

---

## 4. Error Handling & Edge Cases

1. **Corrupted JSON Import**: `BackupService` will parse with `jsonDecode` in a `try-catch` block and validate mandatory keys. If invalid, returns a localized error string and preserves existing data.
2. **Time Traveling (Clock Skew)**: If `DateTime.now()` is earlier than `lastActiveDate`, `DailyResetManager` ignores the anomaly to prevent streak loss.
3. **Empty Reflection on Breakthrough**: The epiphany text input is optional; if skipped, a default canonical breakthrough quote from `CultivationRealm` is used.

---

## 5. Testing Strategy

* **Unit Tests**:
  - `test/daily_reset_manager_test.dart`: Test daily mission reset, streak gap evaluation, and idempotent multiple calls on same day.
  - `test/backup_service_test.dart`: Test export serialization, valid import, malformed JSON rejection, and schema validation.
  - `test/daoist_titles_test.dart`: Test title unlocking conditions against various `UserStats` matrices.
* **Verification Gate**:
  - 100% pass on all existing 19 tests + new tests.
  - `dart analyze` with zero warnings.
