import 'package:flutter/material.dart';

class UploadDropZone extends StatefulWidget {
  final Function(List<String> files) onFilesSelected;
  final String title;
  final String subtitle;
  final List<String> acceptedTypes;

  const UploadDropZone({
    super.key,
    required this.onFilesSelected,
    this.title = 'Drop files here',
    this.subtitle = 'or click to browse',
    this.acceptedTypes = const ['PDF', 'EPUB', 'Markdown'],
  });

  @override
  State<UploadDropZone> createState() => _UploadDropZoneState();
}

class _UploadDropZoneState extends State<UploadDropZone> {
  bool _isDragOver = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectFiles,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: _isDragOver 
            ? const Color(0xFF3B82F6).withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.5),
          border: Border.all(
            color: _isDragOver 
              ? const Color(0xFF3B82F6)
              : Colors.grey.withValues(alpha: 0.3),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (_isDragOver)
              BoxShadow(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 48,
              color: _isDragOver 
                ? const Color(0xFF3B82F6)
                : const Color(0xFF6B7280),
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _isDragOver 
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: widget.acceptedTypes.map((type) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _selectFiles() {
    // Mock file selection - in a real app you'd use file_picker
    final mockFiles = [
      'Marketing Guide.pdf',
      'Sales Process.epub',
      'Content Strategy.md',
    ];
    
    // Simulate file selection delay
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onFilesSelected(mockFiles.take(1).toList());
    });
    
    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File uploaded successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}