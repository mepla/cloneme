import 'package:flutter/material.dart';
import '../../../services/mock/mock_dashboard_service.dart';
import '../../../models/dashboard/dashboard_stats_model.dart';
import '../../../widgets/dashboard/stats_card.dart';
import '../../../widgets/dashboard/activity_feed.dart';
import '../../../widgets/adaptive/responsive_container.dart';

class DashboardOverviewScreen extends StatefulWidget {
  const DashboardOverviewScreen({super.key});

  @override
  State<DashboardOverviewScreen> createState() => _DashboardOverviewScreenState();
}

class _DashboardOverviewScreenState extends State<DashboardOverviewScreen> {
  bool _isLoading = true;
  List<DashboardStat> _stats = [];
  List<ActivityItem> _activities = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final stats = await MockDashboardService.getStats();
      final activities = await MockDashboardService.getRecentActivity();
      
      setState(() {
        _stats = stats;
        _activities = activities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF1F2937),
                        Color(0xFF6B7280),
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      'Welcome back!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Here\'s what\'s happening with your AI coaches today.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to create coach
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Create New Coach'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: Colors.blue.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),

          // Stats Grid
          DashboardContainer(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.2,
              ),
              itemCount: _stats.length,
              itemBuilder: (context, index) {
                final stat = _stats[index];
                return StatsCard(
                  title: stat.title,
                  value: stat.value,
                  change: stat.change,
                  icon: _getIconFromName(stat.iconName),
                  iconColor: _getIconColor(stat.iconName),
                );
              },
            ),
          ),

          const SizedBox(height: 32),

          // Activity and Quick Actions Row
          DashboardContainer(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recent Activity (2/3 width)
                Expanded(
                  flex: 2,
                  child: ActivityFeed(activities: _activities),
                ),
                
                const SizedBox(width: 24),
                
                // Quick Actions (1/3 width)
                Expanded(
                  flex: 1,
                  child: _buildQuickActions(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Performance Chart Placeholder
          Container(
            height: 300,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF1F2937),
                      Color(0xFF6B7280),
                    ],
                  ).createShader(bounds),
                  child: const Text(
                    'Performance Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.4),
                          Colors.grey[50]!.withValues(alpha: 0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.trending_up,
                            size: 48,
                            color: Color(0xFF3B82F6),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Performance chart will appear here',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFF1F2937),
                Color(0xFF6B7280),
              ],
            ).createShader(bounds),
            child: const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildQuickActionButton(
            icon: Icons.psychology_outlined,
            title: 'Create New Coach',
            onTap: () {
              // TODO: Navigate to create coach
            },
          ),
          const SizedBox(height: 12),
          _buildQuickActionButton(
            icon: Icons.menu_book_outlined,
            title: 'Add Knowledge Article',
            onTap: () {
              // TODO: Navigate to knowledge base
            },
          ),
          const SizedBox(height: 12),
          _buildQuickActionButton(
            icon: Icons.chat_outlined,
            title: 'View Conversations',
            onTap: () {
              // TODO: Navigate to conversations
            },
          ),
          const SizedBox(height: 12),
          _buildQuickActionButton(
            icon: Icons.analytics_outlined,
            title: 'View Analytics',
            onTap: () {
              // TODO: Navigate to analytics
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'users':
        return Icons.people_outline;
      case 'dollar-sign':
        return Icons.attach_money;
      case 'book-open':
        return Icons.menu_book_outlined;
      case 'message-square':
        return Icons.chat_outlined;
      default:
        return Icons.analytics_outlined;
    }
  }

  Color _getIconColor(String iconName) {
    switch (iconName) {
      case 'users':
        return const Color(0xFF3B82F6);
      case 'dollar-sign':
        return const Color(0xFF10B981);
      case 'book-open':
        return const Color(0xFF8B5CF6);
      case 'message-square':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF3B82F6);
    }
  }
}