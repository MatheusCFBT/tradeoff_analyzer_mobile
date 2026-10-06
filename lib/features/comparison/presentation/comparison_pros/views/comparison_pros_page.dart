import 'package:get_it/get_it.dart';
import '../../comparison_cons/comparison_cons_arguments.dart';
import '../../comparison_cons/viewmodels/comparison_cons_viewmodel.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/comparison_routes.dart';
import 'package:flutter/material.dart';
import '../../widgets/comparison_arguments_body.dart';
import '../viewmodels/comparison_pros_viewmodel.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_base_scaffold.dart';

class ComparisonProsPage extends StatefulWidget {
  const ComparisonProsPage({required this.theme, this.viewModel, super.key});

  final String theme;
  final ComparisonProsViewModel? viewModel;

  @override
  State<ComparisonProsPage> createState() => _ComparisonProsPageState();
}

class _ComparisonProsPageState extends State<ComparisonProsPage> {
  final ValueNotifier<double> _progress = ValueNotifier<double>(0.5);

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final ComparisonProsViewModel _viewModel;
  late final ComparisonConsViewModel _consViewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? ComparisonProsViewModel();
    _consViewModel = GetIt.instance.get<ComparisonConsViewModel>();
    _viewModel.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  void _submitPro(String value) {
    if (_viewModel.addPro(value)) {
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_refresh);
    _viewModel.dispose();
    _consViewModel.dispose();
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
        arguments: _viewModel.pros,
        controller: _controller,
        focusNode: _focusNode,
        onSubmitted: _submitPro,
        onBack: () => Navigator.pop(context),
        onNext: () => Navigator.pushNamed(
          context,
          ComparisonRoutes.cons,
          arguments: ComparisonConsArguments(
            theme: widget.theme,
            viewModel: _consViewModel,
          ),
        ),
      ),
    );
  }
}
