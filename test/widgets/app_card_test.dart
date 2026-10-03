import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_card.dart';

void main() {
  testWidgets('renders child with configurable card styling', (tester) async {
    const padding = EdgeInsets.all(16);
    const borderRadius = BorderRadius.all(Radius.circular(12));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppCard(
            padding: padding,
            elevation: 3,
            borderRadius: borderRadius,
            child: Text('Reusable content'),
          ),
        ),
      ),
    );

    expect(find.text('Reusable content'), findsOneWidget);

    final card = tester.widget<Card>(find.byType(Card));
    expect(card.elevation, 3);
    expect(card.margin, EdgeInsets.zero);
    expect(
      card.shape,
      const RoundedRectangleBorder(borderRadius: borderRadius),
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Padding && widget.padding == padding,
      ),
      findsOneWidget,
    );
  });
}
