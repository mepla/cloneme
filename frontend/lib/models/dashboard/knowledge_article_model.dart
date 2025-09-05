class KnowledgeArticleModel {
  final String id;
  final String title;
  final String source; // 'youtube', 'instagram', 'file'
  final String type; // 'video', 'image', 'pdf', 'epub', 'markdown'
  final DateTime createdAt;
  final String status; // 'processing', 'ready', 'error'
  final String? url;
  final int? size; // for files
  
  const KnowledgeArticleModel({
    required this.id,
    required this.title,
    required this.source,
    required this.type,
    required this.createdAt,
    required this.status,
    this.url,
    this.size,
  });

  bool get isProcessing => status == 'processing';
  bool get isReady => status == 'ready';
  bool get hasError => status == 'error';

  String get formattedSize {
    if (size == null) return '';
    if (size! < 1024) return '${size}B';
    if (size! < 1024 * 1024) return '${(size! / 1024).toStringAsFixed(1)}KB';
    return '${(size! / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  KnowledgeArticleModel copyWith({
    String? id,
    String? title,
    String? source,
    String? type,
    DateTime? createdAt,
    String? status,
    String? url,
    int? size,
  }) {
    return KnowledgeArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      source: source ?? this.source,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      url: url ?? this.url,
      size: size ?? this.size,
    );
  }
}