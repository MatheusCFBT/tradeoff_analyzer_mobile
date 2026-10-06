import 'package:flutter/material.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_text_field.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_pros/views/comparison_pros_page.dart';

void main() {
  Future<void> openPage(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ComparisonProsPage(theme: 'Mudar de carreira')),
    );
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
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 250);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    await openPage(tester);
    for (var i = 0; i < 8; i++) {
      await submit(
        tester,
        'Argumento $i com uma descrição longa que deve quebrar em várias linhas sem overflow.',
      );
    }
    await tester.ensureVisible(find.text('8 Itens'));
    await tester.pumpAndSettle();
    expect(find.text('8 Itens'), findsOneWidget);
  });
}
