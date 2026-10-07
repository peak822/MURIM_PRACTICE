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
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'ปิดด่านสำเร็จ! ได้รับพลังปราณบริสุทธิ์ +$gainedQi Qi',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
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
                  horizontal: isDesktop ? 32 : 20,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    // Screen Title & Subtitle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.self_improvement_rounded, color: AppColors.qiLight, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'ห้องปิดด่านฝึกตน (Secluded Cultivation)',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.heading1.copyWith(
                            color: AppColors.goldLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'กำหนดลมหายใจ ทำสมาธิ หรือโฟกัสกับการศึกษาตำราเพื่อกลั่นพลังปราณบริสุทธิ์',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 36),

                    // Breathing Qi Orb & Timer Display
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final scale = _isRunning ? 1.0 + (_pulseController.value * 0.05) : 1.0;
                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppColors.qiPrimary.withValues(alpha: _isRunning ? 0.3 : 0.12),
                                  AppColors.jadePrimary.withValues(alpha: _isRunning ? 0.15 : 0.05),
                                  AppColors.surfaceCard.withValues(alpha: 0.9),
                                ],
                                stops: const [0.0, 0.65, 1.0],
                              ),
                              border: Border.all(
                                color: _isRunning ? AppColors.qiLight : AppColors.borderGold.withValues(alpha: 0.4),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (_isRunning ? AppColors.qiPrimary : AppColors.goldPrimary).withValues(alpha: _isRunning ? 0.35 : 0.12),
                                  blurRadius: _isRunning ? 30 : 16,
                                  spreadRadius: _isRunning ? 6 : 1,
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Circular Progress Ring
                                SizedBox(
                                  width: 230,
                                  height: 230,
                                  child: CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 5,
                                    backgroundColor: AppColors.surfaceLight.withValues(alpha: 0.6),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      _isRunning ? AppColors.qiLight : AppColors.goldPrimary,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.self_improvement_rounded,
                                      color: _isRunning ? AppColors.qiLight : AppColors.goldLight,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _formatTime(_secondsRemaining),
                                      style: AppTextStyles.cinzel(
                                        fontSize: 44,
                                        fontWeight: FontWeight.w900,
                                        color: _isRunning ? AppColors.textPrimary : AppColors.goldLight,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: (_isRunning ? AppColors.qiPrimary : AppColors.goldPrimary).withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: (_isRunning ? AppColors.qiLight : AppColors.goldPrimary).withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Text(
                                        _isRunning ? 'กำลังไหลเวียนลมปราณ...' : 'พร้อมบำเพ็ญสมาธิ',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: _isRunning ? AppColors.qiLight : AppColors.goldLight,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
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

                    const SizedBox(height: 36),

                    // Duration Preset Selector
                    if (!_isRunning) ...[
                      Text(
                        'เลือกระยะเวลาบำเพ็ญเพียร',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.goldLight,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: _presetMinutes.map((mins) {
                          final isSelected = _selectedMinutes == mins;
                          return InkWell(
                            onTap: () => _selectDuration(mins),
                            borderRadius: BorderRadius.circular(10),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.qiPrimary.withValues(alpha: 0.25)
                                    : AppColors.surfaceLight.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? AppColors.qiLight : AppColors.border,
                                  width: isSelected ? 1.6 : 1.0,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.qiPrimary.withValues(alpha: 0.25),
                                          blurRadius: 8,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                '$mins นาที',
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? AppColors.qiLight : AppColors.textSecondary,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 28),
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

                    const SizedBox(height: 36),

                    // Session & Cumulative Stats Card
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
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'เวลาปิดด่านสะสม',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: AppColors.borderGold.withValues(alpha: 0.3),
                          ),
                          Column(
                            children: [
                              Text(
                                '+${_selectedMinutes * 2 + (_selectedMinutes >= 25 ? 15 : 0)} Qi',
                                style: AppTextStyles.qiCounter.copyWith(
                                  color: AppColors.goldLight,
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'รางวัลเซสชันนี้',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
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
