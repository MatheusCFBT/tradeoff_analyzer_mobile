import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_text_field.dart';

import 'package:tradeoff_analyzer_mobile/features/comparison/models/comparison_draft_model.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/models/comparison_review_route_arguments_model.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/views/comparison_start_page.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_pros/views/comparison_pros_page.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_cons/views/comparison_cons_page.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_review/views/comparison_review_page.dart';
import 'comparison_test_app.dart';

Future<void> editSection(WidgetTester tester, String title) async {
  final handle = tester.ensureSemantics();
  await tester.pump();
  final button = find.descendant(
    of: find.byWidgetPredicate(
      (widget) =>
          widget is Semantics && widget.properties.label == 'Editar $title',
    ),
    matching: find.byType(TextButton),
  );
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pumpAndSettle();
  handle.dispose();
}

Future<void> openDirectReview(
  WidgetTester tester,
  ComparisonDraftModel draft,
) async {
  await openApp(tester);
  Navigator.pushNamed(
    tester.element(find.byType(ComparisonStartPage)),
    '/comparison/review',
    arguments: ComparisonReviewRouteArgumentsModel(draft: draft),
  );
  await tester.pumpAndSettle();
}

Future<void> submitArgument(WidgetTester tester, String value) async {
  await tester.enterText(find.byType(AppTextField), value);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump();
}

Future<void> next(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Próximo Passo'));
  await tester.tap(find.text('Próximo Passo'));
  await tester.pumpAndSettle();
}

Future<void> openReview(WidgetTester tester) async {
  await openPros(tester, 'Mudar de carreira');
  await submitArgument(tester, 'Melhor salário');
  await submitArgument(tester, 'Melhor salário');
  await next(tester);
  await submitArgument(tester, 'Perda de estabilidade');
  await next(tester);
}

void main() {
  setUpComparisonApp();

  testWidgets('reviews all arguments by category and disables finish', (
    tester,
  ) async {
    await openReview(tester);
    expect(find.text('Revisar Decisão'), findsOneWidget);
    expect(find.text('Revise os detalhes antes de finalizar.'), findsOneWidget);
    expect(find.text('Tema da Decisão'), findsOneWidget);
    expect(find.text('Prós'), findsOneWidget);
    expect(find.text('Contras'), findsOneWidget);
    expect(find.text('Melhor salário'), findsNWidgets(2));
    expect(find.text('Perda de estabilidade'), findsOneWidget);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      1,
    );
    final finish = find.widgetWithText(ElevatedButton, 'Finalizar Decisão');
    expect(tester.widget<ElevatedButton>(finish).onPressed, isNull);
    expect(
      ModalRoute.of(
        tester.element(find.text('Revisar Decisão')),
      )!.settings.name,
      '/comparison/review',
    );
  });

  testWidgets(
    'editing categories returns to existing steps with standard buttons',
    (tester) async {
      await openReview(tester);
      await editSection(tester, 'Prós');
      await tester.pumpAndSettle();
      expect(find.text('Prós Adicionados'), findsOneWidget);
      expect(find.text('Concluir Edição'), findsNothing);
      await submitArgument(tester, 'Novos desafios');
      await next(tester);
      expect(find.text('Perda de estabilidade'), findsOneWidget);
      await next(tester);
      expect(find.text('Novos desafios'), findsOneWidget);
      await editSection(tester, 'Contras');
      await tester.pumpAndSettle();
      await submitArgument(tester, 'Menor previsibilidade');
      await next(tester);
      expect(find.text('Menor previsibilidade'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Contras Adicionados'), findsOneWidget);
      await tester.tap(find.text('Voltar'));
      await tester.pumpAndSettle();
      expect(find.text('Prós Adicionados'), findsOneWidget);
      expect(find.text('Novos desafios'), findsOneWidget);
    },
  );

  testWidgets('empty categories remain distinct', (tester) async {
    await openDirectReview(tester, ComparisonDraftModel(theme: 'Decisão'));
    expect(find.text('Nenhum pró adicionado.'), findsOneWidget);
    expect(find.text('Nenhum contra adicionado.'), findsOneWidget);
    expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
    expect(find.byIcon(Icons.remove_circle_outline), findsOneWidget);
  });

  testWidgets('theme edit validates, trims and propagates to previous stages', (
    tester,
  ) async {
    await openTheme(tester);
    await tester.enterText(find.byType(AppTextField), 'Tema original');
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(AppTextField), 'Rascunho pró');
    await next(tester);
    await tester.enterText(find.byType(AppTextField), 'Rascunho contra');
    await next(tester);
    await editSection(tester, 'Tema da Decisão');
    expect(find.text('Editar Tema'), findsOneWidget);
    expect(
      tester.widget<AppTextField>(find.byType(AppTextField)).controller!.text,
      'Tema original',
    );
    expect(find.byType(BackdropFilter), findsWidgets);
    expect(find.byType(AnimatedModalBarrier), findsWidgets);
    final barrier = find.byType(ModalBarrier).last;
    expect(tester.widget<ModalBarrier>(barrier).color!.a, greaterThan(0));
    expect(
      find.ancestor(of: barrier, matching: find.byType(BackdropFilter)),
      findsOneWidget,
    );
    expect(
      find.ancestor(
        of: find.byType(BottomSheet),
        matching: find.byType(BackdropFilter),
      ),
      findsNothing,
    );
    await tester.enterText(find.byType(AppTextField), '   ');
    await tester.tap(find.text('Salvar Alterações'));
    await tester.pumpAndSettle();
    expect(find.text('Informe o tema da decisão.'), findsOneWidget);
    await tester.enterText(find.byType(AppTextField), '  Tema atualizado  ');
    await tester.tap(find.text('Salvar Alterações'));
    await tester.pumpAndSettle();
    expect(find.text('Tema atualizado'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Tema atualizado'), findsOneWidget);
    expect(
      tester.widget<AppTextField>(find.byType(AppTextField)).controller!.text,
      'Rascunho contra',
    );
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Tema atualizado'), findsOneWidget);
    expect(
      tester.widget<AppTextField>(find.byType(AppTextField)).controller!.text,
      'Rascunho pró',
    );
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(
      tester.widget<AppTextField>(find.byType(AppTextField)).controller!.text,
      'Tema atualizado',
    );
  });

  for (final cancel in ['button', 'outside', 'drag', 'system']) {
    testWidgets('theme cancellation discards changes: $cancel', (tester) async {
      await openReview(tester);
      await editSection(tester, 'Tema da Decisão');
      await tester.enterText(find.byType(AppTextField), 'Não salvar');
      switch (cancel) {
        case 'button':
          await tester.tap(find.text('Cancelar'));
        case 'outside':
          await tester.tapAt(const Offset(5, 80));
        case 'drag':
          await tester.drag(find.byType(BottomSheet), const Offset(0, 600));
        case 'system':
          await tester.binding.handlePopRoute();
      }
      await tester.pumpAndSettle();
      expect(find.text('Revisar Decisão'), findsOneWidget);
      expect(find.text('Mudar de carreira'), findsOneWidget);
      expect(find.text('Não salvar'), findsNothing);
    });
  }

  testWidgets('long lists and enlarged text are readable on small screens', (
    tester,
  ) async {
    final pros = List.generate(
      25,
      (i) =>
          'Pró $i: argumento comprido que precisa quebrar em várias linhas para continuar legível.',
    );
    final cons = List.generate(
      25,
      (i) =>
          'Contra $i: argumento comprido que precisa quebrar em várias linhas para continuar legível.',
    );
    setViewport(tester, const Size(320, 600));
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await openDirectReview(
      tester,
      ComparisonDraftModel(
        theme: 'Um tema longo para uma decisão importante',
        pros: pros,
        cons: cons,
      ),
    );
    for (final value in [...pros, ...cons]) {
      await tester.ensureVisible(find.text(value));
      await tester.pumpAndSettle();
      expect(find.text(value).hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    expect(find.text('Finalizar Decisão').hitTestable(), findsOneWidget);
  });

  testWidgets('theme sheet fits small screen and keyboard', (tester) async {
    await openReview(tester);
    setViewport(tester, const Size(320, 600), keyboardHeight: 250);
    await tester.pumpAndSettle();
    await editSection(tester, 'Tema da Decisão');
    await tester.enterText(find.byType(AppTextField), ' ');
    final save = find.text('Salvar Alterações');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Informe o tema da decisão.'));
    expect(tester.takeException(), isNull);
    await tester.enterText(
      find.byType(AppTextField),
      List.filled(15, 'Tema longo').join(' '),
    );
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(find.text('Revisar Decisão'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final target in ['Prós', 'Contras']) {
    testWidgets('direct review opens standard stage: $target', (tester) async {
      await openDirectReview(
        tester,
        ComparisonDraftModel(theme: 'Tema', pros: ['Pró'], cons: ['Contra']),
      );
      await editSection(tester, target);
      expect(
        find.text(
          target == 'Prós' ? 'Prós Adicionados' : 'Contras Adicionados',
        ),
        findsOneWidget,
      );
      await submitArgument(tester, 'Novo argumento');
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Revisar Decisão'), findsOneWidget);
      expect(find.text('Novo argumento'), findsOneWidget);
    });
  }

  for (final invalid in <Object?>[
    null,
    42,
    '',
    ComparisonReviewRouteArgumentsModel(
      draft: ComparisonDraftModel(theme: '   '),
    ),
  ]) {
    testWidgets('rejects invalid review arguments: $invalid', (tester) async {
      await openApp(tester);
      Navigator.pushNamed(
        tester.element(find.byType(ComparisonStartPage)),
        '/comparison/review',
        arguments: invalid,
      );
      await tester.pumpAndSettle();
      expect(find.text('Rota não encontrada'), findsOneWidget);
      final settings = ModalRoute.of(
        tester.element(find.text('Rota não encontrada')),
      )!.settings;
      expect(settings.arguments, same(invalid));
    });
  }

  testWidgets(
    'category editing retains duplicates and returns without duplicate stages',
    (tester) async {
      await openReview(tester);
      await editSection(tester, 'Prós');
      expect(
        find.byType(ComparisonProsPage, skipOffstage: false),
        findsOneWidget,
      );
      expect(
        find.byType(ComparisonConsPage, skipOffstage: false),
        findsNothing,
      );
      expect(
        find.byType(ComparisonReviewPage, skipOffstage: false),
        findsNothing,
      );
      await tester.ensureVisible(find.text('Melhor salário').last);
      await tester.tap(find.text('Melhor salário').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Editar'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(AppTextField).last, 'Pró editado');
      await tester.tap(find.text('Salvar Alterações'));
      await tester.pumpAndSettle();
      await next(tester);
      await tester.ensureVisible(find.text('Perda de estabilidade'));
      await tester.tap(find.text('Perda de estabilidade'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remover'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Excluir'));
      await tester.pumpAndSettle();
      await next(tester);
      expect(find.text('Melhor salário'), findsOneWidget);
      expect(find.text('Pró editado'), findsOneWidget);
      expect(find.text('Nenhum contra adicionado.'), findsOneWidget);
      expect(
        find.byType(ComparisonReviewPage, skipOffstage: false),
        findsOneWidget,
      );
      expect(
        find.byType(ComparisonConsPage, skipOffstage: false),
        findsOneWidget,
      );
    },
  );

  for (final target in ['Prós', 'Contras']) {
    for (final systemBack in [false, true]) {
      testWidgets(
        'direct review next pushes standard routes: $target, system=$systemBack',
        (tester) async {
          await openDirectReview(
            tester,
            ComparisonDraftModel(
              theme: 'Tema',
              pros: ['Pró'],
              cons: ['Contra'],
            ),
          );
          final originalRoute = ModalRoute.of(
            tester.element(find.byType(ComparisonReviewPage)),
          );
          await editSection(tester, target);
          await submitArgument(tester, 'Novo argumento');
          await next(tester);
          if (target == 'Prós') {
            expect(find.text('Contras Adicionados'), findsOneWidget);
            expect(
              ModalRoute.of(
                tester.element(find.byType(ComparisonConsPage)),
              )!.settings.name,
              '/comparison/cons',
            );
            await next(tester);
          }
          final reviewRoute = ModalRoute.of(
            tester.element(find.byType(ComparisonReviewPage)),
          );
          expect(reviewRoute!.settings.name, '/comparison/review');
          expect(reviewRoute, isNot(same(originalRoute)));
          expect(find.text('Novo argumento'), findsOneWidget);
          expect(
            find.byType(ComparisonReviewPage, skipOffstage: false),
            findsNWidgets(2),
          );
          expect(
            find.byType(ComparisonConsPage, skipOffstage: false),
            findsOneWidget,
          );
          await tester.binding.handlePopRoute();
          await tester.pumpAndSettle();
          expect(find.text('Contras Adicionados'), findsOneWidget);
          if (systemBack) {
            await tester.binding.handlePopRoute();
          } else {
            await tester.ensureVisible(find.text('Voltar'));
            await tester.tap(find.text('Voltar'));
          }
          await tester.pumpAndSettle();
          if (target == 'Prós') {
            expect(find.text('Prós Adicionados'), findsOneWidget);
            expect(find.text('Novo argumento'), findsOneWidget);
            if (systemBack) {
              await tester.binding.handlePopRoute();
            } else {
              await tester.ensureVisible(find.text('Voltar'));
              await tester.tap(find.text('Voltar'));
            }
            await tester.pumpAndSettle();
          }
          expect(find.text('Revisar Decisão'), findsOneWidget);
          expect(
            ModalRoute.of(tester.element(find.byType(ComparisonReviewPage))),
            same(originalRoute),
          );
          expect(find.text('Novo argumento'), findsOneWidget);
          expect(find.text('Pró'), findsOneWidget);
          expect(find.text('Contra'), findsOneWidget);
        },
      );
    }
  }
}
