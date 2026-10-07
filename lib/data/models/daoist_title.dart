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
