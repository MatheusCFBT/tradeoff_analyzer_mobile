import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/viewmodels/comparison_start_viewmodel.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/views/comparison_start_page.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_theme/views/comparison_theme_page.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_header.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/repositories/comparison_repository_interface.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_base_scaffold.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_primary_button.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_progress_bar.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/empty_state_content.dart';

void main() {
  testWidgets('AppBaseScaffold shows progress only when enabled', (
    tester,
  ) async {
    final progress = ValueNotifier<double>(0.25);

    await tester.pumpWidget(
      MaterialApp(
        home: AppBaseScaffold(
          body: const Text('Body'),
          progress: progress,
          showProgressBar: true,
        ),
      ),
    );

    final indicatorFinder = find.byType(LinearProgressIndicator);
    expect(indicatorFinder, findsOneWidget);
    expect(tester.widget<LinearProgressIndicator>(indicatorFinder).value, 0.25);

    progress.value = 0.5;
    await tester.pump();
    expect(tester.widget<LinearProgressIndicator>(indicatorFinder).value, 0.5);

    await tester.pumpWidget(
      MaterialApp(home: AppBaseScaffold(body: const Text('Body'))),
    );
    expect(indicatorFinder, findsNothing);
    progress.dispose();
  });

  testWidgets('shows the start comparison content without a card', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ComparisonStartPage(
          viewModel: ComparisonStartViewModel(
            repository: _FakeComparisonRepository(),
          ),
        ),
      ),
    );

    expect(find.text('Comece sua primeira decisão'), findsOneWidget);
    expect(find.textContaining('organizar prós e contras'), findsOneWidget);
    expect(find.text('Nova comparação'), findsOneWidget);
    expect(find.byType(Card), findsNothing);

    final buttonLabel = tester.widget<Text>(find.text('Nova comparação'));
    expect(buttonLabel.style?.color, Colors.white);
  });

  testWidgets('AppPrimaryButton accepts a custom text color', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppPrimaryButton(
            label: 'Custom color',
            onPressed: null,
            textColor: Colors.red,
          ),
        ),
      ),
    );

    final label = tester.widget<Text>(find.text('Custom color'));
    expect(label.style?.color, Colors.red);
  });

  testWidgets('EmptyStateContent omits the avatar when it is not provided', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyStateContent(title: 'Title', description: 'Description'),
        ),
      ),
    );

    expect(find.byType(CircleAvatar), findsNothing);
  });

  testWidgets('shows and validates the decision theme card', (tester) async {
    String? submittedTheme;

    await tester.pumpWidget(
      MaterialApp(
        home: ComparisonThemePage(
          circleAvatar: const CircleAvatar(),
          onContinue: (theme) => submittedTheme = theme,
        ),
      ),
    );

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

    await tester.tap(find.text('Continuar'));
    await tester.pump();
    expect(find.text('Informe o tema da decisão.'), findsOneWidget);
    expect(submittedTheme, isNull);

    await tester.enterText(find.byType(TextFormField), 'Mudar de carreira');
    await tester.tap(find.text('Continuar'));
    await tester.pump();
    expect(submittedTheme, 'Mudar de carreira');
  });

  testWidgets('opens the decision theme page from the start page', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ComparisonStartPage(
          viewModel: ComparisonStartViewModel(
            repository: _FakeComparisonRepository(),
          ),
        ),
      ),
    );

    final startButton = tester.widget<AppPrimaryButton>(
      find.byType(AppPrimaryButton),
    );
    startButton.onPressed!();
    await tester.pumpAndSettle();

    expect(find.text('Sobre o que é esta decisão?'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Sobre o que é esta decisão?'), findsNothing);
    expect(find.text('Comece sua primeira decisão'), findsOneWidget);
  });

  testWidgets(
    'continues to the arguments page with the entered decision theme',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ComparisonStartPage(
            viewModel: ComparisonStartViewModel(
              repository: _FakeComparisonRepository(),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Nova comparação'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Mudança de Carreira');
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      expect(find.text('Decisão Atual'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      final progressBar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(progressBar.value, 0.5);
      expect(progressBar.minHeight, 3);
      expect(find.text('Mudança de Carreira'), findsOneWidget);
      expect(find.text('Adicionar Argumento Favorável'), findsOneWidget);
      expect(find.text('O que pesa a favor dessa decisão?'), findsOneWidget);
      expect(
        find.text('Ex: Melhor salário, Novos desafios...'),
        findsOneWidget,
      );

      final backButton = tester.widget<TextButton>(find.byType(TextButton));
      final backButtonSize = tester.getSize(find.byType(TextButton));
      final nextButtonSize = tester.getSize(find.byType(ElevatedButton));
      expect(backButtonSize.width, nextButtonSize.width);
      expect(backButtonSize.height, nextButtonSize.height);
      expect(backButton.style?.side, isNull);

      await tester.tap(find.text('Próximo Passo'));
      await tester.pumpAndSettle();
      expect(find.text('Decisão Atual'), findsOneWidget);

      await tester.tap(find.text('Voltar'));
      await tester.pumpAndSettle();
      expect(find.text('Sobre o que é esta decisão?'), findsOneWidget);
      expect(
        tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator)).value,
        0.25,
      );
      expect(
        tester.widget<TextFormField>(find.byType(TextFormField)).controller?.text,
        'Mudança de Carreira',
      );
    },
  );
}

class _FakeComparisonRepository implements IComparisonRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
