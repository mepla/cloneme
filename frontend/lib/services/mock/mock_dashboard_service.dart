import '../../models/dashboard/dashboard_stats_model.dart';

class MockDashboardService {
  static const List<DashboardStat> _mockStats = [
    DashboardStat(
      title: 'Total Subscribers',
      value: '456',
      change: '+23 this week',
      iconName: 'users',
      trend: 'up',
    ),
    DashboardStat(
      title: 'Total Revenue',
      value: '\$12,450',
      change: '\$1,200 this month',
      iconName: 'dollar-sign',
      trend: 'up',
    ),
    DashboardStat(
      title: 'Knowledge Articles',
      value: '127',
      change: '+15 this week',
      iconName: 'book-open',
      trend: 'up',
    ),
    DashboardStat(
      title: 'Conversations',
      value: '1,234',
      change: '+89 today',
      iconName: 'message-square',
      trend: 'up',
    ),
  ];

  static const List<ActivityItem> _mockRecentActivity = [
    ActivityItem(
      action: 'Created new coach',
      coach: 'Marketing Expert',
      time: '2 hours ago',
    ),
    ActivityItem(
      action: 'Updated knowledge base',
      coach: 'Sales Assistant',
      time: '4 hours ago',
    ),
    ActivityItem(
      action: 'New conversation started',
      coach: 'Customer Support Bot',
      time: '6 hours ago',
    ),
    ActivityItem(
      action: 'Knowledge article added',
      coach: 'Product Guide',
      time: '1 day ago',
    ),
  ];

  static Future<List<DashboardStat>> getStats() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockStats;
  }

  static Future<List<ActivityItem>> getRecentActivity() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockRecentActivity;
  }
}