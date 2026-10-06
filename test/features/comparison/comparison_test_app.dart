import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tradeoff_analyzer_mobile/dependency_injection/dependency_injection.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/comparison_routes.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/views/comparison_start_page.dart';
import 'package:tradeoff_analyzer_mobile/routers/app_router.dart';
import 'package:tradeoff_analyzer_mobile/routers/app_routes.dart';

void setUpComparisonApp() {
  setUp(() async {
    await GetIt.instance.reset();
    await registerDependencies();
  });
  tearDown(() async => GetIt.instance.reset());
}

Future<void> openApp(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> openTheme(WidgetTester tester) async {
  await openApp(tester);
  await tester.tap(find.text('Nova comparação'));
  await tester.pumpAndSettle();
}

Future<void> openPros(WidgetTester tester, String theme) async {
  await openApp(tester);
  Navigator.pushNamed(
    tester.element(find.byType(ComparisonStartPage)),
    ComparisonRoutes.pros,
    arguments: theme,
  );
  await tester.pumpAndSettle();
}

void setViewport(WidgetTester tester, Size size, {double keyboardHeight = 0}) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  tester.view.viewInsets = FakeViewPadding(bottom: keyboardHeight);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetViewInsets);
}
