import 'package:flutter/material.dart';

class LogoAvatar extends StatelessWidget {
  final String? imageUrl; // رابط الصورة أو مسار الأصول
  final double radius;
  final Icon icon; // الأيقونة إذا أردت عرضها
  final Color backgroundColor;
  final bool isIcon;

  const LogoAvatar({
    Key? key,
    required this.isIcon,
    this.imageUrl,
    this.icon = const Icon(Icons.app_blocking, color: Colors.white),
    this.radius = 26,
    this.backgroundColor = Colors.deepPurple,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      backgroundImage: (!isIcon && imageUrl != null && imageUrl!.isNotEmpty)
          ? NetworkImage(imageUrl!)
          : null,
      child: isIcon || imageUrl == null || imageUrl!.isEmpty ? icon : null,
    );
  }
}
