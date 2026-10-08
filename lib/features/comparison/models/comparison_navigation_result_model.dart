import 'comparison_draft_model.dart';

enum ComparisonEditTarget { pros, cons }

class ComparisonNavigationResultModel {
  const ComparisonNavigationResultModel(this.draft, {this.editTarget});

  final ComparisonDraftModel draft;

  final ComparisonEditTarget? editTarget;
}
