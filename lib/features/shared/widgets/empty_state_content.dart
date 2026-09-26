import 'package:flutter/material.dart';

class EmptyStateContent extends StatelessWidget {
  const EmptyStateContent({
    this.circleAvatar,
    required this.title,
    required this.description,
    this.action,
    super.key,
  });

  final Widget? circleAvatar;
  final String title;
  final String description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (circleAvatar != null) ...[
          circleAvatar!,
          const SizedBox(height: 24),
        ],
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            color: Color(0xFF172126),
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: Color(0xFF455A64),
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        if (action != null) ...[const SizedBox(height: 24), action!],
      ],
    );
  }
}
