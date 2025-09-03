import 'package:flutter/material.dart';
import '../../core/adaptive/breakpoints.dart';
import '../adaptive/responsive_text.dart';
import 'trend_indicator.dart';

class PolishedMetricsCard extends StatelessWidget {
  const PolishedMetricsCard({
    required this.title,
    required this.value,
    required this.icon,
    this.trend,
    this.isPositiveTrend,
    this.iconColor,
    this.subtitle,
    super.key,
  });
  
  final String title;
  final String value;
  final IconData icon;
  final String? trend;
  final bool? isPositiveTrend;
  final Color? iconColor;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final breakpoint = ScreenInfo.getBreakpoint(context);
    final padding = ScreenInfo.getContentPadding(breakpoint);
    
    return Card(
      child: Container(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header row with icon and trend
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (iconColor ?? Theme.of(context).primaryColor).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? Theme.of(context).primaryColor,
                    size: 20,
                  ),
                ),
                const Spacer(),
                if (trend != null && isPositiveTrend != null)
                  TrendIndicator(
                    value: trend!,
                    isPositive: isPositiveTrend!,
                  ),
              ],
            ),
            
            SizedBox(height: ScreenInfo.getLayoutGap(breakpoint) * 0.75),
            
            // Main value
            ResponsiveText(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Title and optional subtitle
            ResponsiveText(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              ResponsiveText(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}