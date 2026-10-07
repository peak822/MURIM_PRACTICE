# Body Cultivation Mode (โหมดบ่มเพาะกาย) Design Specification

- **Date:** 2026-10-07
- **Target Scope:** Body Cultivation System (Real Exercise Database + Follow-Along Session Timer + 5 Body Realms + Hive Storage & Qi/Body XP Integration)
- **Status:** Approved for Implementation Planning

---

## 1. Goal & Architectural Overview

The **Body Cultivation Mode** integrates real-world calisthenics/bodyweight physical exercise with the Murim cultivation progression system without breaking any existing calculations, models, or UI contracts.

### Core Features:
1. **Exercise Database (คลังท่าวิชาฝึกกาย)**: 18 structured bodyweight exercises across 5 categories (Lower body, Upper body, Core, Mobility, Conditioning) with regression/progression links, target muscles, and breathing instructions.
2. **5 Body Cultivation Realms (ขอบเขตกายา 5 ขั้น)**:
   - Level 1: เบิกเนตรกายา (Body Awakening)
   - Level 2: หลอมรวมเส้นเอ็น (Body Tempering)
   - Level 3: เสริมสร้างชีพจรกาย (Meridian Strengthening)
   - Level 4: หลอมกระดูกทองแดง (Bone Forging)
   - Level 5: กายาวชิระไร้พ่าย (Vajra Physique)
3. **Active Training Session & Follow-Along Timer (ห้องฝึกซ้อมกายจริง)**: Real-time countdowns, set/rep tracker, rest timers, audio/haptic cues, and instant easier-variation switcher.
4. **Qi & Stats Integration**: Earns Body XP and Qi proportional to duration, sets, and difficulty. Directly fuels `UserStats.bodyXp`, `UserStats.totalQi`, and the "พลังกาย (Body Vigor)" axis of the `BaguaRadarChart`.
5. **Persistence**: Saves workout history into Hive `training_records_box` and logs into `CultivationLog`.

---

## 2. Component Specifications

### 2.1 Data Models (`lib/data/models/body_cultivation_models.dart`)
- `Exercise`: Complete definition with name, Murim title, category, difficulty, instructions, safety notes, easier/harder variation IDs.
- `BodyRealm`: 5 progression stages mapped from cumulative `bodyXp`.
- `TrainingSessionTemplate`: Pre-designed training routines (Foundation, Strength, Core, Mobility).
- `TrainingRecord`: Logged completion data.

### 2.2 Domain Logic & Calculation (`lib/core/utils/body_cultivation_calculator.dart`)
- `calculateBodyRealm(int bodyXp)`: Returns `BodyRealm` (1-5).
- `calculateSessionQi({required int durationMinutes, required int completedSets, required int difficultyTier})`: Calculates awarded Qi and Body XP.
- `calculateBodyRealmProgress(int bodyXp)`: Percentage to next body realm.

### 2.3 Repository & Storage (`lib/data/repositories/body_cultivation_repository.dart`)
- Seeds default 18 exercises and 4 session templates.
- Persists user workout records into Hive `training_records_box`.

### 2.4 State Management (`lib/presentation/providers/body_cultivation_provider.dart`)
- Manages active workout session state, active exercise index, set tracker, rest timer, and session completion flow.

### 2.5 UI Screens & Widgets
- `BodyCultivationScreen`: Main dashboard displaying Body Realm, Today's Routine, Exercise Library button, and Recent Training History.
- `ActiveSessionScreen`: Distraction-free follow-along interface with large timer, rest countdown, and set checkboxes.
- `ExerciseLibraryScreen` & `ExerciseDetailDialog`: Searchable catalogue of exercises with muscle groups and form guides.

---

## 3. Integration with Main App
- Adds "บ่มเพาะกาย" (Body Cultivation) tab into `MainShellScreen`.
- Updates `CultivationProvider.recordTrainingSession(...)` to credit `bodyXp` and `totalQi`.
- Zero disruption to existing 26 unit tests.
