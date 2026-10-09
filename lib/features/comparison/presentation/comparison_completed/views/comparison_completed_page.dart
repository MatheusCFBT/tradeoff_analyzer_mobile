import 'package:flutter/material.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_base_scaffold.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_card.dart';
import 'package:tradeoff_analyzer_mobile/routers/app_routes.dart';

import '../../../comparison_routes.dart';
import '../../../models/comparison_model.dart';
import '../../../models/completed_comparison_model.dart';

class ComparisonCompletedPage extends StatelessWidget {
  const ComparisonCompletedPage({required this.comparison, super.key});

  final CompletedComparisonModel comparison;

  @override
  Widget build(BuildContext context) {
    final isPros = comparison.selectedSide == SelectedSide.pros;
    return AppBaseScaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: Color(0xFFEAF5FC),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0xFF003541),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Decisão tomada com clareza!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF003541),
                  ),
                ),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Sua decisão sobre “'),
                      TextSpan(
                        text: comparison.draft.theme,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF003541),
                        ),
                      ),
                      const TextSpan(text: '” foi registrada nesta sessão.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    height: 1.4,
                    color: Color(0xFF245B6B),
                  ),
                ),
                const SizedBox(height: 20),
                AppCard(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFCFDCE2)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'VEREDITO FINAL',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Color(0xFF003541),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF004353),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPros ? Icons.thumb_up : Icons.thumb_down,
                              size: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                isPros
                                    ? 'Pender para prós'
                                    : 'Pender para contras',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF004353),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    side: const BorderSide(color: Color(0xFFCFDCE2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    ComparisonRoutes.theme,
                    (route) =>
                        route.settings.name == AppRoutes.home || route.isFirst,
                  ),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Nova Comparação'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
