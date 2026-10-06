import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_text_field.dart';

import 'comparison_test_app.dart';

void main() {
  setUpComparisonApp();

  Future<void> submit(WidgetTester tester, String value) async {
    await tester.enterText(find.byType(AppTextField), value);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
  }

  Finder dialogText(String text) =>
      find.descendant(of: find.byType(AlertDialog), matching: find.text(text));
  Finder editSheet() => find.ancestor(
    of: find.text('Editar Argumento'),
    matching: find.byType(BottomSheet),
  );
  Finder editText(String text) =>
      find.descendant(of: editSheet(), matching: find.text(text));
  Finder editField() =>
      find.descendant(of: editSheet(), matching: find.byType(TextFormField));

  void expectBlurredBackground(WidgetTester tester, Finder foreground) {
    final barrier = find.byType(ModalBarrier).last;
    expect(tester.widget<ModalBarrier>(barrier).color!.a, greaterThan(0));
    final filter = find.ancestor(
      of: barrier,
      matching: find.byType(BackdropFilter),
    );
    expect(filter, findsOneWidget);
    expect(
      tester.widget<BackdropFilter>(filter).filter.toString(),
      contains('blur'),
    );
    expect(
      find.ancestor(of: foreground, matching: find.byType(BackdropFilter)),
      findsNothing,
    );
  }

  for (final cons in [false, true]) {
    Future<void> openPage(WidgetTester tester) async {
      setViewport(tester, const Size(800, 800));
      await openPros(tester, 'Mudar de carreira');
      if (cons) {
        await tester.tap(find.text('Próximo Passo'));
        await tester.pumpAndSettle();
      }
    }

    testWidgets(
      'opens management from card with blur and blocks background: cons=$cons',
      (tester) async {
        await openPage(tester);
        await submit(tester, 'Argumento');
        await tester.enterText(find.byType(AppTextField), 'Rascunho');
        final nextPosition = tester.getCenter(find.text('Próximo Passo'));
        final card = find.ancestor(
          of: find.text('Argumento'),
          matching: find.byType(InkWell),
        );
        await tester.tapAt(tester.getTopLeft(card) + const Offset(8, 8));
        await tester.pumpAndSettle();
        expect(find.text('Gerenciar Argumento'), findsOneWidget);
        expect(find.text('Editar'), findsOneWidget);
        expect(find.text('Remover'), findsOneWidget);
        expect(tester.testTextInput.isVisible, isFalse);
        expectBlurredBackground(tester, find.byType(BottomSheet));
        await tester.tapAt(nextPosition);
        await tester.pumpAndSettle();
        expect(
          find.text(cons ? 'Contras Adicionados' : 'Prós Adicionados'),
          findsOneWidget,
        );
        expect(find.text('Gerenciar Argumento'), findsNothing);
        expect(
          tester
              .widget<AppTextField>(find.byType(AppTextField))
              .controller!
              .text,
          'Rascunho',
        );
      },
    );

    testWidgets(
      'edits only selected duplicate, trims and validates blank input: cons=$cons',
      (tester) async {
        await openPage(tester);
        await submit(tester, 'Duplicado');
        await submit(tester, 'Meio');
        await submit(tester, 'Duplicado');
        await tester.enterText(find.byType(AppTextField), 'Rascunho');
        await tester.ensureVisible(find.text('Duplicado').last);
        await tester.tap(find.text('Duplicado').last);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Editar'));
        await tester.pumpAndSettle();
        expect(editText('Editar Argumento'), findsOneWidget);
        expect(
          tester.widget<TextFormField>(editField()).controller!.text,
          'Duplicado',
        );
        expectBlurredBackground(tester, editSheet());
        for (final blank in ['', '   ']) {
          await tester.enterText(editField(), blank);
          await tester.tap(editText('Salvar Alterações'));
          await tester.pumpAndSettle();
          expect(editText('Informe o argumento.'), findsOneWidget);
        }
        await tester.enterText(editField(), '  Alterado  ');
        await tester.tap(editText('Salvar Alterações'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
        expect(find.text('Gerenciar Argumento'), findsNothing);
        expect(find.text('Duplicado'), findsOneWidget);
        expect(find.text('Alterado'), findsOneWidget);
        expect(find.text('3 Itens'), findsOneWidget);
        expect(
          tester
              .widget<AppTextField>(find.byType(AppTextField))
              .controller!
              .text,
          'Rascunho',
        );
        expect(
          tester.getTopLeft(find.text('Duplicado')).dy,
          lessThan(tester.getTopLeft(find.text('Meio')).dy),
        );
        expect(
          tester.getTopLeft(find.text('Meio')).dy,
          lessThan(tester.getTopLeft(find.text('Alterado')).dy),
        );
      },
    );

    testWidgets(
      'deletes selected duplicate and last item after confirmation: cons=$cons',
      (tester) async {
        await openPage(tester);
        await submit(tester, 'Duplicado');
        await submit(tester, 'Meio');
        await submit(tester, 'Duplicado');
        await tester.enterText(find.byType(AppTextField), 'Rascunho');
        for (final remaining in [2, 1, 0]) {
          final selected = find
              .text(remaining == 0 ? 'Meio' : 'Duplicado')
              .last;
          await tester.ensureVisible(selected);
          await tester.tap(selected);
          await tester.pumpAndSettle();
          await tester.tap(find.text('Remover'));
          await tester.pumpAndSettle();
          expect(dialogText('Remover Argumento?'), findsOneWidget);
          expectBlurredBackground(tester, find.byType(AlertDialog));
          await tester.tap(dialogText('Excluir'));
          await tester.pumpAndSettle();
          expect(find.text('Gerenciar Argumento'), findsNothing);
          expect(
            find.text('Duplicado'),
            remaining == 2 ? findsOneWidget : findsNothing,
          );
          expect(
            find.text('$remaining ${remaining == 1 ? 'Item' : 'Itens'}'),
            findsOneWidget,
          );
          if (remaining == 2) {
            expect(
              tester.getTopLeft(find.text('Duplicado')).dy,
              lessThan(tester.getTopLeft(find.text('Meio')).dy),
            );
          }
          expect(
            tester
                .widget<AppTextField>(find.byType(AppTextField))
                .controller!
                .text,
            'Rascunho',
          );
        }
      },
    );

    for (final dismiss in ['cancel', 'outside', 'system']) {
      testWidgets(
        'dismisses management without changes: cons=$cons, $dismiss',
        (tester) async {
          await openPage(tester);
          await submit(tester, 'Argumento');
          await tester.tap(find.text('Argumento'));
          await tester.pumpAndSettle();
          if (dismiss == 'cancel') {
            await tester.tap(find.text('Cancelar'));
          } else if (dismiss == 'outside') {
            await tester.tapAt(const Offset(10, 10));
          } else {
            await tester.binding.handlePopRoute();
          }
          await tester.pumpAndSettle();
          expect(find.text('Gerenciar Argumento'), findsNothing);
          expect(find.text('Argumento'), findsOneWidget);
          expect(find.text('1 Item'), findsOneWidget);
        },
      );

      for (final action in ['Editar', 'Remover']) {
        testWidgets(
          'returns one modal without changes: cons=$cons, $action, $dismiss',
          (tester) async {
            await openPage(tester);
            await submit(tester, 'Argumento');
            await tester.tap(find.text('Argumento'));
            await tester.pumpAndSettle();
            await tester.tap(find.text(action));
            await tester.pumpAndSettle();
            expectBlurredBackground(
              tester,
              action == 'Editar' ? editSheet() : find.byType(AlertDialog),
            );
            if (action == 'Editar') {
              await tester.enterText(editField(), 'Não salvo');
            }
            if (dismiss == 'cancel') {
              await tester.tap(
                action == 'Editar'
                    ? editText('Cancelar')
                    : dialogText('Cancelar'),
              );
            } else if (dismiss == 'outside') {
              await tester.tapAt(const Offset(10, 10));
            } else {
              await tester.binding.handlePopRoute();
            }
            await tester.pumpAndSettle();
            expect(find.byType(AlertDialog), findsNothing);
            expect(find.text('Gerenciar Argumento'), findsOneWidget);
            await tester.tap(find.text('Cancelar'));
            await tester.pumpAndSettle();
            expect(find.text('Argumento'), findsOneWidget);
            expect(find.text('Não salvo'), findsNothing);
            expect(find.text('1 Item'), findsOneWidget);
          },
        );
      }
    }

    testWidgets(
      'edit bottom sheet matches reference and cancels by drag: cons=$cons',
      (tester) async {
        await openPage(tester);
        await submit(tester, 'Argumento');
        await tester.tap(find.text('Argumento'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Editar'));
        await tester.pumpAndSettle();
        expect(editSheet(), findsOneWidget);
        expect(find.byType(AlertDialog), findsNothing);
        expect(editText('Edite o texto do seu argumento'), findsOneWidget);
        expect(
          find.descendant(
            of: editSheet(),
            matching: find.byWidgetPredicate(
              (widget) => widget is Text && widget.data == 'Argumento',
            ),
          ),
          findsOneWidget,
        );
        expect(find.textContaining('140'), findsNothing);
        final field = tester.widget<TextFormField>(editField());
        expect(field.controller!.text, 'Argumento');
        final input = tester.widget<TextField>(
          find.descendant(of: editSheet(), matching: find.byType(TextField)),
        );
        expect(input.maxLength, isNull);
        expect(input.maxLines, greaterThan(1));
        final cancel = find.descendant(
          of: editSheet(),
          matching: find.byType(OutlinedButton),
        );
        final save = find.descendant(
          of: editSheet(),
          matching: find.byType(ElevatedButton),
        );
        expect(tester.getSize(cancel), tester.getSize(save));
        expect(tester.getTopLeft(cancel).dy, tester.getTopLeft(save).dy);
        expectBlurredBackground(tester, editSheet());
        await tester.enterText(editField(), 'Não salvo');
        await tester.drag(editSheet(), const Offset(0, 500));
        await tester.pumpAndSettle();
        expect(editSheet(), findsNothing);
        expect(find.text('Gerenciar Argumento'), findsOneWidget);
        await tester.tap(find.text('Cancelar'));
        await tester.pumpAndSettle();
        expect(find.text('Argumento'), findsOneWidget);
        expect(find.text('Não salvo'), findsNothing);
      },
    );

    testWidgets('saves edits longer than 140 without truncation: cons=$cons', (
      tester,
    ) async {
      await openPage(tester);
      await submit(tester, 'Argumento');
      await tester.tap(find.text('Argumento'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Editar'));
      await tester.pumpAndSettle();
      final text = List.filled(20, 'Argumento longo').join(' ');
      await tester.enterText(editField(), text);
      await tester.tap(editText('Salvar Alterações'));
      await tester.pumpAndSettle();
      expect(find.text(text), findsOneWidget);
      expect(find.text('Gerenciar Argumento'), findsNothing);
    });

    testWidgets('drag dismisses management: cons=$cons', (tester) async {
      await openPage(tester);
      await submit(tester, 'Argumento');
      await tester.tap(find.text('Argumento'));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(BottomSheet), const Offset(0, 500));
      await tester.pumpAndSettle();
      expect(find.text('Gerenciar Argumento'), findsNothing);
      expect(find.text('Argumento'), findsOneWidget);
    });

    testWidgets('long edit fits small screen with keyboard: cons=$cons', (
      tester,
    ) async {
      await openPage(tester);
      final text = List.filled(15, 'Um argumento longo').join(' ');
      await submit(tester, text);
      setViewport(tester, const Size(320, 600));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text(text));
      await tester.tap(find.text(text));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Editar'));
      await tester.pumpAndSettle();
      tester.view.viewInsets = const FakeViewPadding(bottom: 250);
      await tester.pumpAndSettle();
      await tester.enterText(editField(), '   ');
      await tester.ensureVisible(editText('Salvar Alterações'));
      expect(
        tester.getBottomRight(editText('Salvar Alterações')).dy,
        lessThanOrEqualTo(350),
      );
      await tester.tap(editText('Salvar Alterações'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(editText('Informe o argumento.'));
      expect(editText('Informe o argumento.').hitTestable(), findsOneWidget);
      await tester.enterText(editField(), 'Atualizado');
      await tester.ensureVisible(editText('Salvar Alterações'));
      expect(
        tester.getBottomRight(editText('Salvar Alterações')).dy,
        lessThanOrEqualTo(350),
      );
      await tester.tap(editText('Salvar Alterações'));
      await tester.pumpAndSettle();
      expect(find.text('Atualizado'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('cons edits and removal survive return and reentry', (
    tester,
  ) async {
    setViewport(tester, const Size(800, 800));
    await openPros(tester, 'Tema');
    await submit(tester, 'Pró');
    await tester.tap(find.text('Próximo Passo'));
    await tester.pumpAndSettle();
    await submit(tester, 'Contra');
    await submit(tester, 'Remover este');
    await tester.tap(find.text('Contra'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    await tester.enterText(editField(), 'Contra editado');
    await tester.tap(editText('Salvar Alterações'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remover este'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remover'));
    await tester.pumpAndSettle();
    await tester.tap(dialogText('Excluir'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Pró'), findsOneWidget);
    await tester.tap(find.text('Próximo Passo'));
    await tester.pumpAndSettle();
    expect(find.text('Contra editado'), findsOneWidget);
    expect(find.text('Remover este'), findsNothing);
    expect(find.text('1 Item'), findsOneWidget);
  });
}
