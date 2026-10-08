import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_base_scaffold.dart';
import '../../../comparison_routes.dart';
import '../../../models/comparison_draft_model.dart';
import '../../../models/comparison_navigation_result_model.dart';
import '../../../models/comparison_review_route_arguments_model.dart';
import '../../widgets/comparison_arguments_body.dart';
import '../viewmodels/comparison_cons_viewmodel.dart';

class ComparisonConsPage extends StatefulWidget {
  const ComparisonConsPage({
    required this.theme,
    this.draft,
    this.viewModel,
    this.hasProsStep = false,
    super.key,
  });
  final String theme;
  final ComparisonDraftModel? draft;
  final ComparisonConsViewModel? viewModel;
  final bool hasProsStep;
  @override
  State<ComparisonConsPage> createState() => _ComparisonConsPageState();
}

class _ComparisonConsPageState extends State<ComparisonConsPage> {
  final _progress = ValueNotifier<double>(.75);
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  late final ComparisonConsViewModel _viewModel;
  late ComparisonDraftModel _draft;
  ComparisonDraftModel get _snapshot => _draft.copyWith(cons: _viewModel.cons);

  @override
  void initState() {
    super.initState();
    _draft = widget.draft ?? ComparisonDraftModel(theme: widget.theme);
    _viewModel =
        widget.viewModel ?? GetIt.instance.get<ComparisonConsViewModel>();
    if (widget.draft != null) _viewModel.replaceCons(_draft.cons);
    _viewModel.addListener(_refresh);
  }

  void _refresh() => setState(() {});
  void _submitCon(String value) {
    if (_viewModel.addCon(value)) {
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  void _back() =>
      Navigator.pop(context, ComparisonNavigationResultModel(_snapshot));

  Future<void> _next() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final result = await Navigator.pushNamed<ComparisonNavigationResultModel>(
      context,
      ComparisonRoutes.review,
      arguments: ComparisonReviewRouteArgumentsModel(
        draft: _snapshot,
        hasProsStep: widget.hasProsStep,
        hasConsStep: true,
      ),
    );
    if (!mounted || result == null) return;
    setState(() => _draft = result.draft);
    _viewModel.replaceCons(result.draft.cons);
    if (result.editTarget == ComparisonEditTarget.pros && widget.hasProsStep) {
      Navigator.pop(
        context,
        ComparisonNavigationResultModel(
          _snapshot,
          editTarget: ComparisonEditTarget.pros,
        ),
      );
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_refresh);
    _viewModel.dispose();
    _controller.dispose();
    _focusNode.dispose();
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
          body: ComparisonArgumentsBody(
            theme: _draft.theme,
            arguments: _viewModel.cons,
            controller: _controller,
            focusNode: _focusNode,
            onSubmitted: _submitCon,
            onUpdate: _viewModel.updateCon,
            onRemove: _viewModel.removeCon,
            onBack: _back,
            onNext: _next,
            isCons: true,
          ),
        ),
      );
}
