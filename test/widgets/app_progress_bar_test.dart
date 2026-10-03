import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_progress_bar.dart';

void main() {
  testWidgets('forwards progress and configurable appearance to indicator', (
    tester,
  ) async {
    const progressColor = Color(0xFF004353);
    const trackColor = Color(0xFFD9E5EA);
    const borderRadius = BorderRadius.all(Radius.circular(3));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppProgressBar(
            value: 0.25,
            height: 4,
            progressColor: progressColor,
            trackColor: trackColor,
            borderRadius: borderRadius,
            semanticLabel: 'Etapa 1 de 4',
          ),
        ),
      ),
    );

    final indicator = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(indicator.value, 0.25);
    expect(indicator.minHeight, 4);
    expect(indicator.color, progressColor);
    expect(indicator.backgroundColor, trackColor);
    expect(indicator.borderRadius, borderRadius);
    expect(indicator.semanticsLabel, 'Etapa 1 de 4');
  });

  testWidgets('supports indeterminate progress when value is omitted', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AppProgressBar())),
    );

    final indicator = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(indicator.value, isNull);
  });
}
