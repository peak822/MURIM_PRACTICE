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
