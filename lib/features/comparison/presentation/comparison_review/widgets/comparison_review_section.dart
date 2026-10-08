import 'package:flutter/material.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_card.dart';

class ComparisonReviewSection extends StatelessWidget {
  const ComparisonReviewSection({
    required this.title,
    required this.items,
    required this.onEdit,
    this.icon,
    this.color = const Color(0xFF004353),
    this.emptyMessage,
    super.key,
  });
  final String title;
  final List<String> items;
  final VoidCallback onEdit;
  final IconData? icon;
  final Color color;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) => AppCard(
    margin: EdgeInsets.zero,
    padding: const EdgeInsets.all(16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: Color(0xFFCFD9DE)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF003541),
                ),
              ),
            ),
            Semantics(
              label: 'Editar $title',
              onTap: onEdit,
              button: true,
              excludeSemantics: true,
              child: TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Editar'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF003541),
                ),
              ),
            ),
          ],
        ),
        if (items.isEmpty)
          Text(emptyMessage!, style: const TextStyle(color: Color(0xFF245B6B))),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5FC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFDFEAF0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon == Icons.add_circle_outline
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                      color: color,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: Color(0xFF172126),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}
