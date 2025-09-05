class DashboardStat {
  final String title;
  final String value;
  final String change;
  final String iconName;
  final String trend; // 'up', 'down', 'stable'

  const DashboardStat({
    required this.title,
    required this.value,
    required this.change,
    required this.iconName,
    required this.trend,
  });
}

class ActivityItem {
  final String action;
  final String coach;
  final String time;

  const ActivityItem({
    required this.action,
    required this.coach,
    required this.time,
  });
}