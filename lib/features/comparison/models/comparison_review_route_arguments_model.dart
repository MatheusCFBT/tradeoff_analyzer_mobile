import 'comparison_draft_model.dart';

class ComparisonReviewRouteArgumentsModel {
  const ComparisonReviewRouteArgumentsModel({
    required this.draft,
    this.hasProsStep = false,
    this.hasConsStep = false,
  });
  final ComparisonDraftModel draft;

  final bool hasProsStep;

  final bool hasConsStep;
}
