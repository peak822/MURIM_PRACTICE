import 'package:flutter_test/flutter_test.dart';
import 'package:murim_app/data/models/body_cultivation_models.dart';
import 'package:murim_app/data/repositories/body_cultivation_repository.dart';
import 'package:murim_app/presentation/providers/body_cultivation_provider.dart';

void main() {
  group('BodyCultivationProvider Tests', () {
    test('initializes with default templates, exercises and inactive session state', () {
      final repo = BodyCultivationRepositoryImpl();
      final provider = BodyCultivationProvider(repository: repo);

      expect(provider.exercises, isNotEmpty);
      expect(provider.templates, isNotEmpty);
      expect(provider.isSessionActive, isFalse);
      expect(provider.currentTemplate, isNull);
    });

    test('starts session and advances sets and resting states properly', () {
      final repo = BodyCultivationRepositoryImpl();
      final provider = BodyCultivationProvider(repository: repo);

      final template = provider.templates.first;
      provider.startSession(template);

      expect(provider.isSessionActive, isTrue);
      expect(provider.currentTemplate?.id, equals(template.id));
      expect(provider.currentExerciseIndex, equals(0));
      expect(provider.completedSetsInCurrentExercise, equals(0));
      expect(provider.totalSetsCompleted, equals(0));

      // Complete 1st set
      provider.completeSet();
      expect(provider.completedSetsInCurrentExercise, equals(1));
      expect(provider.totalSetsCompleted, equals(1));
      expect(provider.isResting, isTrue);

      // Skip rest
      provider.skipRest();
      expect(provider.isResting, isFalse);
    });

    test('switching to easier and harder variation replaces current exercise dynamically', () {
      final repo = BodyCultivationRepositoryImpl();
      final provider = BodyCultivationProvider(repository: repo);

      // Find standard pushup
      final pushupStd = repo.getExerciseById('pushup_standard')!;
      final customTemplate = TrainingSessionTemplate(
        id: 'custom_test',
        title: 'Pushup Test',
        murimTitle: 'ทดสอบฝ่ามือ',
        targetRealmLevel: 2,
        estimatedMinutes: 5,
        exerciseIds: [pushupStd.id],
        description: 'Test',
      );

      provider.startSession(customTemplate);
      expect(provider.currentExercise.id, equals('pushup_standard'));

      // Switch to easier (Knee push-up)
      final switchedEasier = provider.switchToEasierVariation();
      expect(switchedEasier, isTrue);
      expect(provider.currentExercise.id, equals('pushup_knee'));

      // Switch to harder (Back to standard)
      final switchedHarder = provider.switchToHarderVariation();
      expect(switchedHarder, isTrue);
      expect(provider.currentExercise.id, equals('pushup_standard'));
    });

    test('finishing session calculates reward and saves training record', () async {
      final repo = BodyCultivationRepositoryImpl();
      final provider = BodyCultivationProvider(repository: repo);

      final template = provider.templates.first;
      provider.startSession(template);

      provider.completeSet();
      provider.completeSet();

      final record = await provider.finishSession();
      expect(record, isNotNull);
      expect(record!.totalSetsCompleted, equals(2));
      expect(record.earnedQi, greaterThan(0));
      expect(record.earnedBodyXp, greaterThan(0));
      expect(provider.isSessionActive, isFalse);
      expect(provider.records.any((r) => r.id == record.id), isTrue);
    });
  });
}
