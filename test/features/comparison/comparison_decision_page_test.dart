import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/models/comparison_draft_model.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/views/comparison_start_page.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_text_field.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/models/comparison_model.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_decision/views/comparison_decision_page.dart';
import 'comparison_test_app.dart';

Future<void> choose(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.text(label));
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

Future<void> confirm(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Confirmar Decisão'));
  await tester.tap(find.text('Confirmar Decisão'));
  await tester.pumpAndSettle();
}

Future<void> nextStep(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Próximo Passo'));
  await tester.tap(find.text('Próximo Passo'));
  await tester.pumpAndSettle();
}

Future<void> openFinalStep(WidgetTester tester) async {
  await openTheme(tester);
  await tester.enterText(find.byType(AppTextField), 'Mudança de Carreira');
  await tester.tap(find.text('Continuar'));
  await tester.pumpAndSettle();
  await nextStep(tester);
  await nextStep(tester);
  await tester.tap(find.text('Finalizar Decisão'));
  await tester.pumpAndSettle();
}

void main() {
  setUpComparisonApp();
  testWidgets('review opens decision with no selection', (tester) async {
    await openFinalStep(tester);
    expect(find.text('Qual lado tem mais peso?'), findsOneWidget);
    expect(find.text('Pender para os Prós'), findsOneWidget);
    expect(find.text('Pender para os Contras'), findsOneWidget);
    expect(find.text('Recomendado'), findsNothing);
    expect(
      tester
          .widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Confirmar Decisão'),
          )
          .onPressed,
      isNull,
    );
  });
  testWidgets('decision direct route shows theme and counts', (tester) async {
    await openApp(tester);
    final draft = ComparisonDraftModel(
      theme: 'Tema',
      pros: ['A', 'B'],
      cons: ['C'],
    );
    Navigator.pushNamed(
      tester.element(find.byType(ComparisonStartPage)),
      '/comparison/decision',
      arguments: draft,
    );
    await tester.pumpAndSettle();
    expect(find.text('Qual lado tem mais peso?'), findsOneWidget);
    expect(find.text('2 argumentos favoráveis'), findsOneWidget);
    expect(find.text('1 argumento desfavorável'), findsOneWidget);
    final settings = ModalRoute.of(
      tester.element(find.text('Qual lado tem mais peso?')),
    )!.settings;
    expect(settings.name, '/comparison/decision');
    expect(settings.arguments, same(draft));
  });

  testWidgets('selection is exclusive and can change without completing', (
    tester,
  ) async {
    await openFinalStep(tester);
    expect(find.text('0 argumentos favoráveis'), findsOneWidget);
    expect(find.text('0 argumentos desfavoráveis'), findsOneWidget);
    await choose(tester, 'Pender para os Prós');
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(
      tester
          .widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Confirmar Decisão'),
          )
          .onPressed,
      isNotNull,
    );
    await choose(tester, 'Pender para os Contras');
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    final selected = tester.widget<Semantics>(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.selected == true,
      ),
    );
    expect(selected.properties.label, contains('Pender para os Contras'));
    expect(find.text('Qual lado tem mais peso?'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Revisar Decisão'), findsOneWidget);
    await tester.tap(find.text('Finalizar Decisão'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Confirmar Decisão'),
          )
          .onPressed,
      isNull,
    );
  });

  for (final side in [SelectedSide.pros, SelectedSide.cons]) {
    testWidgets('confirmation keeps decision open for $side', (tester) async {
      await openFinalStep(tester);
      await choose(
        tester,
        side == SelectedSide.pros
            ? 'Pender para os Prós'
            : 'Pender para os Contras',
      );
      await confirm(tester);
      expect(find.byType(ComparisonDecisionPage), findsOneWidget);
      expect(find.text('Qual lado tem mais peso?'), findsOneWidget);
      final page = tester.widget<ComparisonDecisionPage>(
        find.byType(ComparisonDecisionPage),
      );
      expect(page.viewModel.completedComparison!.selectedSide, side);
      expect(
        page.viewModel.completedComparison!.draft.theme,
        'Mudança de Carreira',
      );
      expect(
        tester
            .widget<ElevatedButton>(
              find.widgetWithText(ElevatedButton, 'Confirmar Decisão'),
            )
            .onPressed,
        isNull,
      );
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Revisar Decisão'), findsOneWidget);
    });
  }

  for (final invalid in <Object?>[
    null,
    42,
    'Tema',
    ComparisonDraftModel(theme: '   '),
  ]) {
    testWidgets('rejects invalid decision argument: $invalid', (tester) async {
      await openApp(tester);
      Navigator.pushNamed(
        tester.element(find.byType(ComparisonStartPage)),
        '/comparison/decision',
        arguments: invalid,
      );
      await tester.pumpAndSettle();
      expect(find.text('Rota não encontrada'), findsOneWidget);
      final settings = ModalRoute.of(
        tester.element(find.text('Rota não encontrada')),
      )!.settings;
      expect(settings.name, '/comparison/decision');
      expect(settings.arguments, same(invalid));
    });
  }

  testWidgets('long theme and enlarged text fit small screen', (tester) async {
    setViewport(tester, const Size(320, 600));
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await openApp(tester);
    Navigator.pushNamed(
      tester.element(find.byType(ComparisonStartPage)),
      '/comparison/decision',
      arguments: ComparisonDraftModel(
        theme: List.filled(20, 'Decisão longa').join(' '),
      ),
    );
    await tester.pumpAndSettle();
    await choose(tester, 'Pender para os Contras');
    await tester.ensureVisible(find.text('Confirmar Decisão'));
    await tester.pumpAndSettle();
    expect(find.text('Confirmar Decisão').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
