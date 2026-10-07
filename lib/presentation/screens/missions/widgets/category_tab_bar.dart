import 'package:flutter/material.dart';
import 'package:murim_app/core/theme/app_colors.dart';
import 'package:murim_app/data/models/cultivation_category.dart';

/// CategoryTabBar
/// Styled like Bamboo Tablets (ป้ายไม้ไผ่หมวดวิชาสำนัก)
class CategoryTabBar extends StatelessWidget {
  final CultivationCategory? selectedCategory;
  final Function(CultivationCategory?) onCategorySelected;
  final Map<CultivationCategory, int> counts;

  const CategoryTabBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.counts = const {},
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // "ทั้งหมด" Tab
          _buildTab(
            title: 'เทียบทั้งหมด',
            icon: Icons.all_inclusive_rounded,
            isSelected: selectedCategory == null,
            color: AppColors.goldPrimary,
            count: null,
            onTap: () => onCategorySelected(null),
          ),
          const SizedBox(width: 8),

          // Categories
          ...CultivationCategory.values.map((cat) {
            final isSelected = selectedCategory == cat;
            final count = counts[cat] ?? 0;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildTab(
                title: cat.thaiTitle,
                icon: cat.icon,
                isSelected: isSelected,
                color: cat.color,
                count: count > 0 ? count : null,
                onTap: () => onCategorySelected(cat),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String title,
    required IconData icon,
    required bool isSelected,
    required Color color,
    required int? count,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.16)
                : AppColors.surfaceLight.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color.withValues(alpha: 0.8) : AppColors.border,
              width: isSelected ? 1.2 : 0.9,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.15),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected ? color : AppColors.textSecondary,
              ),
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? color : AppColors.textSecondary,
                ),
              ),
              if (count != null) ...[
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: isSelected ? color : AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? const Color(0xFF090B10) : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
