import 'package:flutter/material.dart';

import '../../core/responsive/responsive.dart';
import '../../widgets/dashboard/dashboard_sidebar.dart';
import 'coaches/coaches_management_screen.dart';
import 'knowledge/knowledge_base_screen.dart';
import 'overview/dashboard_overview_screen.dart';
import 'settings/coach_settings_screen.dart';

class DashboardMainScreen extends StatefulWidget {
  final DashboardSection? initialSection;

  const DashboardMainScreen({super.key, this.initialSection});

  @override
  State<DashboardMainScreen> createState() => _DashboardMainScreenState();
}

class _DashboardMainScreenState extends State<DashboardMainScreen> {
  late DashboardSection _activeSection;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _activeSection = widget.initialSection ?? DashboardSection.overview;
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile
          ? Drawer(
              child: Container(
                color: Colors.white,
                child: SafeArea(
                  child: DashboardSidebar(
                    activeSection: _activeSection,
                    onSectionChanged: (section) {
                      setState(() {
                        _activeSection = section;
                      });
                      Navigator.of(context).pop(); // Close drawer on selection
                    },
                    isMobile: true,
                  ),
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
            ),
          ),
          child: Row(
            children: [
              // Sidebar - Only show on desktop
              if (isDesktop)
                DashboardSidebar(
                  activeSection: _activeSection,
                  onSectionChanged: (section) {
                    setState(() {
                      _activeSection = section;
                    });
                  },
                  isMobile: false,
                ),

              // Main Content
              Expanded(
                child: Column(
                  children: [
                    // Header
                    _buildHeader(isMobile),

                    // Content
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.white.withOpacity(0.2)],
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
      ),
    );
  }

  Widget _buildHeader(bool showMenuButton) {
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

    final isMobile = Responsive.isMobile(context);
    final double horizontalPadding = isMobile ? 16 : 24;
    final double titleSize = isMobile ? 24 : 32;
    final double subtitleSize = isMobile ? 12 : 14;

    return Container(
      padding: EdgeInsets.all(horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3), width: 1)),
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
          // Hamburger menu button for mobile
          if (showMenuButton)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                icon: const Icon(Icons.menu, color: Color(0xFF1F2937)),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: subtitleSize, color: const Color(0xFF6B7280)),
                  overflow: TextOverflow.ellipsis,
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
