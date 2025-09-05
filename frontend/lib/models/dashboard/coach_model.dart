class CoachModel {
  final String id;
  final String name;
  final String description;
  final String status; // 'active' or 'paused'
  final int conversations;
  final int knowledgeArticles;
  final String lastActive;
  final String avatarUrl;
  
  const CoachModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.conversations,
    required this.knowledgeArticles,
    required this.lastActive,
    required this.avatarUrl,
  });

  bool get isActive => status == 'active';
  
  CoachModel copyWith({
    String? id,
    String? name,
    String? description,
    String? status,
    int? conversations,
    int? knowledgeArticles,
    String? lastActive,
    String? avatarUrl,
  }) {
    return CoachModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      knowledgeArticles: knowledgeArticles ?? this.knowledgeArticles,
      lastActive: lastActive ?? this.lastActive,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}