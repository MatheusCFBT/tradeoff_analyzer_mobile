import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({
    this.title,
    this.leading,
    this.actions,
    this.avatarUrl,
    this.avatarImageProvider,
    this.onAvatarTap,
    this.height = 56.0,
    this.centerTitle = true,
    super.key,
  });

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final String? avatarUrl;
  final ImageProvider? avatarImageProvider;
  final VoidCallback? onAvatarTap;
  final double height;
  final bool centerTitle;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final imageProvider = avatarImageProvider ??
        (avatarUrl != null ? NetworkImage(avatarUrl!) : null);

    final avatar = GestureDetector(
      key: const Key('app_header_avatar_gesture'),
      onTap: onAvatarTap,
      child: CircleAvatar(
        key: const Key('app_header_avatar'),
        radius: (height - 16) / 2,
        backgroundColor: imageProvider == null ? Colors.grey : null,
        backgroundImage: imageProvider,
        child: imageProvider == null
            ? const Icon(
                Icons.person,
                color: Colors.white,
              )
            : null,
      ),
    );

    final titleWidget = Text(
      title ?? 'Pondera',
      style: const TextStyle(
        fontFamily: 'Inter',
        color: Color(0xFF245B6B),
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.2
      ),
      textAlign: centerTitle ? TextAlign.center : TextAlign.left,
    );

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) Padding(padding: const EdgeInsets.only(left: 8.0), child: leading!),
          Expanded(
            child: Center(child: titleWidget),
          ),
          if (actions != null) ...actions!,
          Padding(padding: const EdgeInsets.only(right: 8.0), child: avatar),
        ],
      ),
    );
  }
}
