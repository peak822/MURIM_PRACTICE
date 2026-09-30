import '../datasources/hive_storage_service.dart';
import '../models/mission_model.dart';
import '../models/cultivation_category.dart';

abstract class MissionRepository {
  List<Mission> getMissions();
  Future<void> addMission(Mission mission);
  Future<void> updateMission(Mission mission);
  Future<void> deleteMission(String id);
  List<Mission> getMissionsByCategory(CultivationCategory category);
}

class MissionRepositoryImpl implements MissionRepository {
  final HiveStorageService _storage;

  MissionRepositoryImpl({HiveStorageService? storage})
      : _storage = storage ?? HiveStorageService();

  @override
  List<Mission> getMissions() {
    return _storage.getAllMissions();
  }

  @override
  Future<void> addMission(Mission mission) async {
    await _storage.saveMission(mission);
  }

  @override
  Future<void> updateMission(Mission mission) async {
    await _storage.saveMission(mission);
  }

  @override
  Future<void> deleteMission(String id) async {
    await _storage.deleteMission(id);
  }

  @override
  List<Mission> getMissionsByCategory(CultivationCategory category) {
    return _storage
        .getAllMissions()
        .where((m) => m.category == category)
        .toList();
  }
}
