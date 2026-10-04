import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_text_field.dart';

void main() {
  testWidgets('forwards focus and keyboard completion callbacks', (
    tester,
  ) async {
    final focus = FocusNode();
    final events = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTextField(
            focusNode: focus,
            textInputAction: TextInputAction.done,
            onEditingComplete: () => events.add('complete'),
            onFieldSubmitted: (value) => events.add(value),
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(TextFormField), 'Melhor salário');
    expect(focus.hasFocus, isTrue);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(events, ['complete', 'Melhor salário']);
    expect(focus.hasFocus, isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
    focus.dispose();
  });

  testWidgets('shows standardized text and updates the supplied controller', (
    tester,
  ) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTextField(
            label: 'Tema da Decisão',
            hintText: 'Digite um tema',
            helperText: 'Seja claro e objetivo.',
            controller: controller,
          ),
        ),
      ),
    );

    expect(find.text('Tema da Decisão'), findsOneWidget);
    expect(find.text('Digite um tema'), findsOneWidget);
    expect(find.text('Seja claro e objetivo.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'Mudar de carreira');
    expect(controller.text, 'Mudar de carreira');

    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
  });

  testWidgets('supports a custom decoration without a visible label', (
    tester,
  ) async {
    const decoration = InputDecoration(
      hintText: 'Digite um argumento',
      filled: true,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AppTextField(label: null, decoration: decoration)),
      ),
    );

    expect(find.text('Digite um argumento'), findsOneWidget);
    expect(find.text('Tema da Decisão'), findsNothing);
    final renderedDecoration = tester
        .widget<InputDecorator>(find.byType(InputDecorator))
        .decoration;
    expect(renderedDecoration.hintText, decoration.hintText);
    expect(renderedDecoration.filled, isTrue);
  });
}
