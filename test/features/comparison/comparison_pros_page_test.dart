import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_text_field.dart';

import 'comparison_test_app.dart';

void main() {
  setUpComparisonApp();
  Future<void> openPage(WidgetTester tester) async {
    await openPros(tester, 'Mudar de carreira');
  }

  Future<void> submit(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(AppTextField), text);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
  }

  testWidgets('adds trimmed pros through the keyboard and keeps focus', (
    tester,
  ) async {
    await openPage(tester);
    expect(find.text('Prós Adicionados'), findsOneWidget);
    expect(find.text('0 Itens'), findsOneWidget);
    await submit(tester, '  Melhor salário  ');
    expect(find.text('Melhor salário'), findsOneWidget);
    expect(find.text('1 Item'), findsOneWidget);
    final field = tester.widget<AppTextField>(find.byType(AppTextField));
    expect(field.controller!.text, isEmpty);
    expect(field.focusNode!.hasFocus, isTrue);
    expect(
      tester.getTopLeft(find.text('Melhor salário')).dy,
      greaterThan(tester.getTopLeft(find.byType(AppTextField)).dy),
    );
    await submit(tester, 'Flexibilidade');
    expect(find.text('2 Itens'), findsOneWidget);
    await submit(tester, 'Melhor salário');
    expect(find.text('3 Itens'), findsOneWidget);
    expect(find.text('Melhor salário'), findsNWidgets(2));
    expect(
      tester.getTopLeft(find.text('Melhor salário').first).dy,
      lessThan(tester.getTopLeft(find.text('Flexibilidade')).dy),
    );
  });

  testWidgets('ignores empty pros', (tester) async {
    await openPage(tester);
    await submit(tester, '');
    await submit(tester, '   ');
    expect(find.text('0 Itens'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNothing);
  });

  testWidgets('scrolls long lists on small screens with keyboard open', (
    tester,
  ) async {
    setViewport(tester, const Size(320, 600), keyboardHeight: 250);
    await openPage(tester);
    for (var i = 0; i < 8; i++) {
      await submit(
        tester,
        'Argumento $i com uma descrição longa que deve quebrar em várias linhas sem overflow.',
      );
    }
    await tester.ensureVisible(find.text('8 Itens'));
    await tester.pumpAndSettle();
    expect(find.text('8 Itens').hitTestable(), findsOneWidget);
    final lastPro = find.text(
      'Argumento 7 com uma descrição longa que deve quebrar em várias linhas sem overflow.',
    );
    await tester.ensureVisible(lastPro);
    await tester.pumpAndSettle();
    expect(lastPro.hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows theme, progress and an empty list', (tester) async {
    await openPage(tester);
    expect(find.text('Decisão Atual'), findsOneWidget);
    expect(find.text('Mudar de carreira'), findsOneWidget);
    expect(find.text('Adicionar Argumento Favorável'), findsOneWidget);
    expect(find.text('O que pesa a favor dessa decisão?'), findsOneWidget);
    expect(find.text('Ex: Melhor salário, Novos desafios...'), findsOneWidget);
    expect(find.text('Prós Adicionados'), findsOneWidget);
    expect(find.text('0 Itens'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNothing);
    expect(find.text('Voltar'), findsOneWidget);
    expect(find.text('Próximo Passo'), findsOneWidget);
    final backButton = tester.widget<TextButton>(find.byType(TextButton));
    expect(
      tester.getSize(find.byType(TextButton)),
      tester.getSize(find.byType(ElevatedButton)),
    );
    expect(backButton.style?.side, isNull);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .minHeight,
      3,
    );
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0.5,
    );
  });
}
