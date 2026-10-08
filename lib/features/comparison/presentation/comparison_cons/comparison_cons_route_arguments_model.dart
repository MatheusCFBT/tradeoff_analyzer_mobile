import '../../models/comparison_draft_model.dart';

class ComparisonConsRouteArgumentsModel {
  const ComparisonConsRouteArgumentsModel({
    required this.draft,
    this.hasProsStep = false,
  });
  final ComparisonDraftModel draft;

  final bool hasProsStep;
}
