import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CultivationRealm {
  final int level;
  final String thaiName;
  final String englishName;
  final String stage; // ขั้นต้น, ขั้นกลาง, ขั้นสูง, ขั้นสมบูรณ์
  final int minQi;
  final int maxQi;
  final String description;
  final String breakthroughQuote;
  final Color primaryColor;
  final Color glowColor;

  const CultivationRealm({
    required this.level,
    required this.thaiName,
    required this.englishName,
    required this.stage,
    required this.minQi,
    required this.maxQi,
    required this.description,
    required this.breakthroughQuote,
    required this.primaryColor,
    required this.glowColor,
  });

  String get fullThaiTitle => '$thaiName ($stage)';
  String get fullEnglishTitle => '$englishName - $stage';

  // All realm definitions
  static const List<CultivationRealm> realms = [
    // Level 1-4: ชนชั้นเปิดชีพจร (Qi Condensation)
    CultivationRealm(
      level: 1,
      thaiName: 'ผู้ฝึกหัดเปิดชีพจร',
      englishName: 'Qi Condensation',
      stage: 'ขั้นต้น',
      minQi: 0,
      maxQi: 100,
      description: 'เริ่มต้นสัมผัสไอพลังฟ้าดิน ทะลวงจุดชีพจรเบื้องต้น',
      breakthroughQuote: 'ก้าวแรกแห่งยุทธภพ ลมปราณสายแรกเริ่มไหลเวียน!',
      primaryColor: AppColors.textSecondary,
      glowColor: Color(0x3394A3B8),
    ),
    CultivationRealm(
      level: 2,
      thaiName: 'ผู้ฝึกหัดเปิดชีพจร',
      englishName: 'Qi Condensation',
      stage: 'ขั้นกลาง',
      minQi: 100,
      maxQi: 250,
      description: 'ชีพจรหลัก 12 สายเริ่มเปิดกว้าง พลังไหลเวียนคล่องแคล่ว',
      breakthroughQuote: 'เส้นชีพจรปลอดโปร่ง พลังกายเพิ่มพูนเป็นเท่าตัว',
      primaryColor: AppColors.jadeLight,
      glowColor: AppColors.jadeAura,
    ),
    CultivationRealm(
      level: 3,
      thaiName: 'ผู้ฝึกหัดเปิดชีพจร',
      englishName: 'Qi Condensation',
      stage: 'ขั้นสูง',
      minQi: 250,
      maxQi: 450,
      description: 'รวบรวมลมปราณไว้ที่จุดตันเถียน สมาธิแน่วแน่ดั่งศิลา',
      breakthroughQuote: 'ตันเถียนก่อกำเนิดวังวนปราณ สมาธิตั้งมั่นไร้สิ่งรบกวน',
      primaryColor: AppColors.jadePrimary,
      glowColor: AppColors.jadeAura,
    ),
    CultivationRealm(
      level: 4,
      thaiName: 'ผู้ฝึกหัดเปิดชีพจร',
      englishName: 'Qi Condensation',
      stage: 'ขั้นสมบูรณ์',
      minQi: 450,
      maxQi: 700,
      description: 'พร้อมที่จะทะลวงด่านใหญ่เข้าสู่ขอบเขตหลอมรวมกายา',
      breakthroughQuote: 'พลังปราณเต็มเปี่ยม พร้อมทะลวงสู่ขอบเขตใหม่!',
      primaryColor: AppColors.jadePrimary,
      glowColor: AppColors.jadeAura,
    ),

    // Level 5-8: หลอมรวมกายา (Body Refining)
    CultivationRealm(
      level: 5,
      thaiName: 'หลอมรวมกายา',
      englishName: 'Body Refining',
      stage: 'ขั้นต้น',
      minQi: 700,
      maxQi: 1050,
      description: 'ขัดเกลากล้ามเนื้อและกระดูก กายาแข็งแกร่งดุจทองแดง',
      breakthroughQuote: 'กายาแปรเปลี่ยน ดั่งทองแดงหลอมใหม่ในเตาอัคคี!',
      primaryColor: AppColors.crimsonPrimary,
      glowColor: Color(0x33E11D48),
    ),
    CultivationRealm(
      level: 6,
      thaiName: 'หลอมรวมกายา',
      englishName: 'Body Refining',
      stage: 'ขั้นกลาง',
      minQi: 1050,
      maxQi: 1500,
      description: 'กระดูกดั่งเหล็กกล้า เส้นเอ็นดั่งสายธนู',
      breakthroughQuote: 'พละกำลังไร้ขีดจำกัด ปลุกพลังมังกรในกายา',
      primaryColor: AppColors.crimsonPrimary,
      glowColor: Color(0x33E11D48),
    ),
    CultivationRealm(
      level: 7,
      thaiName: 'หลอมรวมกายา',
      englishName: 'Body Refining',
      stage: 'ขั้นสูง',
      minQi: 1500,
      maxQi: 2100,
      description: 'โลหิตไหลเวียนดั่งสายน้ำเชี่ยว จิตใจและกายาสอดประสาน',
      breakthroughQuote: 'หยาดเหงื่อกลายเป็นพลัง จิตและกายรวมเป็นหนึ่งเดียว',
      primaryColor: AppColors.crimsonLight,
      glowColor: Color(0x44E11D48),
    ),
    CultivationRealm(
      level: 8,
      thaiName: 'หลอมรวมกายา',
      englishName: 'Body Refining',
      stage: 'ขั้นสมบูรณ์',
      minQi: 2100,
      maxQi: 2800,
      description: 'กายาสมบูรณ์พร้อมรองรับลมปราณแท้จริง',
      breakthroughQuote: 'กายาระดับสุดยอด พร้อมก้าวสู่รากฐานแห่งเซียน!',
      primaryColor: AppColors.crimsonLight,
      glowColor: Color(0x44E11D48),
    ),

    // Level 9-12: ก่อกำเนิดรากฐาน (Foundation Establishment)
    CultivationRealm(
      level: 9,
      thaiName: 'ก่อกำเนิดรากฐาน',
      englishName: 'Foundation Establishment',
      stage: 'ขั้นต้น',
      minQi: 2800,
      maxQi: 3700,
      description: 'หลอมสร้างทะเลปราณในตันเถียน ปัญญากว้างไกลดั่งมหาสมุทร',
      breakthroughQuote: 'ทะเลลมปราณเปิดออก รากฐานแห่งมรรคาสวรรค์ถูกสร้างขึ้น!',
      primaryColor: AppColors.qiPrimary,
      glowColor: AppColors.qiGlow,
    ),
    CultivationRealm(
      level: 10,
      thaiName: 'ก่อกำเนิดรากฐาน',
      englishName: 'Foundation Establishment',
      stage: 'ขั้นกลาง',
      minQi: 3700,
      maxQi: 4800,
      description: 'คลื่นลมปราณสม่ำเสมอ สามารถควบคุมสมาธิได้อย่างสมบูรณ์',
      breakthroughQuote: 'ปัญญาเฉียบคม เข้าใจวิชาและศาสตร์ต่าง ๆ อย่างทะลุปรุโปร่ง',
      primaryColor: AppColors.qiPrimary,
      glowColor: AppColors.qiGlow,
    ),
    CultivationRealm(
      level: 11,
      thaiName: 'ก่อกำเนิดรากฐาน',
      englishName: 'Foundation Establishment',
      stage: 'ขั้นสูง',
      minQi: 4800,
      maxQi: 6100,
      description: 'ลมปราณแปรสภาพเป็นของเหลวบริสุทธิ์',
      breakthroughQuote: 'ลมปราณกลั่นตัวเป็นหยดน้ำทิพย์ หล่อเลี้ยงวิญญาณ',
      primaryColor: AppColors.qiLight,
      glowColor: AppColors.qiGlow,
    ),
    CultivationRealm(
      level: 12,
      thaiName: 'ก่อกำเนิดรากฐาน',
      englishName: 'Foundation Establishment',
      stage: 'ขั้นสมบูรณ์',
      minQi: 6100,
      maxQi: 7600,
      description: 'รากฐานมั่นคงดุจขุนเขา พร้อมหลอมรวมเป็นแก่นแท้ทองคำ',
      breakthroughQuote: 'รากฐานแข็งแกร่งดั่งภูผา มุ่งสู่แก่นแท้แห่งเต๋า!',
      primaryColor: AppColors.qiLight,
      glowColor: AppColors.qiGlow,
    ),

    // Level 13-16: แก่นแท้ทองคำ (Golden Core Realm)
    CultivationRealm(
      level: 13,
      thaiName: 'แก่นแท้ทองคำ',
      englishName: 'Golden Core',
      stage: 'ขั้นต้น',
      minQi: 7600,
      maxQi: 9500,
      description: 'ควบแน่นทะเลปราณเป็นลูกแก้วทองคำส่องประกายเรืองรอง',
      breakthroughQuote: 'เม็ดทองคำก่อกำเนิด แสงทองส่องสว่างทั่วร่าง!',
      primaryColor: AppColors.goldPrimary,
      glowColor: AppColors.borderGlow,
    ),
    CultivationRealm(
      level: 14,
      thaiName: 'แก่นแท้ทองคำ',
      englishName: 'Golden Core',
      stage: 'ขั้นกลาง',
      minQi: 9500,
      maxQi: 11800,
      description: 'แก่นทองคำหมุนวนไม่หยุดยั้ง พลังฟื้นฟูต่อเนื่องไร้ที่สิ้นสุด',
      breakthroughQuote: 'พลังหมุนเวียนดั่งจักรวาล สมาธิและวินัยเป็นหนึ่งเดียว',
      primaryColor: AppColors.goldPrimary,
      glowColor: AppColors.borderGlow,
    ),
    CultivationRealm(
      level: 15,
      thaiName: 'แก่นแท้ทองคำ',
      englishName: 'Golden Core',
      stage: 'ขั้นสูง',
      minQi: 11800,
      maxQi: 14500,
      description: 'แก่นทองคำสลักลวดลายแห่งมรรคาสวรรค์ 9 วงแหวน',
      breakthroughQuote: 'สลักลายเต๋าเก้าชั้น จิตใจหยั่งถึงความจริงแท้',
      primaryColor: AppColors.goldLight,
      glowColor: AppColors.borderGlow,
    ),
    CultivationRealm(
      level: 16,
      thaiName: 'แก่นแท้ทองคำ',
      englishName: 'Golden Core',
      stage: 'ขั้นสมบูรณ์',
      minQi: 14500,
      maxQi: 18000,
      description: 'พร้อมฟักตัวเป็นดวงวิญญาณบริสุทธิ์',
      breakthroughQuote: 'แก่นทองคำสุกงอม พร้อมกำเนิดปฐมวิญญาณ!',
      primaryColor: AppColors.goldLight,
      glowColor: AppColors.borderGlow,
    ),

    // Level 17-20: ก่อกำเนิดวิญญาณ & เซียนสวรรค์ (Nascent Soul & Heavenly Immortal)
    CultivationRealm(
      level: 17,
      thaiName: 'ก่อกำเนิดวิญญาณ',
      englishName: 'Nascent Soul',
      stage: 'ขั้นต้น',
      minQi: 18000,
      maxQi: 23000,
      description: 'ปฐมวิญญาณถือกำเนิด จิตสำนึกสามารถแยกออกจากกายเนื้อ',
      breakthroughQuote: 'วิญญาณก่อเกิดเป็นรูปร่าง ก้าวข้ามขีดจำกัดมนุษย์!',
      primaryColor: AppColors.mindPrimary,
      glowColor: Color(0x448B5CF6),
    ),
    CultivationRealm(
      level: 18,
      thaiName: 'ก่อกำเนิดวิญญาณ',
      englishName: 'Nascent Soul',
      stage: 'ขั้นสูง',
      minQi: 23000,
      maxQi: 30000,
      description: 'จิตวิญญาณหยั่งรู้ฟ้าดิน สามารถเรียนรู้สรรพวิชาในพริบตา',
      breakthroughQuote: 'ปัญญาหยั่งรู้สรรพสิ่ง การเรียนรู้รวดเร็วดุจสายฟ้าฟาด',
      primaryColor: AppColors.mindLight,
      glowColor: Color(0x448B5CF6),
    ),
    CultivationRealm(
      level: 19,
      thaiName: 'ตัดวิถีสู่เซียน',
      englishName: 'Void Transformation',
      stage: 'ขั้นสมบูรณ์',
      minQi: 30000,
      maxQi: 40000,
      description: 'ตัดขาดพันธนาการทางโลก เข้าใจกฎเกณฑ์แห่งธรรมชาติ',
      breakthroughQuote: 'ตัดความลังเล บรรลุมรรคาแห่งความมุ่งมั่นแท้จริง!',
      primaryColor: AppColors.goldAccent,
      glowColor: AppColors.borderGlow,
    ),
    CultivationRealm(
      level: 20,
      thaiName: 'เซียนสวรรค์ไร้พ่าย',
      englishName: 'Heavenly Immortal',
      stage: 'ขั้นสูงสุด (Supreme)',
      minQi: 40000,
      maxQi: 1000000,
      description: 'ผู้บรรลุธรรมชั้นสูงสุด จอมยุทธ์ไร้เทียมทานแห่งแผ่นดิน',
      breakthroughQuote: 'บรรลุมรรคาสวรรค์สูงสุด ยืนหยัดเหนือสรวงสวรรค์และปฐพี!',
      primaryColor: AppColors.goldLight,
      glowColor: Color(0x88F59E0B),
    ),
  ];

  static CultivationRealm fromQi(int totalQi) {
    for (final realm in realms) {
      if (totalQi >= realm.minQi && (totalQi < realm.maxQi || realm.level == realms.last.level)) {
        return realm;
      }
    }
    return realms.last;
  }

  static CultivationRealm fromLevel(int level) {
    return realms.firstWhere(
      (r) => r.level == level,
      orElse: () => realms.first,
    );
  }
}
