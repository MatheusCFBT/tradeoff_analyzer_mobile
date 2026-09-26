import 'package:flutter/material.dart';

class EmptyStateContent extends StatelessWidget {
  const EmptyStateContent({
    this.icon,
    required this.title,
    required this.description,
    this.action,
    super.key,
  });

  final Widget? icon;
  final String title;
  final String description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 34,
            backgroundColor: const Color(0xFFEAF5FC),
          child: icon ??
              const Icon(Icons.balance, size: 32, color: Color(0xFF245B6B)),
        ),
        const SizedBox(height: 24),
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
        if (action != null) ...[
          const SizedBox(height: 24),
          action!,
        ],
      ],
    );
  }
}