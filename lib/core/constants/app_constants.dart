class AppConstants {
  AppConstants._();

  static const String appName = 'Murim Study Tracker';
  static const String appSubtitle = 'บันทึกการฝึกตนและบ่มเพาะวรยุทธ์';
  static const String appVersion = '1.0.0';

  // Hive Box Names
  static const String missionsBoxName = 'murim_missions_box';
  static const String userStatsBoxName = 'murim_user_stats_box';
  static const String cultivationLogsBoxName = 'murim_cultivation_logs_box';
  static const String settingsBoxName = 'murim_settings_box';

  // Storage Keys
  static const String keyUserStats = 'current_user_stats';
  static const String keySoundEnabled = 'setting_sound_enabled';
  static const String keyHapticEnabled = 'setting_haptic_enabled';
  static const String keyCustomTheme = 'setting_custom_theme';

  // Cultivation Quotes (คำคมผู้บำเพ็ญเพียร)
  static const List<String> cultivationQuotes = [
    '“หนทางหมื่นลี้ เริ่มต้นที่ก้าวแรกของการบ่มเพาะลมปราณ”',
    '“กระบี่ที่คมกริบ เกิดจากการลับฝนเป็นหมื่นครั้ง จิตใจที่เข้มแข็ง เกิดจากวินัยที่สม่ำเสมอ”',
    '“ความเพียรพยายามดั่งหยดน้ำเซาะหิน วันละนิดย่อมทะลวงด่านใหญ่ได้ในที่สุด”',
    '“ยอดฝีมือที่แท้จริง ไม่ได้ชนะผู้อื่น แต่คือผู้ที่ชนะความเกียจคร้านในตนเอง”',
    '“เมื่อจิตสงบ ดั่งผิวน้ำไร้ระลอกคลื่น ปัญญาย่อมสว่างแจ้งดั่งดวงจันทรา”',
    '“การฝึกฝนหนึ่งชั่วยามในวันนี้ คือรากฐานแห่งการเป็นเซียนในวันหน้า”',
  ];
}
