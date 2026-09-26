import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/viewmodels/comparison_start_viewmodel.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/views/comparison_start_page.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/repositories/comparison_repository_interface.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/empty_state_content.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/primary_button.dart';

void main() {
  testWidgets('shows the start comparison content without a card', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ComparisonStartPage(
          viewModel: ComparisonStartViewModel(
            repository: _FakeComparisonRepository(),
          ),
        ),
      ),
    );

    expect(find.text('Comece sua primeira decisão'), findsOneWidget);
    expect(find.textContaining('organizar prós e contras'), findsOneWidget);
    expect(find.text('Nova comparação'), findsOneWidget);
    expect(find.byType(Card), findsNothing);

    final buttonLabel = tester.widget<Text>(find.text('Nova comparação'));
    expect(buttonLabel.style?.color, Colors.white);
  });

  testWidgets('PrimaryButton accepts a custom text color', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            label: 'Custom color',
            onPressed: null,
            textColor: Colors.red,
          ),
        ),
      ),
    );

    final label = tester.widget<Text>(find.text('Custom color'));
    expect(label.style?.color, Colors.red);
  });

  testWidgets('EmptyStateContent omits the avatar when it is not provided', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyStateContent(title: 'Title', description: 'Description'),
        ),
      ),
    );

    expect(find.byType(CircleAvatar), findsNothing);
  });
}

class _FakeComparisonRepository implements IComparisonRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
