import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PopularRouteCategories extends StatelessWidget {
  final Function(String) onCategorySelect;

  const PopularRouteCategories({
    super.key,
    required this.onCategorySelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildCategoryChip(
            context,
            'Railway Stations',
            Icons.train,
            'railway',
          ),
          const SizedBox(width: 10),
          _buildCategoryChip(
            context,
            'Colleges',
            Icons.school,
            'college',
          ),
          const SizedBox(width: 10),
          _buildCategoryChip(
            context,
            'Corporate',
            Icons.business,
            'corporate',
          ),
          const SizedBox(width: 10),
          _buildCategoryChip(
            context,
            'Malls',
            Icons.shopping_bag,
            'mall',
          ),
          const SizedBox(width: 10),
          _buildCategoryChip(
            context,
            'Airport',
            Icons.flight,
            'airport',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String label,
    IconData icon,
    String category,
  ) {
    return InkWell(
      onTap: () => onCategorySelect(category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primaryOrange.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: AppTheme.primaryOrange,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
