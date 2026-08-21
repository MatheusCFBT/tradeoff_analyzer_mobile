import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/viewmodels/comparison_start_viewmodel.dart';

class ComparisonStartPage extends StatelessWidget {
  const ComparisonStartPage({
    required this.viewModel,
    super.key
  });

  final ComparisonStartViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return header(context);
  }

  Widget header(BuildContext context) {
    const hamburguerMenu = Icon(Icons.menu);
    const appName = Text(
      "Pondera",
      style: TextStyle(
        fontFamily: "Inter"
      ),
    );
    const userPhoto = CircleAvatar(
      backgroundColor: Color(835500)
    );
    const header = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        hamburguerMenu,
        appName,
        userPhoto
      ],
    ); 
    return header;
  }
}