import 'package:flutter/material.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_text_field.dart';
import '../viewmodels/comparison_pros_viewmodel.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_base_scaffold.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_card.dart';

class ComparisonProsPage extends StatefulWidget {
  const ComparisonProsPage({
    required this.theme,
    this.viewModel,
    super.key,
  });

  final String theme;
  final ComparisonProsViewModel? viewModel;

  @override
  State<ComparisonProsPage> createState() =>
      _ComparisonProsPageState();
}

class _ComparisonProsPageState extends State<ComparisonProsPage> {
  final ValueNotifier<double> _progress = ValueNotifier<double>(0.5);

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final ComparisonProsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? ComparisonProsViewModel();
    _viewModel.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  void _submit(String value) {
    if (_viewModel.addPro(value)) {
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_refresh);
    _viewModel.dispose();
    _controller.dispose();
    _focusNode.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBaseScaffold(
      progress: _progress,
      showProgressBar: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  _ProsNavigation(
                    onBack: () => Navigator.of(context).pop(),
                    onNext: () {},
                  ),
                  const SizedBox(height: 18),
                  _CurrentDecisionHeader(theme: widget.theme),
                  const SizedBox(height: 36),
                  _AddProCard(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSubmitted: _submit,
                  ),
                  const SizedBox(height: 32),
                  _AddedProsSection(pros: _viewModel.pros),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProsNavigation extends StatelessWidget {
  const _ProsNavigation({required this.onBack, required this.onNext});
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

class _CurrentDecisionHeader extends StatelessWidget {
  const _CurrentDecisionHeader({required this.theme});
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

class _AddProCard extends StatelessWidget {
  const _AddProCard({
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;
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
              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF004353),
                child: Icon(Icons.add, size: 21, color: Colors.white),
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
          AppTextField(
            controller: controller,
            focusNode: focusNode,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: onSubmitted,
            onEditingComplete: () {},
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

class _AddedProsSection extends StatelessWidget {
  const _AddedProsSection({required this.pros});
  final List<String> pros;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Prós Adicionados',
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
                '${pros.length} ${pros.length == 1 ? 'Item' : 'Itens'}',
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
        for (final argument in pros) _ProArgumentCard(argument: argument),
      ],
    );
  }
}

class _ProArgumentCard extends StatelessWidget {
  const _ProArgumentCard({required this.argument});
  final String argument;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFFCFD9DE)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle, size: 18, color: Color(0xFF004353)),
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
    );
  }
}
