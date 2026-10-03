import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(24.0),
    this.margin = EdgeInsets.zero,
    this.color = Colors.white,
    this.elevation = 0,
    this.borderRadius = const BorderRadius.all(Radius.circular(24.0)),
    this.shape,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? color;
  final double elevation;
  final BorderRadiusGeometry borderRadius;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: elevation,
      margin: margin,
      shape: shape ?? RoundedRectangleBorder(borderRadius: borderRadius),
      child: Padding(padding: padding, child: child),
    );
  }
}
