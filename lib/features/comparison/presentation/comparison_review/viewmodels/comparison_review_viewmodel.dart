import 'package:flutter/foundation.dart';
import '../../../models/comparison_draft_model.dart';

class ComparisonReviewViewModel extends ChangeNotifier {
  late ComparisonDraftModel _draft;
  ComparisonDraftModel get draft => _draft;
  void setDraft(ComparisonDraftModel draft) {
    _draft = draft;
    notifyListeners();
  }

  void updateTheme(String theme) =>
      setDraft(_draft.copyWith(theme: theme.trim()));
}
