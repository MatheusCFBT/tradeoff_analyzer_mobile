import 'package:flutter/material.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/comparison_routes.dart';
import 'package:tradeoff_analyzer_mobile/routers/app_routes.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic> comparisonThemeRoute({
    required void Function(String theme) onContinue,
  }) {
    return ComparisonRoutes.themeRoute(onContinue: onContinue);
  }

  static Route<dynamic> comparisonProsRoute({required String theme}) {
    return ComparisonRoutes.prosRoute(theme: theme);
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
      case AppRoutes.comparisonStart:
        return ComparisonRoutes.startRoute();
      case AppRoutes.comparisonTheme:
        return comparisonThemeRoute(
          onContinue: (theme) {
            final context = navigatorKey.currentContext;
            if (context == null) {
              return;
            }

            Navigator.of(context).push(comparisonProsRoute(theme: theme));
          },
        );
      case AppRoutes.comparisonPros:
        final theme = settings.arguments;
        if (theme is! String || theme.trim().isEmpty) {
          return _errorRoute();
        }

        return comparisonProsRoute(theme: theme);
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute<void>(
      builder: (_) =>
          const Scaffold(body: Center(child: Text('Rota não encontrada'))),
    );
  }
}
