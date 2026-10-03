import 'package:flutter/material.dart';

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    this.value,
    this.height = 4.0,
    this.progressColor = const Color(0xFF004353),
    this.trackColor = const Color(0xFFD9E5EA),
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.semanticLabel,
    super.key,
  });

  final double? value;
  final double height;
  final Color progressColor;
  final Color trackColor;
  final BorderRadiusGeometry borderRadius;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: LinearProgressIndicator(
        value: value,
        minHeight: height,
        color: progressColor,
        backgroundColor: trackColor,
        borderRadius: borderRadius,
        semanticsLabel: semanticLabel,
      ),
    );
  }
}
