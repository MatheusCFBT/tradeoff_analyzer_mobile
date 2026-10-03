import 'package:flutter/material.dart';
import 'package:tradeoff_analyzer_mobile/dependency_injection/dependency_injection.dart';
import 'package:tradeoff_analyzer_mobile/routers/app_router.dart';
import 'package:tradeoff_analyzer_mobile/routers/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await registerDependencies();
  runApp(
    MaterialApp(
      navigatorKey: AppRouter.navigatorKey,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    ),
  );
}
