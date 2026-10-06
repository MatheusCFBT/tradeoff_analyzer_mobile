import 'package:flutter/material.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/comparison_routes.dart';
import 'package:tradeoff_analyzer_mobile/routers/app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (settings.name == AppRoutes.home) {
      return ComparisonRoutes.startRoute(settings);
    }

    return ComparisonRoutes.onGenerateRoute(settings) ?? _errorRoute(settings);
  }

  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) =>
          const Scaffold(body: Center(child: Text('Rota não encontrada'))),
    );
  }
}
