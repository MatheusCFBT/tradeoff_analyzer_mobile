import 'package:flutter/material.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/viewmodels/comparison_start_viewmodel.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/comparison_routes.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_base_scaffold.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_primary_button.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/empty_state_content.dart';

class ComparisonStartPage extends StatefulWidget {
  const ComparisonStartPage({required this.viewModel, super.key});

  final ComparisonStartViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _ComparisonStartPageState();
}

class _ComparisonStartPageState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBaseScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: EmptyStateContent(
                circleAvatar: const CircleAvatar(
                  radius: 80,
                  backgroundColor: Color(0xFFEAF5FC),
                  child: Icon(
                    Icons.balance,
                    size: 75,
                    color: Color(0xFF245B6B),
                  ),
                ),
                title: 'Comece sua primeira decisão',
                description:
                    'Iniciar uma comparação ajudará você a organizar prós e contras, reduzindo o esforço mental e trazendo clareza objetiva.',
                action: AppPrimaryButton(
                  icon: const Icon(Icons.add, size: 18, color: Colors.white),
                  label: 'Nova comparação',
                  onPressed: () {
                    Navigator.pushNamed(context, ComparisonRoutes.theme);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
