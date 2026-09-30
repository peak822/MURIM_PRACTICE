import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum CultivationCategory {
  body,
  mind,
  martial,
  spiritual,
}

extension CultivationCategoryExtension on CultivationCategory {
  String get id {
    switch (this) {
      case CultivationCategory.body:
        return 'body';
      case CultivationCategory.mind:
        return 'mind';
      case CultivationCategory.martial:
        return 'martial';
      case CultivationCategory.spiritual:
        return 'spiritual';
    }
  }

  String get thaiTitle {
    switch (this) {
      case CultivationCategory.body:
        return 'บ่มเพาะกายา';
      case CultivationCategory.mind:
        return 'ฝึกจิตปัญญา';
      case CultivationCategory.martial:
        return 'ฝึกปรือวรยุทธ์';
      case CultivationCategory.spiritual:
        return 'ขัดเกลาปราณ';
    }
  }

  String get englishTitle {
    switch (this) {
      case CultivationCategory.body:
        return 'Body Refining';
      case CultivationCategory.mind:
        return 'Mind & Wisdom';
      case CultivationCategory.martial:
        return 'Martial Skills';
      case CultivationCategory.spiritual:
        return 'Spiritual Qi';
    }
  }

  String get description {
    switch (this) {
      case CultivationCategory.body:
        return 'ออกกำลังกาย พักผ่อน สุขภาพกาย';
      case CultivationCategory.mind:
        return 'อ่านหนังสือ ศึกษา ค้นคว้าความรู้';
      case CultivationCategory.martial:
        return 'เขียนโค้ด ฝึกทักษะ ทำโปรเจกต์';
      case CultivationCategory.spiritual:
        return 'ทำสมาธิ ทบทวนตนเอง สร้างวินัย';
    }
  }

  Color get color {
    switch (this) {
      case CultivationCategory.body:
        return AppColors.categoryBody;
      case CultivationCategory.mind:
        return AppColors.categoryMind;
      case CultivationCategory.martial:
        return AppColors.categoryMartial;
      case CultivationCategory.spiritual:
        return AppColors.categorySpiritual;
    }
  }

  IconData get icon {
    switch (this) {
      case CultivationCategory.body:
        return Icons.fitness_center_rounded;
      case CultivationCategory.mind:
        return Icons.menu_book_rounded;
      case CultivationCategory.martial:
        return Icons.bolt_rounded;
      case CultivationCategory.spiritual:
        return Icons.self_improvement_rounded;
    }
  }

  static CultivationCategory fromString(String value) {
    switch (value.toLowerCase()) {
      case 'body':
        return CultivationCategory.body;
      case 'mind':
        return CultivationCategory.mind;
      case 'martial':
        return CultivationCategory.martial;
      case 'spiritual':
      default:
        return CultivationCategory.spiritual;
    }
  }
}
