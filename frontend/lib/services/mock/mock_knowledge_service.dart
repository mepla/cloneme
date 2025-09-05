import '../../models/dashboard/knowledge_article_model.dart';

class MockKnowledgeService {
  static final List<KnowledgeArticleModel> _mockArticles = [
    KnowledgeArticleModel(
      id: '1',
      title: 'Marketing Fundamentals Course',
      source: 'youtube',
      type: 'video',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      status: 'ready',
      url: 'https://youtube.com/watch?v=example1',
    ),
    KnowledgeArticleModel(
      id: '2',
      title: 'Instagram Growth Strategy',
      source: 'instagram',
      type: 'image',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      status: 'processing',
    ),
    KnowledgeArticleModel(
      id: '3',
      title: 'Sales Process Guide.pdf',
      source: 'file',
      type: 'pdf',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: 'ready',
      size: 1024000, // 1MB
    ),
    KnowledgeArticleModel(
      id: '4',
      title: 'Content Creation Workflow',
      source: 'file',
      type: 'markdown',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      status: 'ready',
      size: 45000, // 45KB
    ),
    KnowledgeArticleModel(
      id: '5',
      title: 'Brand Guidelines Manual',
      source: 'file',
      type: 'pdf',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      status: 'error',
      size: 2500000, // 2.5MB
    ),
  ];

  static List<KnowledgeArticleModel> _articles = List.from(_mockArticles);

  static Future<List<KnowledgeArticleModel>> getArticles() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _articles;
  }

  static Future<List<KnowledgeArticleModel>> getArticlesBySource(String source) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _articles.where((article) => article.source == source).toList();
  }

  static Future<KnowledgeArticleModel> uploadFile(String fileName, int size) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    String type = 'file';
    if (fileName.toLowerCase().endsWith('.pdf')) type = 'pdf';
    else if (fileName.toLowerCase().endsWith('.epub')) type = 'epub';
    else if (fileName.toLowerCase().endsWith('.md')) type = 'markdown';
    
    final newArticle = KnowledgeArticleModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: fileName,
      source: 'file',
      type: type,
      createdAt: DateTime.now(),
      status: 'processing',
      size: size,
    );
    
    _articles.insert(0, newArticle);
    
    // Simulate processing completion after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      final index = _articles.indexWhere((a) => a.id == newArticle.id);
      if (index != -1) {
        _articles[index] = newArticle.copyWith(status: 'ready');
      }
    });
    
    return newArticle;
  }

  static Future<KnowledgeArticleModel> addYouTubeChannel(String channelUrl) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    
    final newArticle = KnowledgeArticleModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'YouTube Channel Import',
      source: 'youtube',
      type: 'video',
      createdAt: DateTime.now(),
      status: 'processing',
      url: channelUrl,
    );
    
    _articles.insert(0, newArticle);
    
    // Simulate processing completion
    Future.delayed(const Duration(seconds: 5), () {
      final index = _articles.indexWhere((a) => a.id == newArticle.id);
      if (index != -1) {
        _articles[index] = newArticle.copyWith(
          status: 'ready',
          title: 'YouTube Channel - 15 videos processed',
        );
      }
    });
    
    return newArticle;
  }

  static Future<KnowledgeArticleModel> addInstagramPage(String pageUrl) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    final newArticle = KnowledgeArticleModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Instagram Page Import',
      source: 'instagram',
      type: 'image',
      createdAt: DateTime.now(),
      status: 'processing',
      url: pageUrl,
    );
    
    _articles.insert(0, newArticle);
    
    // Simulate processing completion
    Future.delayed(const Duration(seconds: 4), () {
      final index = _articles.indexWhere((a) => a.id == newArticle.id);
      if (index != -1) {
        _articles[index] = newArticle.copyWith(
          status: 'ready',
          title: 'Instagram Page - 28 posts processed',
        );
      }
    });
    
    return newArticle;
  }

  static Future<void> deleteArticle(String articleId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _articles.removeWhere((article) => article.id == articleId);
  }
}