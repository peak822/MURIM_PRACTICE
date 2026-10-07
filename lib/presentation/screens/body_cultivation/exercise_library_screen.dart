import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/body_cultivation_models.dart';
import '../../providers/body_cultivation_provider.dart';
import '../../widgets/wuxia_card.dart';
import 'active_session_screen.dart';
import 'widgets/exercise_detail_dialog.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BodyCultivationProvider>(
      builder: (context, provider, _) {
        final exercises = provider.filteredExercises;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'คัมภีร์รวบรวมท่วงท่ากายา',
              style: TextStyle(
                color: AppColors.goldLight,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Column(
            children: [
              // Search & Filter Header
              Container(
                color: AppColors.surface,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    // Search Field
                    TextField(
                      controller: _searchController,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                      onChanged: (val) => provider.setSearchQuery(val),
                      decoration: InputDecoration(
                        hintText: 'ค้นหาท่วงท่า, กล้ามเนื้อเป้าหมาย หรือชื่อวิชา...',
                        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                        prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: AppColors.textMuted, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  provider.setSearchQuery('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: AppColors.surfaceElevated,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.goldPrimary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Category Filter Tabs
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCategoryChip(
                            label: 'ทั้งหมด (${provider.exercises.length})',
                            isSelected: provider.selectedCategory == null,
                            onTap: () => provider.setSelectedCategory(null),
                          ),
                          const SizedBox(width: 8),
                          ...ExerciseCategory.values.map((cat) {
                            final isSelected = provider.selectedCategory == cat;
                            final count = provider.exercises.where((e) => e.category == cat).length;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: _buildCategoryChip(
                                label: '${cat.thaiLabel} ($count)',
                                isSelected: isSelected,
                                onTap: () => provider.setSelectedCategory(isSelected ? null : cat),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Exercise List
              Expanded(
                child: exercises.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 48, color: AppColors.textMuted),
                            const SizedBox(height: 12),
                            const Text(
                              'ไม่พบท่วงท่าที่ตรงกับคำค้นหา',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                _searchController.clear();
                                provider.setSearchQuery('');
                                provider.setSelectedCategory(null);
                              },
                              child: const Text('ล้างตัวกรองทั้งหมด', style: TextStyle(color: AppColors.goldLight)),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = exercises[index];
                          return _buildExerciseCard(context, provider, exercise);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.goldPrimary.withValues(alpha: 0.2) : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.goldPrimary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.goldLight : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(
    BuildContext context,
    BodyCultivationProvider provider,
    Exercise exercise,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: WuxiaCard(
        padding: const EdgeInsets.all(14),
        borderColor: AppColors.border,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.crimsonPrimary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.crimsonPrimary.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        exercise.category.thaiLabel,
                        style: const TextStyle(
                          color: AppColors.crimsonLight,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        exercise.difficulty.thaiLabel,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  exercise.defaultDurationSeconds > 0
                      ? '${exercise.defaultSets} เซ็ต × ${exercise.defaultDurationSeconds} วิ'
                      : '${exercise.defaultSets} เซ็ต × ${exercise.defaultReps} ครั้ง',
                  style: const TextStyle(
                    color: AppColors.textGold,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              exercise.murimName,
              style: const TextStyle(
                color: AppColors.goldLight,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              exercise.name,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),

            // Target Muscles
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: exercise.targetMuscles.map((muscle) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '#$muscle',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => ExerciseDetailDialog(
                        exercise: exercise,
                        onStartTraining: (ex) => _startSingleExercise(context, provider, ex),
                      ),
                    );
                  },
                  icon: const Icon(Icons.menu_book, size: 14),
                  label: const Text('ดูวิธีฝึก'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _startSingleExercise(context, provider, exercise),
                  icon: const Icon(Icons.play_arrow, size: 14),
                  label: const Text('เริ่มฝึกท่านี้'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldPrimary,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _startSingleExercise(BuildContext context, BodyCultivationProvider provider, Exercise exercise) {
    provider.startCustomSession(
      title: exercise.name,
      murimTitle: exercise.murimName,
      exercises: [exercise],
      targetRealmLevel: exercise.difficulty.tier,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ActiveSessionScreen(),
      ),
    );
  }
}
