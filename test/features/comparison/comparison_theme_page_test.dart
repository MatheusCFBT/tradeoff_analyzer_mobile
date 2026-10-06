import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_pros/views/comparison_pros_page.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_theme/views/comparison_theme_page.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_header.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_progress_bar.dart';
import 'comparison_test_app.dart';

void main() {
  setUpComparisonApp();
  testWidgets('shows the decision theme form and progress', (tester) async {
    await openTheme(tester);

    expect(find.byType(AppProgressBar), findsOneWidget);
    expect(
      tester.widget<AppProgressBar>(find.byType(AppProgressBar)).value,
      0.25,
    );
    expect(find.byType(AppHeader), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
    expect(find.text('Sobre o que é esta decisão?'), findsOneWidget);
    expect(
      find.text(
        'Defina o tema principal para começar a organizar seus pensamentos.',
      ),
      findsOneWidget,
    );
    expect(find.text('Tema da Decisão'), findsOneWidget);
    expect(
      find.text('Ex: Mudar de carreira, Comprar um carro...'),
      findsOneWidget,
    );
    expect(
      find.text('Seja claro e objetivo para facilitar a análise.'),
      findsOneWidget,
    );
    expect(find.text('Continuar'), findsOneWidget);
  });

  for (final input in ['', '   ']) {
    testWidgets('rejects blank theme: "$input"', (tester) async {
      setViewport(tester, const Size(800, 800));
      await openTheme(tester);
      await tester.enterText(find.byType(TextFormField), input);
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
      expect(find.text('Informe o tema da decisão.'), findsOneWidget);
      expect(find.byType(ComparisonThemePage), findsOneWidget);
      expect(find.byType(ComparisonProsPage), findsNothing);
    });
  }

  testWidgets('theme form remains accessible with keyboard on a small screen', (
    tester,
  ) async {
    await openTheme(tester);
    setViewport(tester, const Size(320, 600), keyboardHeight: 250);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.byType(TextFormField));
    await tester.enterText(find.byType(TextFormField), '   ');
    await tester.ensureVisible(find.text('Continuar'));
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Informe o tema da decisão.'));
    expect(
      find.text('Informe o tema da decisão.').hitTestable(),
      findsOneWidget,
    );
    await tester.ensureVisible(find.byType(TextFormField));
    await tester.enterText(find.byType(TextFormField), '  Comprar um carro  ');
    await tester.ensureVisible(find.text('Continuar'));
    expect(find.text('Continuar').hitTestable(), findsOneWidget);
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.byType(ComparisonProsPage), findsOneWidget);
    expect(find.text('Comprar um carro'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
