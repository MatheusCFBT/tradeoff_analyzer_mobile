import 'package:flutter/material.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_base_scaffold.dart';
import 'package:tradeoff_analyzer_mobile/routers/app_router.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_card.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_primary_button.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_text_field.dart';

class ComparisonThemePage extends StatefulWidget {
  const ComparisonThemePage({
    required this.circleAvatar,
    this.onContinue,
    super.key,
  });

  final CircleAvatar circleAvatar;
  final void Function(String theme)? onContinue;

  @override
  State<ComparisonThemePage> createState() => _ComparisonThemePageState();
}

class _ComparisonThemePageState extends State<ComparisonThemePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _themeController = TextEditingController();
  final ValueNotifier<double> _progress = ValueNotifier<double>(0.25);

  @override
  void dispose() {
    _themeController.dispose();
    _progress.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final theme = _themeController.text.trim();
    if (widget.onContinue != null) {
      widget.onContinue!(theme);
      return;
    }

    Navigator.of(context).push(AppRouter.comparisonProsRoute(theme: theme));
  }

  @override
  Widget build(BuildContext context) {
    return AppBaseScaffold(
      progress: _progress,
      showProgressBar: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: AppCard(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: widget.circleAvatar),
                          const SizedBox(height: 8),
                          const Text(
                            'Sobre o que é esta decisão?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F3C46),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Defina o tema principal para começar a organizar seus pensamentos.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              height: 1.45,
                              color: Color(0xFF1F3C46),
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            label: 'Tema da Decisão',
                            controller: _themeController,
                            textInputAction: TextInputAction.done,
                            hintText:
                                'Ex: Mudar de carreira, Comprar um carro...',
                            helperText:
                                'Seja claro e objetivo para facilitar a análise.',
                            validator: (value) {
                              if ((value ?? '').trim().isEmpty) {
                                return 'Informe o tema da decisão.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: AppPrimaryButton(
                              label: 'Continuar',
                              onPressed: _handleContinue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
