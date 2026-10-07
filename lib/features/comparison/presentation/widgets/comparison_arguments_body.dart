import 'package:flutter/material.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_card.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_text_field.dart';

import 'argument_management_modals.dart';

class ComparisonArgumentsBody extends StatelessWidget {
  const ComparisonArgumentsBody({
    required this.theme,
    required this.arguments,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    required this.onUpdate,
    required this.onRemove,
    required this.onBack,
    required this.onNext,
    this.isCons = false,
    super.key,
  });
  final String theme;
  final List<String> arguments;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;
  final bool Function(int index, String value) onUpdate;
  final bool Function(int index) onRemove;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final bool isCons;

  Future<void> _manage(BuildContext context, int index) async {
    final change = await showArgumentManagement(
      context,
      argument: arguments[index],
    );
    if (!context.mounted) return;
    switch (change) {
      case ArgumentEdited(:final text):
        onUpdate(index, text);
      case ArgumentRemoved():
        onRemove(index);
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                _ArgumentNavigation(onBack: onBack, onNext: onNext),
                const SizedBox(height: 18),
                _CurrentDecisionMainCard(theme: theme),
                const SizedBox(height: 36),
                _AddArgumentCard(
                  controller: controller,
                  focusNode: focusNode,
                  onSubmitted: onSubmitted,
                  isCons: isCons,
                ),
                const SizedBox(height: 32),
                _AddedArgumentsSection(
                  arguments: arguments,
                  isCons: isCons,
                  onTap: (index) => _manage(context, index),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArgumentNavigation extends StatelessWidget {
  const _ArgumentNavigation({required this.onBack, required this.onNext});
  final VoidCallback onBack;
  final VoidCallback onNext;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 34,
              child: TextButton.icon(
                onPressed: onBack,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF1F3C46),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Voltar',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 14),
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
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003541),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(0, 34),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
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
          ),
        ],
      ),
    );
  }
}

class _CurrentDecisionMainCard extends StatelessWidget {
  const _CurrentDecisionMainCard({required this.theme});
  final String theme;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFE4F0F5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
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
          theme,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 28,
            fontWeight: FontWeight.w700,
            height: 1.2,
            color: Color(0xFF172126),
          ),
        ),
      ],
    );
  }
}

class _AddArgumentCard extends StatelessWidget {
  const _AddArgumentCard({
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    required this.isCons,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;
  final bool isCons;
  @override
  Widget build(BuildContext context) {
    return AppCard(
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
              CircleAvatar(
                radius: 16,
                backgroundColor: isCons
                    ? const Color(0xFFFFD8D5)
                    : const Color(0xFF004353),
                child: Icon(
                  isCons ? Icons.remove : Icons.add,
                  size: 21,
                  color: isCons ? const Color(0xFFD71919) : Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCons
                          ? 'Adicionar Argumento Desfavorável'
                          : 'Adicionar Argumento Favorável',
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
                      isCons
                          ? 'O que pesa contra essa decisão?'
                          : 'O que pesa a favor dessa decisão?',
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
          AppTextField(
            controller: controller,
            focusNode: focusNode,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: onSubmitted,
            onEditingComplete: () {},
            decoration: InputDecoration(
              hintText: isCons
                  ? 'Ex: Perda de estabilidade, Menor salário...'
                  : 'Ex: Melhor salário, Novos desafios...',
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
                borderSide: const BorderSide(color: Color(0xFF87949A)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF87949A)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF004353)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddedArgumentsSection extends StatelessWidget {
  const _AddedArgumentsSection({
    required this.arguments,
    required this.isCons,
    required this.onTap,
  });
  final ValueChanged<int> onTap;
  final bool isCons;
  final List<String> arguments;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                isCons ? 'Contras Adicionados' : 'Prós Adicionados',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF172126),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFE4F0F5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${arguments.length} ${arguments.length == 1 ? 'Item' : 'Itens'}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Color(0xFF245B6B),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (var index = 0; index < arguments.length; index++)
          _ArgumentCard(
            argument: arguments[index],
            isCons: isCons,
            onTap: () => onTap(index),
          ),
      ],
    );
  }
}

class _ArgumentCard extends StatelessWidget {
  const _ArgumentCard({
    required this.argument,
    required this.isCons,
    required this.onTap,
  });
  final VoidCallback onTap;
  final bool isCons;
  final String argument;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Semantics(
        button: true,
        label: 'Gerenciar argumento',
        child: AppCard(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFFCFD9DE)),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isCons ? Icons.cancel : Icons.check_circle,
                    size: 18,
                    color: isCons
                        ? const Color(0xFFD71919)
                        : const Color(0xFF004353),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      argument,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Color(0xFF172126),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
