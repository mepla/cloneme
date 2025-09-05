import 'package:flutter/material.dart';
import '../../widgets/dashboard/dashboard_sidebar.dart';
import 'overview/dashboard_overview_screen.dart';
import 'coaches/coaches_management_screen.dart';
import 'knowledge/knowledge_base_screen.dart';
import 'settings/coach_settings_screen.dart';

class DashboardMainScreen extends StatefulWidget {
  const DashboardMainScreen({super.key});

  @override
  State<DashboardMainScreen> createState() => _DashboardMainScreenState();
}

class _DashboardMainScreenState extends State<DashboardMainScreen> {
  DashboardSection _activeSection = DashboardSection.overview;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8FAFC),
              Color(0xFFF1F5F9),
              Color(0xFFE2E8F0),
            ],
          ),
        ),
        child: Row(
          children: [
            // Sidebar
            DashboardSidebar(
              activeSection: _activeSection,
              onSectionChanged: (section) {
                setState(() {
                  _activeSection = section;
                });
              },
            ),

            // Main Content
            Expanded(
              child: Column(
                children: [
                  // Header
                  _buildHeader(),
                  
                  // Content
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.white.withOpacity(0.2),
                          ],
                        ),
                      ),
                      child: _buildContent(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    String title;
    String subtitle;

    switch (_activeSection) {
      case DashboardSection.overview:
        title = 'Dashboard';
        subtitle = 'Overview of your AI coaching platform';
        break;
      case DashboardSection.coaches:
        title = 'Coaches';
        subtitle = 'Create and manage your AI coaches';
        break;
      case DashboardSection.knowledgeBase:
        title = 'Knowledge Base';
        subtitle = 'Manage your content and data sources';
        break;
      case DashboardSection.settings:
        title = 'Settings';
        subtitle = 'Configure your AI coaches';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_activeSection) {
      case DashboardSection.overview:
        return const DashboardOverviewScreen();
      case DashboardSection.coaches:
        return const CoachesManagementScreen();
      case DashboardSection.knowledgeBase:
        return const KnowledgeBaseScreen();
      case DashboardSection.settings:
        return const CoachSettingsScreen();
    }
  }
}