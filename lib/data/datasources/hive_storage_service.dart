import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../models/cultivation_category.dart';
import '../models/mission_model.dart';
import '../models/user_stats_model.dart';
import '../models/cultivation_log.dart';

class HiveStorageService {
  static final HiveStorageService _instance = HiveStorageService._internal();
  factory HiveStorageService() => _instance;
  HiveStorageService._internal();

  late Box<Map> _missionsBox;
  late Box<Map> _userStatsBox;
  late Box<Map> _logsBox;
  late Box<dynamic> _settingsBox;

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await Hive.initFlutter();

      _missionsBox = await Hive.openBox<Map>(AppConstants.missionsBoxName);
      _userStatsBox = await Hive.openBox<Map>(AppConstants.userStatsBoxName);
      _logsBox = await Hive.openBox<Map>(AppConstants.cultivationLogsBoxName);
      _settingsBox = await Hive.openBox<dynamic>(AppConstants.settingsBoxName);

      _isInitialized = true;

      // Seed default starter missions and stats ONLY on very first install/launch
      final bool hasSeeded = _settingsBox.get('has_seeded_initial_data', defaultValue: false);
      if (!hasSeeded) {
        await _seedInitialData();
        await _settingsBox.put('has_seeded_initial_data', true);
      }
    } catch (e, stack) {
      debugPrint('Error initializing HiveStorageService: $e\n$stack');
      _isInitialized = true;
    }
  }

  Future<void> _seedInitialData() async {
    final now = DateTime.now();
    final starterMissions = [
      Mission(
        id: 'starter_1',
        title: 'อ่านตำราคัมภีร์วิชาการ 25 นาที',
        description: 'อ่านหนังสือหรือบทความเพื่อเพิ่มพูนปัญญาและความรู้ใหม่',
        category: CultivationCategory.mind,
        xpReward: 35,
        difficulty: 1,
        estimatedMinutes: 25,
        createdAt: now,
        isDaily: true,
        tags: ['การเรียนรู้', 'สติปัญญา'],
      ),
      Mission(
        id: 'starter_2',
        title: 'ออกกำลังกายขัดเกลากายา 20 นาที',
        description: 'วิดพื้น สควอท หรือวิ่งเพื่อเสริมสร้างพละกำลังและสุขภาพ',
        category: CultivationCategory.body,
        xpReward: 30,
        difficulty: 1,
        estimatedMinutes: 20,
        createdAt: now,
        isDaily: true,
        tags: ['ร่างกาย', 'ฟิตเนส'],
      ),
      Mission(
        id: 'starter_3',
        title: 'ฝึกปรือวิชาเขียนโค้ดและสร้างฟีเจอร์ใหม่',
        description: 'พัฒนาโปรเจกต์ เขียนฟังก์ชัน หรือฝึกแก้โจทย์ปัญหาโค้ด',
        category: CultivationCategory.martial,
        xpReward: 55,
        difficulty: 2,
        estimatedMinutes: 45,
        createdAt: now,
        isDaily: false,
        tags: ['วรยุทธ์', 'โปรแกรมมิ่ง'],
      ),
      Mission(
        id: 'starter_4',
        title: 'ปิดด่านทำสมาธิกำหนดลมหายใจ 10 นาที',
        description: 'นั่งสมาธิ กำหนดจิตให้สงบนิ่ง ผ่อนคลายความตึงเครียด',
        category: CultivationCategory.spiritual,
        xpReward: 25,
        difficulty: 1,
        estimatedMinutes: 10,
        createdAt: now,
        isDaily: true,
        tags: ['สมาธิ', 'ลมปราณ'],
      ),
    ];

    for (final mission in starterMissions) {
      await saveMission(mission);
    }

    if (_userStatsBox.isEmpty) {
      final initialStats = UserStats(
        userName: 'ศิษย์เอกแห่งยุทธภพ',
        sectName: 'สำนักกระบี่ฟ้าเมฆา',
        lastActiveDate: now,
      );
      await saveUserStats(initialStats);
    }
  }

  // --- Missions Operations ---

  List<Mission> getAllMissions() {
    try {
      final list = <Mission>[];
      for (final value in _missionsBox.values) {
        list.add(Mission.fromMap(value));
      }
      // Sort: incomplete first, then by createdAt descending
      list.sort((a, b) {
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        return b.createdAt.compareTo(a.createdAt);
      });
      return list;
    } catch (e) {
      debugPrint('Error loading missions: $e');
      return [];
    }
  }

  Future<void> saveMission(Mission mission) async {
    await _missionsBox.put(mission.id, mission.toMap());
  }

  Future<void> deleteMission(String id) async {
    await _missionsBox.delete(id);
  }

  // --- User Stats Operations ---

  UserStats getUserStats() {
    try {
      final map = _userStatsBox.get(AppConstants.keyUserStats);
      if (map != null) {
        return UserStats.fromMap(map);
      }
      return const UserStats();
    } catch (e) {
      debugPrint('Error loading user stats: $e');
      return const UserStats();
    }
  }

  Future<void> saveUserStats(UserStats stats) async {
    await _userStatsBox.put(AppConstants.keyUserStats, stats.toMap());
  }

  // --- Cultivation Logs Operations ---

  List<CultivationLog> getAllLogs() {
    try {
      final list = <CultivationLog>[];
      for (final value in _logsBox.values) {
        list.add(CultivationLog.fromMap(value));
      }
      list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return list;
    } catch (e) {
      debugPrint('Error loading cultivation logs: $e');
      return [];
    }
  }

  Future<void> addLog(CultivationLog log) async {
    await _logsBox.put(log.id, log.toMap());
  }

  Future<void> clearAllLogs() async {
    await _logsBox.clear();
  }

  // --- Settings Operations ---

  T getSetting<T>(String key, T defaultValue) {
    return _settingsBox.get(key, defaultValue: defaultValue) as T;
  }

  Future<void> setSetting<T>(String key, T value) async {
    await _settingsBox.put(key, value);
  }

  Future<void> resetAllData() async {
    await _missionsBox.clear();
    await _userStatsBox.clear();
    await _logsBox.clear();
    await _seedInitialData();
    await _settingsBox.put('has_seeded_initial_data', true);
  }
}
