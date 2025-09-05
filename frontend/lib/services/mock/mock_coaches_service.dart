import '../../models/dashboard/coach_model.dart';

class MockCoachesService {
  static const List<CoachModel> _mockCoaches = [
    CoachModel(
      id: '1',
      name: 'Marketing Expert',
      description: 'Helps with marketing strategies, content creation, and campaign optimization.',
      status: 'active',
      conversations: 156,
      knowledgeArticles: 23,
      lastActive: '2 hours ago',
      avatarUrl: 'https://images.unsplash.com/photo-1557804506-669a67965ba0?w=40&h=40&fit=crop&crop=face',
    ),
    CoachModel(
      id: '2',
      name: 'Sales Assistant',
      description: 'Assists with sales processes, lead qualification, and customer interactions.',
      status: 'active',
      conversations: 89,
      knowledgeArticles: 18,
      lastActive: '30 minutes ago',
      avatarUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=40&h=40&fit=crop&crop=face',
    ),
    CoachModel(
      id: '3',
      name: 'Customer Support Bot',
      description: 'Provides 24/7 customer support and handles common inquiries.',
      status: 'active',
      conversations: 234,
      knowledgeArticles: 45,
      lastActive: '5 minutes ago',
      avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=40&h=40&fit=crop&crop=face',
    ),
    CoachModel(
      id: '4',
      name: 'Product Guide',
      description: 'Helps users navigate and understand product features.',
      status: 'paused',
      conversations: 67,
      knowledgeArticles: 32,
      lastActive: '1 day ago',
      avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=40&h=40&fit=crop&crop=face',
    ),
  ];

  static List<CoachModel> _coaches = List.from(_mockCoaches);

  static Future<List<CoachModel>> getCoaches() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _coaches;
  }

  static Future<CoachModel> createCoach(String name, String description) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final newCoach = CoachModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      status: 'active',
      conversations: 0,
      knowledgeArticles: 0,
      lastActive: 'Just created',
      avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=40&h=40&fit=crop&crop=face',
    );
    _coaches.add(newCoach);
    return newCoach;
  }

  static Future<void> updateCoachStatus(String coachId, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _coaches.indexWhere((coach) => coach.id == coachId);
    if (index != -1) {
      _coaches[index] = _coaches[index].copyWith(status: status);
    }
  }

  static Future<void> deleteCoach(String coachId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _coaches.removeWhere((coach) => coach.id == coachId);
  }
}