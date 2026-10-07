import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/views/comparison_start_page.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_text_field.dart';

import 'comparison_test_app.dart';

void main() {
  setUpComparisonApp();

  Future<void> openCons(WidgetTester tester) async {
    await openApp(tester);
    Navigator.pushNamed(
      tester.element(find.byType(ComparisonStartPage)),
      '/comparison/cons',
      arguments: 'Mudar de carreira',
    );
    await tester.pumpAndSettle();
  }

  Future<void> submit(WidgetTester tester, String value) async {
    await tester.enterText(find.byType(AppTextField), value);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
  }

  testWidgets('next opens cons with theme, progress and an empty list', (
    tester,
  ) async {
    await openPros(tester, 'Mudar de carreira');
    await tester.tap(find.text('Próximo Passo'));
    await tester.pumpAndSettle();
    expect(find.text('Adicionar Argumento Desfavorável'), findsOneWidget);
    expect(find.text('O que pesa contra essa decisão?'), findsOneWidget);
    expect(
      find.text('Ex: Perda de estabilidade, Menor salário...'),
      findsOneWidget,
    );
    expect(find.text('Mudar de carreira'), findsOneWidget);
    expect(find.text('Contras Adicionados'), findsOneWidget);
    expect(find.text('0 Itens'), findsOneWidget);
    expect(find.byIcon(Icons.remove), findsOneWidget);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      .75,
    );
  });

  testWidgets(
    'adds trimmed cons, keeps focus, duplicates and insertion order',
    (tester) async {
      await openCons(tester);
      await submit(tester, '  Menor salário  ');
      expect(find.text('Menor salário'), findsOneWidget);
      expect(find.text('1 Item'), findsOneWidget);
      final field = tester.widget<AppTextField>(find.byType(AppTextField));
      expect(field.controller!.text, isEmpty);
      expect(field.focusNode!.hasFocus, isTrue);
      await submit(tester, 'Perda de estabilidade');
      expect(find.text('2 Itens'), findsOneWidget);
      await submit(tester, 'Menor salário');
      expect(find.text('Menor salário'), findsNWidgets(2));
      expect(find.text('3 Itens'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Menor salário').first).dy,
        lessThan(tester.getTopLeft(find.text('Perda de estabilidade')).dy),
      );
      expect(find.byIcon(Icons.cancel), findsNWidgets(3));
    },
  );

  testWidgets('ignores empty and whitespace cons', (tester) async {
    await openCons(tester);
    await submit(tester, '');
    await submit(tester, '   ');
    expect(find.text('0 Itens'), findsOneWidget);
    expect(find.byIcon(Icons.cancel), findsNothing);
  });

  for (final systemBack in [false, true]) {
    testWidgets(
      'preserves both lists on return and reentry: system=$systemBack',
      (tester) async {
        await openPros(tester, 'Mudar de carreira');
        await submit(tester, 'Melhor salário');
        await tester.enterText(find.byType(AppTextField), 'Pró em edição');
        await tester.tap(find.text('Próximo Passo'));
        await tester.pumpAndSettle();
        await submit(tester, 'Perda de estabilidade');
        if (systemBack) {
          await tester.binding.handlePopRoute();
        } else {
          await tester.tap(find.text('Voltar'));
        }
        await tester.pumpAndSettle();
        expect(find.text('Prós Adicionados'), findsOneWidget);
        expect(find.text('Melhor salário'), findsOneWidget);
        expect(
          tester
              .widget<AppTextField>(find.byType(AppTextField))
              .controller!
              .text,
          'Pró em edição',
        );
        await tester.tap(find.text('Próximo Passo'));
        await tester.pumpAndSettle();
        expect(find.text('Contras Adicionados'), findsOneWidget);
        expect(find.text('Perda de estabilidade'), findsOneWidget);
        expect(find.text('1 Item'), findsOneWidget);
        await submit(tester, 'Menor salário');
        expect(find.text('2 Itens'), findsOneWidget);
        expect(find.text('Perda de estabilidade'), findsOneWidget);
        expect(find.text('Menor salário'), findsOneWidget);
      },
    );
  }

  testWidgets('scrolls long cons with keyboard on small screens', (
    tester,
  ) async {
    await openCons(tester);
    setViewport(tester, const Size(320, 600), keyboardHeight: 250);
    await tester.pumpAndSettle();
    for (var i = 0; i < 8; i++) {
      await submit(
        tester,
        'Contra $i com descrição longa que quebra em várias linhas sem overflow.',
      );
    }
    final last = find.text(
      'Contra 7 com descrição longa que quebra em várias linhas sem overflow.',
    );
    await tester.ensureVisible(last);
    await tester.pumpAndSettle();
    expect(last.hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('a new comparison starts with no previous cons', (tester) async {
    await openPros(tester, 'Mudar de carreira');
    await tester.tap(find.text('Próximo Passo'));
    await tester.pumpAndSettle();
    await submit(tester, 'Perda de estabilidade');
    await tester.tap(find.text('Voltar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Voltar'));
    await tester.pumpAndSettle();
    Navigator.pushNamed(
      tester.element(find.byType(ComparisonStartPage)),
      '/comparison/pros',
      arguments: 'Mudar de carreira',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Próximo Passo'));
    await tester.pumpAndSettle();
    expect(find.text('Contras Adicionados'), findsOneWidget);
    expect(find.text('0 Itens'), findsOneWidget);
    expect(find.text('Perda de estabilidade'), findsNothing);
  });
}
