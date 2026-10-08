import 'package:flutter/material.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_base_scaffold.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_primary_button.dart';

import '../../../comparison_routes.dart';
import '../../comparison_cons/comparison_cons_route_arguments_model.dart';
import '../../../models/comparison_navigation_result_model.dart';
import '../../widgets/argument_management/argument_edit_sheet.dart';
import '../../widgets/argument_management/argument_modal_routes.dart';
import '../../../models/comparison_review_route_arguments_model.dart';
import '../viewmodels/comparison_review_viewmodel.dart';
import '../widgets/comparison_review_section.dart';

class ComparisonReviewPage extends StatefulWidget {
  const ComparisonReviewPage({
    required this.arguments,
    required this.viewModel,
    super.key,
  });
  final ComparisonReviewRouteArgumentsModel arguments;
  final ComparisonReviewViewModel viewModel;
  @override
  State<ComparisonReviewPage> createState() => _ComparisonReviewPageState();
}

class _ComparisonReviewPageState extends State<ComparisonReviewPage> {
  final _progress = ValueNotifier<double>(1);
  ComparisonReviewViewModel get _viewModel => widget.viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel.setDraft(widget.arguments.draft);
    _viewModel.addListener(_refresh);
  }

  void _refresh() => setState(() {});
  void _back() =>
      Navigator.pop(context, ComparisonNavigationResultModel(_viewModel.draft));
  Future<void> _editTheme() async {
    final navigator = Navigator.of(context);
    final text = await navigator.push(
      ArgumentBottomSheetRoute<String>(
        builder: (_) => ArgumentEditSheet(
          argument: _viewModel.draft.theme,
          title: 'Editar Tema',
          subtitle: 'Edite o tema da sua decisão',
          label: 'Tema da Decisão',
          emptyMessage: 'Informe o tema da decisão.',
        ),
        capturedThemes: InheritedTheme.capture(
          from: context,
          to: navigator.context,
        ),
        barrierLabel: MaterialLocalizations.of(
          context,
        ).modalBarrierDismissLabel,
        maxHeight: MediaQuery.sizeOf(context).height * .85,
      ),
    );
    if (!mounted || text == null) return;
    _viewModel.updateTheme(text);
  }

  Future<void> _edit(ComparisonEditTarget target) async {
    final hasStep = target == ComparisonEditTarget.pros
        ? widget.arguments.hasProsStep
        : widget.arguments.hasConsStep;
    if (hasStep) {
      Navigator.pop(
        context,
        ComparisonNavigationResultModel(_viewModel.draft, editTarget: target),
      );
      return;
    }
    final result = await Navigator.pushNamed<ComparisonNavigationResultModel>(
      context,
      target == ComparisonEditTarget.pros
          ? ComparisonRoutes.pros
          : ComparisonRoutes.cons,
      arguments: target == ComparisonEditTarget.pros
          ? _viewModel.draft
          : ComparisonConsRouteArgumentsModel(draft: _viewModel.draft),
    );
    if (!mounted || result == null) return;
    _viewModel.setDraft(result.draft);
  }

  Future<void> _finish() async {
    await Navigator.pushNamed(
      context,
      ComparisonRoutes.decision,
      arguments: _viewModel.draft,
    );
  }

  @override
  void dispose() {
    _viewModel.removeListener(_refresh);
    _viewModel.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      PopScope<ComparisonNavigationResultModel>(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) _back();
        },
        child: AppBaseScaffold(
          progress: _progress,
          showProgressBar: true,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 28,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Revisar Decisão',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF003541),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Revise os detalhes antes de finalizar.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Color(0xFF245B6B),
                              ),
                            ),
                            const SizedBox(height: 32),
                            ComparisonReviewSection(
                              title: 'Tema da Decisão',
                              items: [_viewModel.draft.theme],
                              onEdit: _editTheme,
                            ),
                            const SizedBox(height: 20),
                            ComparisonReviewSection(
                              title: 'Prós',
                              items: _viewModel.draft.pros,
                              icon: Icons.add_circle_outline,
                              emptyMessage: 'Nenhum pró adicionado.',
                              onEdit: () => _edit(ComparisonEditTarget.pros),
                            ),
                            const SizedBox(height: 20),
                            ComparisonReviewSection(
                              title: 'Contras',
                              items: _viewModel.draft.cons,
                              icon: Icons.remove_circle_outline,
                              color: const Color(0xFFD71919),
                              emptyMessage: 'Nenhum contra adicionado.',
                              onEdit: () => _edit(ComparisonEditTarget.cons),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: AppPrimaryButton(
                        label: 'Finalizar Decisão',
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: _finish,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
