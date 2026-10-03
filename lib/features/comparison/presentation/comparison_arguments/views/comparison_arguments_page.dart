import 'package:flutter/material.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_base_scaffold.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_card.dart';

class ComparisonArgumentsPage extends StatefulWidget {
  const ComparisonArgumentsPage({required this.theme, super.key});

  final String theme;

  @override
  State<ComparisonArgumentsPage> createState() => _ComparisonArgumentsPageState();
}

class _ComparisonArgumentsPageState extends State<ComparisonArgumentsPage> {
  final ValueNotifier<double> _progress = ValueNotifier<double>(0.5);

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBaseScaffold(
      progress: _progress,
      showProgressBar: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 34,
                          child: TextButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF1F3C46),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: const Icon(Icons.arrow_back, size: 18),
                            label: const Text(
                              'Voltar',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 34,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF003541),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              minimumSize: const Size(0, 34),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.arrow_forward, size: 18),
                            label: const Text(
                              'Próximo Passo',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.topCenter,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4F0F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      child: Text(
                        'Decisão Atual',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: Color(0xFF1F3C46),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.theme,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: Color(0xFF172126),
                  ),
                ),
                const SizedBox(height: 36),
                AppCard(
                  padding: const EdgeInsets.all(22),
                  margin: EdgeInsets.zero,
                  borderRadius: BorderRadius.circular(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFCFD9DE)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: Color(0xFF004353),
                            child: Icon(
                              Icons.add,
                              size: 21,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Adicionar Argumento Favorável',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    height: 1.25,
                                    color: Color(0xFF172126),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'O que pesa a favor dessa decisão?',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    height: 1.4,
                                    color: Color(0xFF172126),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Ex: Melhor salário, Novos desafios...',
                          hintStyle: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Color(0xFFB0C0C8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF87949A),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF87949A),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF004353),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
