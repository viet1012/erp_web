import 'package:flutter/material.dart';

class UserInfoRow extends StatelessWidget {
  final String? fullName;
  final String? avatarUrl;
  final double avatarRadius;
  final TextStyle? nameStyle;
  final double spacing;

  const UserInfoRow({
    super.key,
    this.fullName,
    this.avatarUrl,
    this.avatarRadius = 20,
    this.nameStyle,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // === AVATAR ===
        UserAvatar(
          fullName: fullName,
          avatarUrl: avatarUrl,
          radius: avatarRadius,
        ),
        SizedBox(width: spacing),

        // === TÊN NGƯỜI DÙNG ===
        Text(
          fullName?.trim().isNotEmpty == true ? fullName! : 'Người dùng',
          style:
              nameStyle ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}

// === AVATAR RIÊNG (giữ nguyên logic cũ) ===
class UserAvatar extends StatelessWidget {
  final String? fullName;
  final String? avatarUrl;
  final double radius;

  const UserAvatar({
    super.key,
    this.fullName,
    this.avatarUrl,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(avatarUrl!),
        backgroundColor: Colors.grey[200],
        onBackgroundImageError: (_, __) {},
      );
    }

    final String displayText = _getInitials(fullName);
    if (displayText.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: _getColorFromName(fullName ?? ''),
        child: Text(
          displayText,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: radius * 0.9,
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.blue[100],
      child: Icon(Icons.person, color: Colors.blue[700], size: radius * 1.2),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return '';
    final words = name.trim().split(RegExp(r'\s+'));
    String initials = '';
    for (var word in words) {
      if (word.isNotEmpty) {
        initials += word[0].toUpperCase();
        if (initials.length >= 2) break;
      }
    }
    return initials.isEmpty ? '' : initials;
  }

  Color _getColorFromName(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    final hash = name.runes.reduce((a, b) => a + b);
    return colors[hash % colors.length]!;
  }
}
