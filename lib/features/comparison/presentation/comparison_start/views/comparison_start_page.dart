import 'package:flutter/material.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/viewmodels/comparison_start_viewmodel.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/base_scaffold.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/empty_state_content.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/primary_button.dart';

class ComparisonStartPage extends StatefulWidget {
  const ComparisonStartPage({
    required this.viewModel,
    super.key
  });

  final ComparisonStartViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _ComparisonStartPageState();
}

class _ComparisonStartPageState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: EmptyStateContent(
              title: 'Comece sua primeira decisão',
              description:
                  'Iniciar uma comparação ajudará você a organizar prós e contras, reduzindo o esforço mental e trazendo clareza objetiva.',
              action: PrimaryButton(
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: 'Nova comparação',
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }
}