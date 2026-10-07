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
