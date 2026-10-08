import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_base_scaffold.dart';
import '../../../comparison_routes.dart';
import '../../../models/comparison_draft_model.dart';
import '../../../models/comparison_navigation_result_model.dart';
import '../../comparison_cons/comparison_cons_route_arguments_model.dart';
import '../../widgets/comparison_arguments_body.dart';
import '../viewmodels/comparison_pros_viewmodel.dart';

class ComparisonProsPage extends StatefulWidget {
  const ComparisonProsPage({
    required this.theme,
    this.draft,
    this.viewModel,
    super.key,
  });
  final String theme;
  final ComparisonDraftModel? draft;
  final ComparisonProsViewModel? viewModel;

  @override
  State<ComparisonProsPage> createState() => _ComparisonProsPageState();
}

class _ComparisonProsPageState extends State<ComparisonProsPage> {
  final _progress = ValueNotifier<double>(.5);
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  late final ComparisonProsViewModel _viewModel;
  late ComparisonDraftModel _draft;
  ComparisonDraftModel get _snapshot => _draft.copyWith(pros: _viewModel.pros);

  @override
  void initState() {
    super.initState();
    _draft = widget.draft ?? ComparisonDraftModel(theme: widget.theme);
    _viewModel =
        widget.viewModel ?? GetIt.instance.get<ComparisonProsViewModel>();
    if (widget.draft != null) _viewModel.replacePros(_draft.pros);
    _viewModel.addListener(_refresh);
  }

  void _refresh() => setState(() {});
  void _submitPro(String value) {
    if (_viewModel.addPro(value)) {
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
      ComparisonRoutes.cons,
      arguments: ComparisonConsRouteArgumentsModel(
        draft: _snapshot,
        hasProsStep: true,
      ),
    );
    if (!mounted || result == null) return;
    setState(() => _draft = result.draft);
    _viewModel.replacePros(result.draft.pros);
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
            arguments: _viewModel.pros,
            controller: _controller,
            focusNode: _focusNode,
            onSubmitted: _submitPro,
            onUpdate: _viewModel.updatePro,
            onRemove: _viewModel.removePro,
            onBack: _back,
            onNext: _next,
            isCons: false,
          ),
        ),
      );
}
