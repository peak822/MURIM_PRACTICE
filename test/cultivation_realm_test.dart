import 'package:flutter_test/flutter_test.dart';
import 'package:murim_app/data/models/cultivation_realm.dart';

void main() {
  group('CultivationRealm Tests', () {
    test('CultivationRealm has 20 progressive tiers', () {
      expect(CultivationRealm.realms.length, 20);
      expect(CultivationRealm.realms.first.level, 1);
      expect(CultivationRealm.realms.last.level, 20);
    });

    test('CultivationRealm.fromQi correctly maps Qi levels to realms', () {
      // 0 Qi -> Level 1 (Qi Condensation Initial)
      final realm0 = CultivationRealm.fromQi(0);
      expect(realm0.level, 1);
      expect(realm0.thaiName, 'ผู้ฝึกหัดเปิดชีพจร');

      // 150 Qi -> Level 2 (Qi Condensation Mid)
      final realm150 = CultivationRealm.fromQi(150);
      expect(realm150.level, 2);

      // 1000 Qi -> Level 5 (Body Refining Early)
      final realm1000 = CultivationRealm.fromQi(1000);
      expect(realm1000.level, 5);
      expect(realm1000.thaiName, 'หลอมรวมกายา');

      // 8000 Qi -> Level 13 (Golden Core Early)
      final realm8000 = CultivationRealm.fromQi(8000);
      expect(realm8000.level, 13);
      expect(realm8000.thaiName, 'แก่นแท้ทองคำ');

      // 50000 Qi -> Level 20 (Heavenly Immortal)
      final realmMax = CultivationRealm.fromQi(50000);
      expect(realmMax.level, 20);
      expect(realmMax.thaiName, 'เซียนสวรรค์ไร้พ่าย');
    });

    test('CultivationRealm.fromLevel returns exact realm', () {
      final realm5 = CultivationRealm.fromLevel(5);
      expect(realm5.level, 5);
      expect(realm5.englishName, 'Body Refining');
    });
  });
}
