import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:murim_app/core/theme/app_colors.dart';
import 'package:murim_app/core/theme/app_text_styles.dart';
import 'package:murim_app/presentation/providers/cultivation_provider.dart';
import 'package:murim_app/presentation/widgets/breakthrough_dialog.dart';
import 'package:murim_app/presentation/widgets/wuxia_button.dart';
import 'package:murim_app/presentation/widgets/wuxia_card.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> with SingleTickerProviderStateMixin {
  int _selectedMinutes = 25;
  int _secondsRemaining = 25 * 60;
  bool _isRunning = false;
  Timer? _timer;
  late AnimationController _pulseController;

  final List<int> _presetMinutes = [10, 20, 25, 45, 60];

  @override
  void initState() {
    super.initState();
    _secondsRemaining = _selectedMinutes * 60;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _selectDuration(int minutes) {
    if (_isRunning) return;
    setState(() {
      _selectedMinutes = minutes;
      _secondsRemaining = minutes * 60;
    });
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _completeSession();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _secondsRemaining = _selectedMinutes * 60;
    });
  }

  Future<void> _completeSession() async {
    _timer?.cancel();
    setState(() => _isRunning = false);

    final cultivation = context.read<CultivationProvider>();
    final gainedQi = await cultivation.recordMeditationSession(minutes: _selectedMinutes);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.self_improvement_rounded, color: AppColors.jadeLight),
              const SizedBox(width: 8),
              Text(
                'ปิดด่านสำเร็จ! ได้รับพลังปราณบริสุทธิ์ +$gainedQi Qi',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
        ),
      );

      if (cultivation.latestBreakthroughRealm != null) {
        final realm = cultivation.latestBreakthroughRealm!;
        cultivation.clearBreakthroughNotice();
        BreakthroughDialog.show(context, realm);
      }

      setState(() {
        _secondsRemaining = _selectedMinutes * 60;
      });
    }
  }

  String _formatTime(int totalSeconds) {
    final mins = totalSeconds ~/ 60;
    final secs = totalSeconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1.0 - (_secondsRemaining / (_selectedMinutes * 60));
    final cultivation = context.watch<CultivationProvider>();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 800;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 32 : 16,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    // Title
                    Text(
                      'ห้องปิดด่านฝึกตน (Secluded Cultivation)',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading1.copyWith(
                        color: AppColors.goldLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'กำหนดลมหายใจ ทำสมาธิ หรือโฟกัสกับการอ่านหนังสือเพื่อกลั่นปราณบริสุทธิ์',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 32),

                    // Breathing Qi Orb & Timer
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final scale = _isRunning ? 1.0 + (_pulseController.value * 0.08) : 1.0;
                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            width: 240,
                            height: 240,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppColors.qiPrimary.withValues(alpha: 0.25),
                                  AppColors.jadePrimary.withValues(alpha: 0.08),
                                  Colors.transparent,
                                ],
                              ),
                              border: Border.all(
                                color: _isRunning ? AppColors.qiLight : AppColors.border,
                                width: 2,
                              ),
                              boxShadow: _isRunning
                                  ? [
                                      BoxShadow(
                                        color: AppColors.qiPrimary.withValues(alpha: 0.35),
                                        blurRadius: 25,
                                        spreadRadius: 4,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Progress Ring
                                SizedBox(
                                  width: 220,
                                  height: 220,
                                  child: CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 4,
                                    backgroundColor: AppColors.surfaceLight.withValues(alpha: 0.5),
                                    color: AppColors.qiPrimary,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.self_improvement_rounded,
                                      color: _isRunning ? AppColors.qiLight : AppColors.textMuted,
                                      size: 38,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _formatTime(_secondsRemaining),
                                      style: TextStyle(
                                        fontSize: 42,
                                        fontWeight: FontWeight.w900,
                                        color: _isRunning ? AppColors.textPrimary : AppColors.textSecondary,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    Text(
                                      _isRunning ? 'กำลังไหลเวียนลมปราณ...' : 'พร้อมบำเพ็ญสมาธิ',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: _isRunning ? AppColors.qiLight : AppColors.textMuted,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Duration Presets (Only when not running)
                    if (!_isRunning) ...[
                      Text(
                        'เลือกระยะเวลาบำเพ็ญเพียร',
                        style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: _presetMinutes.map((mins) {
                          final isSelected = _selectedMinutes == mins;
                          return InkWell(
                            onTap: () => _selectDuration(mins),
                            borderRadius: BorderRadius.circular(10),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.qiPrimary.withValues(alpha: 0.25)
                                    : AppColors.surfaceLight.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? AppColors.qiPrimary : AppColors.border,
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                              ),
                              child: Text(
                                '$mins นาที',
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? AppColors.qiLight : AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!_isRunning)
                          WuxiaButton(
                            text: 'เริ่มปิดด่านบำเพ็ญ',
                            icon: Icons.play_arrow_rounded,
                            style: WuxiaButtonStyle.jade,
                            height: 52,
                            onPressed: _startTimer,
                          )
                        else ...[
                          WuxiaButton(
                            text: 'พักการเดินลมปราณ',
                            icon: Icons.pause_rounded,
                            style: WuxiaButtonStyle.gold,
                            height: 50,
                            onPressed: _pauseTimer,
                          ),
                          const SizedBox(width: 14),
                          WuxiaButton(
                            text: 'ออกจากด่าน',
                            icon: Icons.stop_rounded,
                            style: WuxiaButtonStyle.outline,
                            height: 50,
                            onPressed: _resetTimer,
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Stats summary card
                    WuxiaCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                '${cultivation.stats.meditationMinutes} นาที',
                                style: AppTextStyles.qiCounter.copyWith(
                                  color: AppColors.qiLight,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'เวลาปิดด่านสะสม',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: AppColors.divider,
                          ),
                          Column(
                            children: [
                              Text(
                                '+${_selectedMinutes * 2 + (_selectedMinutes >= 25 ? 15 : 0)} Qi',
                                style: AppTextStyles.qiCounter.copyWith(
                                  color: AppColors.goldLight,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'รางวัลเซสชันนี้',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
