import '../datasources/hive_storage_service.dart';
import '../models/user_stats_model.dart';
import '../models/cultivation_log.dart';

abstract class StatsRepository {
  UserStats getUserStats();
  Future<void> saveUserStats(UserStats stats);
  List<CultivationLog> getLogs();
  Future<void> addLog(CultivationLog log);
  Future<void> resetAllData();
}

class StatsRepositoryImpl implements StatsRepository {
  final HiveStorageService _storage;

  StatsRepositoryImpl({HiveStorageService? storage})
      : _storage = storage ?? HiveStorageService();

  @override
  UserStats getUserStats() {
    return _storage.getUserStats();
  }

  @override
  Future<void> saveUserStats(UserStats stats) async {
    await _storage.saveUserStats(stats);
  }

  @override
  List<CultivationLog> getLogs() {
    return _storage.getAllLogs();
  }

  @override
  Future<void> addLog(CultivationLog log) async {
    await _storage.addLog(log);
  }

  @override
  Future<void> resetAllData() async {
    await _storage.resetAllData();
  }
}
