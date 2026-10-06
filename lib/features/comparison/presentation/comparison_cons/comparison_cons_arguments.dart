import 'viewmodels/comparison_cons_viewmodel.dart';

/// Shares the cons owned by the pros step while preserving direct String routes.
class ComparisonConsArguments {
  const ComparisonConsArguments({required this.theme, required this.viewModel});

  final String theme;
  final ComparisonConsViewModel viewModel;
}
