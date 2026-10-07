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
