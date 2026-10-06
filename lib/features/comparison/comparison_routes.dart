import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_pros/viewmodels/comparison_pros_viewmodel.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_pros/views/comparison_pros_page.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/viewmodels/comparison_start_viewmodel.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/views/comparison_start_page.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_theme/views/comparison_theme_page.dart';

class ComparisonRoutes {
  static const String start = '/comparison/start';
  static const String theme = '/comparison/theme';
  static const String pros = '/comparison/pros';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case start:
        return startRoute(settings);
      case theme:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const ComparisonThemePage(
            circleAvatar: CircleAvatar(
              radius: 32,
              backgroundColor: Color(0xFFEAF5FC),
              child: Icon(
                Icons.psychology_outlined,
                size: 32,
                color: Color(0xFF245B6B),
              ),
            ),
          ),
        );
      case pros:
        final decisionTheme = settings.arguments;
        if (decisionTheme is! String || decisionTheme.trim().isEmpty) {
          return null;
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => ComparisonProsPage(
            theme: decisionTheme,
            viewModel: GetIt.instance.get<ComparisonProsViewModel>(),
          ),
        );
      default:
        return null;
    }
  }

  static Route<dynamic> startRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => ComparisonStartPage(
        viewModel: GetIt.instance.get<ComparisonStartViewModel>(),
      ),
    );
  }
}
