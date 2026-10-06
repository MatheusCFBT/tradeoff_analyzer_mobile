import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/comparison_routes.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_pros/views/comparison_pros_page.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/views/comparison_start_page.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_theme/views/comparison_theme_page.dart';
import 'package:tradeoff_analyzer_mobile/routers/app_routes.dart';
import 'comparison_test_app.dart';

void main() {
  setUpComparisonApp();
  testWidgets('home preserves its named route settings', (tester) async {
    await openApp(tester);
    expect(find.text('Comece sua primeira decisão'), findsOneWidget);
    expect(
      ModalRoute.of(
        tester.element(find.byType(ComparisonStartPage)),
      )!.settings.name,
      AppRoutes.home,
    );
  });

  testWidgets('opens comparison start by name and preserves arguments', (
    tester,
  ) async {
    await openApp(tester);
    final arguments = {'source': 'test'};
    Navigator.pushNamed(
      tester.element(find.byType(ComparisonStartPage)),
      ComparisonRoutes.start,
      arguments: arguments,
    );
    await tester.pumpAndSettle();
    final settings = ModalRoute.of(
      tester.element(find.byType(ComparisonStartPage)),
    )!.settings;
    expect(settings.name, ComparisonRoutes.start);
    expect(settings.arguments, same(arguments));
  });

  testWidgets('unknown route shows error and retains its settings', (
    tester,
  ) async {
    await openApp(tester);
    Navigator.pushNamed(
      tester.element(find.byType(ComparisonStartPage)),
      '/unknown',
      arguments: 'original argument',
    );
    await tester.pumpAndSettle();
    expect(find.text('Rota não encontrada'), findsOneWidget);
    final settings = ModalRoute.of(
      tester.element(find.text('Rota não encontrada')),
    )!.settings;
    expect(settings.name, '/unknown');
    expect(settings.arguments, 'original argument');
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(ComparisonStartPage), findsOneWidget);
  });

  for (final argument in <Object?>[null, 42, '', '   ']) {
    testWidgets('rejects invalid pros argument: $argument', (tester) async {
      await openApp(tester);
      Navigator.pushNamed(
        tester.element(find.byType(ComparisonStartPage)),
        ComparisonRoutes.pros,
        arguments: argument,
      );
      await tester.pumpAndSettle();
      expect(find.text('Rota não encontrada'), findsOneWidget);
      expect(find.byType(ComparisonProsPage), findsNothing);
      final settings = ModalRoute.of(
        tester.element(find.text('Rota não encontrada')),
      )!.settings;
      expect(settings.name, ComparisonRoutes.pros);
      expect(settings.arguments, argument);
    });
  }

  testWidgets('opens pros directly by name with a valid theme', (tester) async {
    await openApp(tester);
    Navigator.pushNamed(
      tester.element(find.byType(ComparisonStartPage)),
      ComparisonRoutes.pros,
      arguments: 'Mudar de carreira',
    );
    await tester.pumpAndSettle();
    expect(find.text('Mudar de carreira'), findsOneWidget);
    final settings = ModalRoute.of(
      tester.element(find.byType(ComparisonProsPage)),
    )!.settings;
    expect(settings.name, ComparisonRoutes.pros);
    expect(settings.arguments, 'Mudar de carreira');
  });

  testWidgets('continues to the pros page with the entered decision theme', (
    tester,
  ) async {
    await openApp(tester);

    await tester.tap(find.text('Nova comparação'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField),
      '  Mudança de Carreira  ',
    );
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    final settings = ModalRoute.of(
      tester.element(find.byType(ComparisonProsPage)),
    )!.settings;
    expect(settings.name, ComparisonRoutes.pros);
    expect(settings.arguments, 'Mudança de Carreira');
    expect(find.text('Mudança de Carreira'), findsOneWidget);

    await tester.tap(find.text('Voltar'));
    await tester.pumpAndSettle();
    expect(find.text('Sobre o que é esta decisão?'), findsOneWidget);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0.25,
    );
    expect(
      tester.widget<TextFormField>(find.byType(TextFormField)).controller?.text,
      '  Mudança de Carreira  ',
    );
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(ComparisonStartPage), findsOneWidget);
    expect(find.byType(ComparisonThemePage), findsNothing);
  });
}
