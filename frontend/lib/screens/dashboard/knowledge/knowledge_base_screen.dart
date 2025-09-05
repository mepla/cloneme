import 'package:flutter/material.dart';
import '../../../services/mock/mock_knowledge_service.dart';
import '../../../models/dashboard/knowledge_article_model.dart';
import '../../../widgets/dashboard/upload_drop_zone.dart';
import '../../../widgets/adaptive/responsive_container.dart';
import '../../../core/responsive/responsive.dart';

class KnowledgeBaseScreen extends StatefulWidget {
  const KnowledgeBaseScreen({super.key});

  @override
  State<KnowledgeBaseScreen> createState() => _KnowledgeBaseScreenState();
}

class _KnowledgeBaseScreenState extends State<KnowledgeBaseScreen> {
  bool _isLoading = true;
  List<KnowledgeArticleModel> _articles = [];
  String _selectedFilter = 'all';
  final TextEditingController _youtubeController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  Future<void> _loadArticles() async {
    try {
      final articles = await MockKnowledgeService.getArticles();
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<KnowledgeArticleModel> get _filteredArticles {
    if (_selectedFilter == 'all') return _articles;
    return _articles.where((article) => article.source == _selectedFilter).toList();
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
          // Upload Section
          _buildUploadSection(),
          
          const SizedBox(height: 32),

          // Social Media Integration
          _buildSocialMediaSection(),
          
          const SizedBox(height: 32),

          // Knowledge Articles Section
          _buildArticlesSection(),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.cloud_upload_outlined,
                  color: Color(0xFF8B5CF6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Upload Files',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Upload PDF, EPUB, or Markdown files to build your knowledge base.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),
          UploadDropZone(
            onFilesSelected: _handleFileUpload,
            title: 'Drop files here',
            subtitle: 'or click to browse',
            acceptedTypes: const ['PDF', 'EPUB', 'Markdown'],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaSection() {
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.share_outlined,
                  color: Color(0xFFF59E0B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Social Media Integration',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Connect your YouTube channel or Instagram page to automatically import content.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          
          // YouTube Integration
          _buildSocialMediaInput(
            controller: _youtubeController,
            label: 'YouTube Channel URL',
            hint: 'https://youtube.com/@yourchannel',
            icon: Icons.play_circle_outline,
            iconColor: Colors.red,
            buttonColor: Colors.red,
            onImport: _handleYouTubeImport,
          ),
          
          const SizedBox(height: 16),
          
          // Instagram Integration
          _buildSocialMediaInput(
            controller: _instagramController,
            label: 'Instagram Page URL',
            hint: 'https://instagram.com/yourpage',
            icon: Icons.photo_camera_outlined,
            iconColor: Colors.purple,
            buttonColor: Colors.purple,
            onImport: _handleInstagramImport,
          ),
        ],
      ),
    );
  }

  Widget _buildArticlesSection() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Knowledge Articles',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              // Filter Dropdown
              DropdownButton<String>(
                value: _selectedFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = value!;
                  });
                },
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All Sources')),
                  DropdownMenuItem(value: 'file', child: Text('Files')),
                  DropdownMenuItem(value: 'youtube', child: Text('YouTube')),
                  DropdownMenuItem(value: 'instagram', child: Text('Instagram')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (_filteredArticles.isEmpty)
            _buildEmptyArticles()
          else
            _buildArticlesList(),
        ],
      ),
    );
  }

  Widget _buildEmptyArticles() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: const Column(
        children: [
          Icon(
            Icons.article_outlined,
            size: 48,
            color: Color(0xFF6B7280),
          ),
          SizedBox(height: 16),
          Text(
            'No articles yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Upload files or connect social media to start building your knowledge base.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildArticlesList() {
    return Column(
      children: _filteredArticles.map((article) => _buildArticleItem(article)).toList(),
    );
  }

  Widget _buildArticleItem(KnowledgeArticleModel article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Source Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getSourceColor(article.source).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getSourceIcon(article.source),
              color: _getSourceColor(article.source),
              size: 20,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Article Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    Text(
                      article.source.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getSourceColor(article.source),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '•',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    Text(
                      _formatDate(article.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    if (article.size != null) ...[
                      Text(
                        '•',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text(
                        article.formattedSize,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(article.status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getStatusColor(article.status).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getStatusIcon(article.status),
                  size: 12,
                  color: _getStatusColor(article.status),
                ),
                const SizedBox(width: 4),
                Text(
                  article.status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _getStatusColor(article.status),
                  ),
                ),
              ],
            ),
          ),
          
          // Delete Button
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _handleDeleteArticle(article),
            icon: const Icon(Icons.delete_outline, size: 18),
            color: Colors.red[400],
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  IconData _getSourceIcon(String source) {
    switch (source) {
      case 'youtube':
        return Icons.play_circle_outline;
      case 'instagram':
        return Icons.photo_camera_outlined;
      case 'file':
        return Icons.description_outlined;
      default:
        return Icons.article_outlined;
    }
  }

  Color _getSourceColor(String source) {
    switch (source) {
      case 'youtube':
        return Colors.red;
      case 'instagram':
        return Colors.purple;
      case 'file':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'ready':
        return Icons.check_circle;
      case 'processing':
        return Icons.hourglass_empty;
      case 'error':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ready':
        return Colors.green;
      case 'processing':
        return Colors.orange;
      case 'error':
        return Colors.red;
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  Future<void> _handleFileUpload(List<String> files) async {
    for (final file in files) {
      try {
        final article = await MockKnowledgeService.uploadFile(file, 1000000);
        setState(() {
          _articles.insert(0, article);
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to upload $file: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleYouTubeImport() async {
    final url = _youtubeController.text.trim();
    if (url.isEmpty) return;

    try {
      final article = await MockKnowledgeService.addYouTubeChannel(url);
      setState(() {
        _articles.insert(0, article);
      });
      _youtubeController.clear();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('YouTube channel import started!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to import YouTube channel: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleInstagramImport() async {
    final url = _instagramController.text.trim();
    if (url.isEmpty) return;

    try {
      final article = await MockKnowledgeService.addInstagramPage(url);
      setState(() {
        _articles.insert(0, article);
      });
      _instagramController.clear();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Instagram page import started!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to import Instagram page: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildSocialMediaInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color iconColor,
    required Color buttonColor,
    required VoidCallback onImport,
  }) {
    final isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: Icon(icon, color: iconColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onImport,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Import'),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: Icon(icon, color: iconColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: onImport,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Import'),
        ),
      ],
    );
  }

  void _handleDeleteArticle(KnowledgeArticleModel article) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Article'),
        content: Text('Are you sure you want to delete "${article.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await MockKnowledgeService.deleteArticle(article.id);
                setState(() {
                  _articles.removeWhere((a) => a.id == article.id);
                });
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Article deleted successfully.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete article: $e'),
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