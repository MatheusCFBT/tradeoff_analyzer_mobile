import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_pros/viewmodels/comparison_pros_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_pros/views/comparison_pros_page.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/viewmodels/comparison_start_viewmodel.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/views/comparison_start_page.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_theme/views/comparison_theme_page.dart';

class ComparisonRoutes {
  static const String start = '/comparison/start';
  static const String theme = '/comparison/theme';
  static const String pros = '/comparison/pros';

  static Route<dynamic> startRoute() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: start),
      builder: (_) => ComparisonStartPage(
        viewModel: GetIt.instance.get<ComparisonStartViewModel>(),
      ),
    );
  }

  static Route<dynamic> themeRoute({
    required void Function(String theme) onContinue,
  }) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: theme),
      builder: (_) => ComparisonThemePage(
        circleAvatar: CircleAvatar(
          radius: 32,
          backgroundColor: const Color(0xFFEAF5FC),
          child: const Icon(
            Icons.psychology_outlined,
            size: 32,
            color: Color(0xFF245B6B),
          ),
        ),
        onContinue: onContinue,
      ),
    );
  }

  static Route<dynamic> prosRoute({required String theme}) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: pros),
      builder: (_) => ComparisonProsPage(
        theme: theme,
        viewModel: GetIt.instance.get<ComparisonProsViewModel>(),
      ),
    );
  }
}
