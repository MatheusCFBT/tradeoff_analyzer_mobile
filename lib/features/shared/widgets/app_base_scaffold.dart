import 'package:flutter/material.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_header.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_progress_bar.dart';

class AppBaseScaffold extends StatelessWidget {
  const AppBaseScaffold({
    required this.body,
    this.header,
    this.showHeader = true,
    this.showProgressBar = false,
    this.progress,
    this.floatingActionButton,
    super.key,
  });

  final Widget body;
  final Widget? header;
  final bool showHeader;
  final bool showProgressBar;
  final ValueNotifier<double>? progress;
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
            if (showProgressBar)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ValueListenableBuilder<double>(
                  valueListenable: progress ?? ValueNotifier<double>(0.0),
                  builder: (context, value, _) {
                    return AppProgressBar(
                      value: value,
                      height: 3,
                      semanticLabel: 'Progresso da comparação',
                    );
                  },
                ),
              ),
            Expanded(child: body),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
