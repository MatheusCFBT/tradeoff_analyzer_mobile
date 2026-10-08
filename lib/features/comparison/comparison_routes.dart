import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_cons/views/comparison_cons_page.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_pros/viewmodels/comparison_pros_viewmodel.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_pros/views/comparison_pros_page.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/viewmodels/comparison_start_viewmodel.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/views/comparison_start_page.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_theme/views/comparison_theme_page.dart';

import 'models/comparison_draft_model.dart';
import 'presentation/comparison_cons/comparison_cons_route_arguments_model.dart';
import 'presentation/comparison_cons/viewmodels/comparison_cons_viewmodel.dart';
import 'models/comparison_navigation_result_model.dart';
import 'models/comparison_review_route_arguments_model.dart';
import 'presentation/comparison_review/viewmodels/comparison_review_viewmodel.dart';
import 'presentation/comparison_review/views/comparison_review_page.dart';

class ComparisonRoutes {
  static const String start = '/comparison/start';
  static const String theme = '/comparison/theme';
  static const String pros = '/comparison/pros';
  static const String cons = '/comparison/cons';
  static const String review = '/comparison/review';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case start:
        return startRoute(settings);
      case theme:
        return _themeRoute(settings);
      case pros:
        return _prosRoute(settings);
      case cons:
        return _consRoute(settings);
      case review:
        return _reviewRoute(settings);
      default:
        return null;
    }
  }

  static Route<void> _themeRoute(RouteSettings settings) {
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
  }

  static Route<ComparisonNavigationResultModel>? _prosRoute(
    RouteSettings settings,
  ) {
    final arguments = settings.arguments;
    final draft = switch (arguments) {
      ComparisonDraftModel() => arguments,
      String() => ComparisonDraftModel(theme: arguments),
      _ => null,
    };
    if (draft == null || draft.theme.trim().isEmpty) return null;
    return MaterialPageRoute<ComparisonNavigationResultModel>(
      settings: settings,
      builder: (_) => ComparisonProsPage(
        theme: draft.theme,
        draft: draft,
        viewModel: GetIt.instance.get<ComparisonProsViewModel>(),
      ),
    );
  }

  static Route<ComparisonNavigationResultModel>? _consRoute(
    RouteSettings settings,
  ) {
    final arguments = settings.arguments;
    final draft = switch (arguments) {
      ComparisonConsRouteArgumentsModel(:final draft) => draft,
      String() => ComparisonDraftModel(theme: arguments),
      _ => null,
    };
    if (draft == null || draft.theme.trim().isEmpty) return null;
    return MaterialPageRoute<ComparisonNavigationResultModel>(
      settings: settings,
      builder: (_) => ComparisonConsPage(
        theme: draft.theme,
        draft: draft,
        hasProsStep:
            arguments is ComparisonConsRouteArgumentsModel &&
            arguments.hasProsStep,
        viewModel: GetIt.instance.get<ComparisonConsViewModel>(),
      ),
    );
  }

  static Route<ComparisonNavigationResultModel>? _reviewRoute(
    RouteSettings settings,
  ) {
    final arguments = settings.arguments;
    if (arguments is! ComparisonReviewRouteArgumentsModel ||
        arguments.draft.theme.trim().isEmpty) {
      return null;
    }
    return MaterialPageRoute<ComparisonNavigationResultModel>(
      settings: settings,
      builder: (_) => ComparisonReviewPage(
        arguments: arguments,
        viewModel: GetIt.instance.get<ComparisonReviewViewModel>(),
      ),
    );
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
