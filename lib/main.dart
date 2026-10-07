import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:murim_app/core/services/daily_reset_manager.dart';
import 'package:murim_app/core/theme/app_theme.dart';
import 'package:murim_app/data/datasources/hive_storage_service.dart';
import 'package:murim_app/data/repositories/mission_repository.dart';
import 'package:murim_app/data/repositories/stats_repository.dart';
import 'package:murim_app/data/repositories/body_cultivation_repository.dart';
import 'package:murim_app/presentation/providers/body_cultivation_provider.dart';
import 'package:murim_app/presentation/providers/cultivation_provider.dart';
import 'package:murim_app/presentation/providers/mission_provider.dart';
import 'package:murim_app/presentation/providers/settings_provider.dart';
import 'package:murim_app/presentation/screens/main_shell_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive storage for offline persistence
  final storageService = HiveStorageService();
  await storageService.init();

  // Automated daily mission reset and streak evaluation
  await DailyResetManager.checkAndResetDailyMissions(storage: storageService);

  final missionRepo = MissionRepositoryImpl(storage: storageService);
  final statsRepo = StatsRepositoryImpl(storage: storageService);
  final bodyRepo = BodyCultivationRepositoryImpl();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CultivationProvider(repository: statsRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => MissionProvider(repository: missionRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => BodyCultivationProvider(repository: bodyRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(storage: storageService),
        ),
      ],
      child: const MurimStudyTrackerApp(),
    ),
  );
}

class MurimStudyTrackerApp extends StatelessWidget {
  const MurimStudyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Murim Study Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainShellScreen(),
    );
  }
}
