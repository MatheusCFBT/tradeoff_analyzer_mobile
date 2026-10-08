import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/models/comparison_draft_model.dart';

void main() {
  test('draft copies collections and prevents mutation', () {
    final pros = ['Mesmo argumento', 'Mesmo argumento'];
    final cons = ['Contra'];
    final draft = ComparisonDraftModel(theme: 'Tema', pros: pros, cons: cons);
    pros.clear();
    cons.clear();
    expect(draft.pros, ['Mesmo argumento', 'Mesmo argumento']);
    expect(draft.cons, ['Contra']);
    expect(() => draft.pros.add('Outro'), throwsUnsupportedError);
    expect(() => draft.cons.clear(), throwsUnsupportedError);
    final updated = draft.copyWith(theme: 'Novo tema', cons: []);
    expect(updated.theme, 'Novo tema');
    expect(updated.pros, draft.pros);
    expect(updated.cons, isEmpty);
    expect(draft.theme, 'Tema');
    expect(draft.cons, ['Contra']);
  });
}
