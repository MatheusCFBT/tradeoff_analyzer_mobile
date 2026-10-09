import '../../../comparison_routes.dart';
import '../../../../../routers/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_base_scaffold.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_primary_button.dart';
import '../../../models/comparison_draft_model.dart';
import '../../../models/comparison_model.dart';
import '../viewmodels/comparison_decision_viewmodel.dart';
import '../widgets/comparison_decision_option.dart';

class ComparisonDecisionPage extends StatefulWidget {
  const ComparisonDecisionPage({
    required this.draft,
    required this.viewModel,
    super.key,
  });
  final ComparisonDraftModel draft;
  final ComparisonDecisionViewModel viewModel;
  @override
  State<ComparisonDecisionPage> createState() => _ComparisonDecisionPageState();
}

class _ComparisonDecisionPageState extends State<ComparisonDecisionPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_refresh);
  }

  void _refresh() => setState(() {});
  void _confirm() {
    final completed = widget.viewModel.confirm(widget.draft);
    if (completed == null) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      ComparisonRoutes.completed,
      (route) => route.settings.name == AppRoutes.home || route.isFirst,
      arguments: completed,
    );
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_refresh);
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pros = widget.draft.pros.length;
    final cons = widget.draft.cons.length;
    return AppBaseScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.balance,
                        size: 18,
                        color: Color(0xFFB57B21),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Decisão: ${widget.draft.theme}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFF003541),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Qual lado tem mais peso?',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF172126),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Selecione o seu veredito final para concluir esta decisão.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      height: 1.4,
                      color: Color(0xFF245B6B),
                    ),
                  ),
                  const SizedBox(height: 28),
                  ComparisonDecisionOption(
                    title: 'Pender para os Prós',
                    description:
                        '$pros ${pros == 1 ? 'argumento favorável' : 'argumentos favoráveis'}',
                    icon: Icons.thumb_up,
                    selected:
                        widget.viewModel.selectedSide == SelectedSide.pros,
                    onTap: () => widget.viewModel.selectSide(SelectedSide.pros),
                  ),
                  const SizedBox(height: 16),
                  ComparisonDecisionOption(
                    title: 'Pender para os Contras',
                    description:
                        '$cons ${cons == 1 ? 'argumento desfavorável' : 'argumentos desfavoráveis'}',
                    icon: Icons.thumb_down,
                    selected:
                        widget.viewModel.selectedSide == SelectedSide.cons,
                    onTap: () => widget.viewModel.selectSide(SelectedSide.cons),
                  ),
                  const SizedBox(height: 28),
                  AppPrimaryButton(
                    label: 'Confirmar Decisão',
                    icon: const Icon(Icons.check_circle_outline),
                    onPressed: widget.viewModel.canConfirm ? _confirm : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
