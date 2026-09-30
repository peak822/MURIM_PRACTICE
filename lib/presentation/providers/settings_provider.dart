import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../data/datasources/hive_storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final HiveStorageService _storage;

  bool _soundEnabled = true;
  bool _hapticEnabled = true;

  SettingsProvider({HiveStorageService? storage})
      : _storage = storage ?? HiveStorageService() {
    _loadSettings();
  }

  bool get soundEnabled => _soundEnabled;
  bool get hapticEnabled => _hapticEnabled;

  void _loadSettings() {
    _soundEnabled = _storage.getSetting<bool>(AppConstants.keySoundEnabled, true);
    _hapticEnabled = _storage.getSetting<bool>(AppConstants.keyHapticEnabled, true);
    notifyListeners();
  }

  Future<void> toggleSound(bool value) async {
    _soundEnabled = value;
    await _storage.setSetting(AppConstants.keySoundEnabled, value);
    notifyListeners();
  }

  Future<void> toggleHaptic(bool value) async {
    _hapticEnabled = value;
    await _storage.setSetting(AppConstants.keyHapticEnabled, value);
    notifyListeners();
  }
}
