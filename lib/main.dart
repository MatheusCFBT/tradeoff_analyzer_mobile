import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tradeoff_analyzer_mobile/dependency_injection/dependency_injection.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/views/comparison_start_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await registerDependencies();
  runApp(ComparisonStartPage(viewModel: GetIt.instance.get()));
}
