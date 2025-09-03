import 'package:flutter/material.dart';
import '../../core/theme/dashboard_colors.dart';

class TrendIndicator extends StatelessWidget {
  const TrendIndicator({
    required this.value,
    required this.isPositive,
    this.showIcon = true,
    super.key,
  });
  
  final String value;
  final bool isPositive;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? DashboardColors.successGreen : DashboardColors.errorRed;
    final icon = isPositive ? Icons.trending_up : Icons.trending_down;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}