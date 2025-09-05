import 'package:flutter/material.dart';

enum DashboardSection {
  overview,
  coaches,
  knowledgeBase,
  settings,
}

class DashboardSidebar extends StatelessWidget {
  final DashboardSection activeSection;
  final Function(DashboardSection) onSectionChanged;

  const DashboardSidebar({
    super.key,
    required this.activeSection,
    required this.onSectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.8),
          ],
        ),
        border: Border(
          right: BorderSide(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF3B82F6),
                        Color(0xFF8B5CF6),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF1F2937),
                        Color(0xFF6B7280),
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      'AI Coach Studio',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildNavItem(
                    section: DashboardSection.overview,
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    title: 'Overview',
                  ),
                  const SizedBox(height: 8),
                  _buildNavItem(
                    section: DashboardSection.coaches,
                    icon: Icons.psychology_outlined,
                    activeIcon: Icons.psychology,
                    title: 'Coaches',
                  ),
                  const SizedBox(height: 8),
                  _buildNavItem(
                    section: DashboardSection.knowledgeBase,
                    icon: Icons.menu_book_outlined,
                    activeIcon: Icons.menu_book,
                    title: 'Knowledge Base',
                  ),
                  const SizedBox(height: 8),
                  _buildNavItem(
                    section: DashboardSection.settings,
                    icon: Icons.settings_outlined,
                    activeIcon: Icons.settings,
                    title: 'Settings',
                  ),
                ],
              ),
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: const Text(
              '© 2025 AI Coach Studio',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required DashboardSection section,
    required IconData icon,
    required IconData activeIcon,
    required String title,
  }) {
    final isActive = activeSection == section;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSectionChanged(section),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isActive 
              ? Colors.blue.withOpacity(0.1)
              : Colors.transparent,
            border: Border.all(
              color: isActive 
                ? Colors.blue.withOpacity(0.3)
                : Colors.transparent,
              width: 1,
            ),
            boxShadow: isActive ? [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isActive 
                    ? Colors.blue
                    : const Color(0xFFF3F4F6),
                ),
                child: Icon(
                  isActive ? activeIcon : icon,
                  color: isActive 
                    ? Colors.white
                    : const Color(0xFF6B7280),
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isActive 
                    ? const Color(0xFF1F2937)
                    : const Color(0xFF6B7280),
                ),
              ),
              const Spacer(),
              if (isActive)
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF3B82F6),
                        Color(0xFF8B5CF6),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}