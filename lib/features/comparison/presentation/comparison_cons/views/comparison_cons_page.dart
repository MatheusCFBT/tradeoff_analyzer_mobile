import 'package:flutter/material.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_base_scaffold.dart';
import '../../widgets/comparison_arguments_body.dart';
import '../viewmodels/comparison_cons_viewmodel.dart';

class ComparisonConsPage extends StatefulWidget {
  const ComparisonConsPage({
    required this.theme,
    this.viewModel,
    this.disposeViewModel = false,
    super.key,
  });
  final String theme;
  final ComparisonConsViewModel? viewModel;

  /// Set for a route-owned instance; shared instances belong to the pros step.
  final bool disposeViewModel;

  @override
  State<ComparisonConsPage> createState() => _ComparisonConsPageState();
}

class _ComparisonConsPageState extends State<ComparisonConsPage> {
  final _progress = ValueNotifier<double>(.75);
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  late final ComparisonConsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? ComparisonConsViewModel();
    _viewModel.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  void _submitCon(String value) {
    if (_viewModel.addCon(value)) {
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_refresh);
    if (widget.viewModel == null || widget.disposeViewModel) {
      _viewModel.dispose();
    }
    _controller.dispose();
    _focusNode.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBaseScaffold(
      progress: _progress,
      showProgressBar: true,
      body: ComparisonArgumentsBody(
        theme: widget.theme,
        arguments: _viewModel.cons,
        controller: _controller,
        focusNode: _focusNode,
        onSubmitted: _submitCon,
        onBack: () => Navigator.pop(context),
        onNext: () {},
        isCons: true,
      ),
    );
  }
}
