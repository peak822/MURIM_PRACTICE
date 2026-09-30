import 'package:flutter/material.dart';
import 'package:murim_app/core/theme/app_colors.dart';
import 'package:murim_app/data/models/cultivation_category.dart';

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
            title: 'เทียบภารกิจทั้งหมด',
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
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.2)
                : AppColors.surfaceLight.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? color : AppColors.border,
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.25),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? color : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? color : AppColors.textSecondary,
                ),
              ),
              if (count != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: isSelected ? color : AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.black : AppColors.textSecondary,
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
