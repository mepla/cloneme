import 'package:flutter/material.dart';
import '../../../services/mock/mock_coaches_service.dart';
import '../../../models/dashboard/coach_model.dart';
import '../../../widgets/dashboard/coach_card.dart';
import '../../../widgets/adaptive/responsive_container.dart';
import 'create_coach_dialog.dart';

class CoachesManagementScreen extends StatefulWidget {
  const CoachesManagementScreen({super.key});

  @override
  State<CoachesManagementScreen> createState() => _CoachesManagementScreenState();
}

class _CoachesManagementScreenState extends State<CoachesManagementScreen> {
  bool _isLoading = true;
  List<CoachModel> _coaches = [];
  List<CoachModel> _filteredCoaches = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCoaches();
    _searchController.addListener(_filterCoaches);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCoaches() async {
    try {
      final coaches = await MockCoachesService.getCoaches();
      setState(() {
        _coaches = coaches;
        _filteredCoaches = coaches;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterCoaches() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCoaches = _coaches;
      } else {
        _filteredCoaches = _coaches.where((coach) {
          return coach.name.toLowerCase().contains(query) ||
                 coach.description.toLowerCase().contains(query);
        }).toList();
      }
    });
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
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI Coaches',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Create and manage your AI coaches.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _showCreateCoachDialog,
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

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search coaches...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF6B7280),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                hintStyle: const TextStyle(
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Coaches Grid
          if (_filteredCoaches.isEmpty)
            _buildEmptyState()
          else
            DashboardContainer(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.8,
                ),
                itemCount: _filteredCoaches.length,
                itemBuilder: (context, index) {
                  final coach = _filteredCoaches[index];
                  return CoachCard(
                    coach: coach,
                    onEdit: () => _handleEditCoach(coach),
                    onSettings: () => _handleConfigureCoach(coach),
                    onDelete: () => _handleDeleteCoach(coach),
                    onTestChat: () => _handleTestChat(coach),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final hasSearchQuery = _searchController.text.isNotEmpty;
    
    return Container(
      padding: const EdgeInsets.all(48),
      child: Column(
        children: [
          Icon(
            hasSearchQuery ? Icons.search_off : Icons.psychology_outlined,
            size: 64,
            color: const Color(0xFF6B7280),
          ),
          const SizedBox(height: 16),
          Text(
            hasSearchQuery ? 'No coaches found' : 'No coaches yet',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasSearchQuery
                ? 'Try adjusting your search terms.'
                : 'Create your first AI coach to get started.',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          if (!hasSearchQuery) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showCreateCoachDialog,
              icon: const Icon(Icons.add),
              label: const Text('Create New Coach'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showCreateCoachDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateCoachDialog(
        onCreateCoach: _handleCreateCoach,
      ),
    );
  }

  Future<void> _handleCreateCoach(String name, String description) async {
    try {
      final newCoach = await MockCoachesService.createCoach(name, description);
      setState(() {
        _coaches.add(newCoach);
        _filterCoaches();
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Coach "${newCoach.name}" created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create coach: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleEditCoach(CoachModel coach) {
    // TODO: Implement edit coach functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit ${coach.name} - Coming soon!'),
      ),
    );
  }

  void _handleConfigureCoach(CoachModel coach) {
    // TODO: Navigate to coach settings
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Configure ${coach.name} - Coming soon!'),
      ),
    );
  }

  void _handleTestChat(CoachModel coach) {
    // TODO: Implement test chat functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Test chat with ${coach.name} - Coming soon!'),
      ),
    );
  }

  void _handleDeleteCoach(CoachModel coach) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Coach'),
        content: Text('Are you sure you want to delete "${coach.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await MockCoachesService.deleteCoach(coach.id);
                setState(() {
                  _coaches.removeWhere((c) => c.id == coach.id);
                  _filterCoaches();
                });
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Coach "${coach.name}" deleted successfully.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete coach: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}