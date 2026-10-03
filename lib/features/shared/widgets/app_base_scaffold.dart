import 'package:flutter/material.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_header.dart';

class AppBaseScaffold extends StatelessWidget {
  const AppBaseScaffold({
    required this.body,
    this.header,
    this.showHeader = true,
    this.floatingActionButton,
    super.key,
  });

  final Widget body;
  final Widget? header;
  final bool showHeader;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),
      body: SafeArea(
        child: Column(
          children: [
            if (showHeader)
              header ?? const AppHeader(
                leading: Icon(
                  Icons.menu,
                  color: Color(0xFF245B6B),
                ),
                onAvatarTap: null,
              ),
            Expanded(child: body),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
