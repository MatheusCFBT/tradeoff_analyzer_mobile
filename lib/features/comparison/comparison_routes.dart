import 'presentation/comparison_cons/comparison_cons_arguments.dart';
import 'presentation/comparison_cons/viewmodels/comparison_cons_viewmodel.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_cons/views/comparison_cons_page.dart';
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
  static const String cons = '/comparison/cons';

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
      case cons:
        final arguments = settings.arguments;
        final String decisionTheme;
        final ComparisonConsViewModel viewModel;
        final bool ownsViewModel;
        if (arguments is ComparisonConsArguments) {
          decisionTheme = arguments.theme;
          if (decisionTheme.trim().isEmpty) return null;
          viewModel = arguments.viewModel;
          ownsViewModel = false;
        } else if (arguments is String && arguments.trim().isNotEmpty) {
          decisionTheme = arguments;
          viewModel = GetIt.instance.get<ComparisonConsViewModel>();
          ownsViewModel = true;
        } else {
          return null;
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => ComparisonConsPage(
            theme: decisionTheme,
            viewModel: viewModel,
            disposeViewModel: ownsViewModel,
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
