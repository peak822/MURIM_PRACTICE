import 'package:flutter_test/flutter_test.dart';
import 'package:murim_app/data/datasources/exercise_database.dart';
import 'package:murim_app/data/models/body_cultivation_models.dart';
import 'package:murim_app/data/repositories/body_cultivation_repository.dart';

void main() {
  group('Exercise Database & Repository Tests', () {
    test('ExerciseDatabase contains at least 18 structured exercises with valid regressions', () {
      final exercises = ExerciseDatabase.defaultExercises;
      expect(exercises.length, greaterThanOrEqualTo(18));

      for (final ex in exercises) {
        expect(ex.id, isNotEmpty);
        expect(ex.name, isNotEmpty);
        expect(ex.murimName, isNotEmpty);
        expect(ex.targetMuscles, isNotEmpty);
        expect(ex.startingPosition, isNotEmpty);
        expect(ex.movementInstruction, isNotEmpty);
        expect(ex.breathingInstruction, isNotEmpty);
        expect(ex.safetyNotes, isNotEmpty);
        expect(ex.commonMistakes, isNotEmpty);

        if (ex.easierVariationId != null) {
          final easier = exercises.any((e) => e.id == ex.easierVariationId);
          expect(easier, isTrue, reason: 'Missing easier variation: ${ex.easierVariationId} for ${ex.id}');
        }
        if (ex.harderVariationId != null) {
          final harder = exercises.any((e) => e.id == ex.harderVariationId);
          expect(harder, isTrue, reason: 'Missing harder variation: ${ex.harderVariationId} for ${ex.id}');
        }
      }
    });

    test('ExerciseDatabase contains at least 4 default training session templates', () {
      final sessions = ExerciseDatabase.defaultSessions;
      expect(sessions.length, greaterThanOrEqualTo(4));
      for (final s in sessions) {
        expect(s.id, isNotEmpty);
        expect(s.title, isNotEmpty);
        expect(s.murimTitle, isNotEmpty);
        expect(s.exerciseIds, isNotEmpty);
        expect(s.estimatedMinutes, greaterThan(0));

        // Verify all exercise IDs in template exist in database
        for (final exId in s.exerciseIds) {
          final exists = ExerciseDatabase.defaultExercises.any((e) => e.id == exId);
          expect(exists, isTrue, reason: 'Template ${s.id} references missing exercise: $exId');
        }
      }
    });

    test('BodyCultivationRepository provides exercises, templates and mock/memory storage', () async {
      final repo = BodyCultivationRepositoryImpl();
      expect(repo.getAllExercises().length, greaterThanOrEqualTo(18));
      expect(repo.getAllTemplates().length, greaterThanOrEqualTo(4));
      
      final pushup = repo.getExerciseById('pushup_standard');
      expect(pushup, isNotNull);
      expect(pushup?.name, contains('Push-up'));

      final record = TrainingRecord(
        id: 'rec_1',
        sessionId: 'session_foundation',
        sessionTitle: 'เบิกเนตรปรับสมดุลกาย',
        completedAt: DateTime.now(),
        durationMinutes: 15,
        totalSetsCompleted: 9,
        earnedQi: 75,
        earnedBodyXp: 75,
      );

      await repo.saveTrainingRecord(record);
      expect(repo.getTrainingRecords().any((r) => r.id == 'rec_1'), isTrue);

      await repo.deleteTrainingRecord('rec_1');
      expect(repo.getTrainingRecords().any((r) => r.id == 'rec_1'), isFalse);
    });
  });
}
