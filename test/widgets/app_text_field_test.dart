import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_text_field.dart';

void main() {
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
}
