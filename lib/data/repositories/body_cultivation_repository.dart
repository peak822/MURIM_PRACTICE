import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../datasources/exercise_database.dart';
import '../models/body_cultivation_models.dart';

abstract class BodyCultivationRepository {
  List<Exercise> getAllExercises();
  Exercise? getExerciseById(String id);
  List<TrainingSessionTemplate> getAllTemplates();
  TrainingSessionTemplate? getTemplateById(String id);
  List<TrainingRecord> getTrainingRecords();
  Future<void> saveTrainingRecord(TrainingRecord record);
  Future<void> deleteTrainingRecord(String id);
}

class BodyCultivationRepositoryImpl implements BodyCultivationRepository {
  final List<TrainingRecord> _memoryRecords = [];
  Box<Map>? _recordsBox;
  bool _isHiveReady = false;

  BodyCultivationRepositoryImpl() {
    _initHive();
  }

  Future<void> _initHive() async {
    try {
      if (Hive.isBoxOpen(AppConstants.trainingRecordsBoxName)) {
        _recordsBox = Hive.box<Map>(AppConstants.trainingRecordsBoxName);
        _isHiveReady = true;
      }
    } catch (e) {
      debugPrint('BodyCultivationRepositoryImpl: Running in memory mode: $e');
    }
  }

  @override
  List<Exercise> getAllExercises() {
    return ExerciseDatabase.defaultExercises;
  }

  @override
  Exercise? getExerciseById(String id) {
    try {
      return ExerciseDatabase.defaultExercises.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  List<TrainingSessionTemplate> getAllTemplates() {
    return ExerciseDatabase.defaultSessions;
  }

  @override
  TrainingSessionTemplate? getTemplateById(String id) {
    try {
      return ExerciseDatabase.defaultSessions.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  List<TrainingRecord> getTrainingRecords() {
    if (_isHiveReady && _recordsBox != null) {
      try {
        final list = <TrainingRecord>[];
        for (final value in _recordsBox!.values) {
          list.add(TrainingRecord.fromMap(value));
        }
        list.sort((a, b) => b.completedAt.compareTo(a.completedAt));
        return list;
      } catch (e) {
        debugPrint('Error reading training records from Hive: $e');
      }
    }
    final list = List<TrainingRecord>.from(_memoryRecords);
    list.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return list;
  }

  @override
  Future<void> saveTrainingRecord(TrainingRecord record) async {
    _memoryRecords.removeWhere((r) => r.id == record.id);
    _memoryRecords.add(record);

    if (_isHiveReady && _recordsBox != null) {
      try {
        await _recordsBox!.put(record.id, record.toMap());
      } catch (e) {
        debugPrint('Error saving training record to Hive: $e');
      }
    }
  }

  @override
  Future<void> deleteTrainingRecord(String id) async {
    _memoryRecords.removeWhere((r) => r.id == id);

    if (_isHiveReady && _recordsBox != null) {
      try {
        await _recordsBox!.delete(id);
      } catch (e) {
        debugPrint('Error deleting training record from Hive: $e');
      }
    }
  }
}
