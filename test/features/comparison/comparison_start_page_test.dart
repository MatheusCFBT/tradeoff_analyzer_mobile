import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/comparison_routes.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_theme/views/comparison_theme_page.dart';
import 'comparison_test_app.dart';

void main() {
  setUpComparisonApp();
  testWidgets('shows the start comparison content without a card', (
    tester,
  ) async {
    await openApp(tester);

    expect(find.text('Comece sua primeira decisão'), findsOneWidget);
    expect(find.textContaining('organizar prós e contras'), findsOneWidget);
    expect(find.text('Nova comparação'), findsOneWidget);
    expect(find.byType(Card), findsNothing);

    final buttonLabel = tester.widget<Text>(find.text('Nova comparação'));
    expect(buttonLabel.style?.color, Colors.white);
  });

  testWidgets('opens the decision theme page from the start page', (
    tester,
  ) async {
    await openApp(tester);
    await tester.tap(find.text('Nova comparação'));
    await tester.pumpAndSettle();

    expect(find.text('Sobre o que é esta decisão?'), findsOneWidget);
    final settings = ModalRoute.of(
      tester.element(find.byType(ComparisonThemePage)),
    )!.settings;
    expect(settings.name, ComparisonRoutes.theme);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Sobre o que é esta decisão?'), findsNothing);
    expect(find.text('Comece sua primeira decisão'), findsOneWidget);
  });

  testWidgets('start remains usable on a small screen', (tester) async {
    setViewport(tester, const Size(320, 600));
    await openApp(tester);
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Nova comparação'));
    await tester.tap(find.text('Nova comparação'));
    await tester.pumpAndSettle();
    expect(find.byType(ComparisonThemePage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
