import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.name,
    this.imageUrl,
    this.size = 40.0,
    super.key,
  });
  
  final String name;
  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: _getAvatarColor(name),
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Text(
              _getInitials(name),
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.4,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
    );
  }
  
  Color _getAvatarColor(String name) {
    const colors = [
      Color(0xFF2697FF), Color(0xFF4CAF50), Color(0xFFFF9800),
      Color(0xFFE91E63), Color(0xFF9C27B0), Color(0xFF673AB7),
      Color(0xFF3F51B5), Color(0xFF009688), Color(0xFF795548),
    ];
    
    final hash = name.hashCode;
    return colors[hash.abs() % colors.length];
  }
  
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}