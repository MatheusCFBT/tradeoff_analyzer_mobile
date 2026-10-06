import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_base_scaffold.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_primary_button.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/empty_state_content.dart';

void main() {
  testWidgets('AppBaseScaffold shows progress only when enabled', (
    tester,
  ) async {
    final progress = ValueNotifier<double>(0.25);

    await tester.pumpWidget(
      MaterialApp(
        home: AppBaseScaffold(
          body: const Text('Body'),
          progress: progress,
          showProgressBar: true,
        ),
      ),
    );

    final indicatorFinder = find.byType(LinearProgressIndicator);
    expect(indicatorFinder, findsOneWidget);
    expect(tester.widget<LinearProgressIndicator>(indicatorFinder).value, 0.25);

    progress.value = 0.5;
    await tester.pump();
    expect(tester.widget<LinearProgressIndicator>(indicatorFinder).value, 0.5);

    await tester.pumpWidget(
      MaterialApp(home: AppBaseScaffold(body: const Text('Body'))),
    );
    expect(indicatorFinder, findsNothing);
    progress.dispose();
  });

  testWidgets('AppPrimaryButton accepts a custom text color', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppPrimaryButton(
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
