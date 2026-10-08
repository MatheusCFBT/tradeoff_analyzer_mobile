import 'package:flutter/material.dart';

class ComparisonDecisionOption extends StatelessWidget {
  const ComparisonDecisionOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onTap,
    super.key,
  });
  final String title;
  final String description;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF004353) : const Color(0xFF52616A);
    return Semantics(
      button: true,
      selected: selected,
      label: '$title, $description',
      onTap: onTap,
      excludeSemantics: true,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: selected ? const Color(0xFF004353) : const Color(0xFFCFD9DE),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: selected
                      ? const Color(0xFF004353)
                      : const Color(0xFFE4EDF1),
                  child: Icon(
                    icon,
                    color: selected ? Colors.white : const Color(0xFF6B797F),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: Color(0xFF52616A),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  selected ? Icons.check_circle : Icons.circle,
                  color: selected
                      ? const Color(0xFF004353)
                      : const Color(0xFFEAF5FC),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
