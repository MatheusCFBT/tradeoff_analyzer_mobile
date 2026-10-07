import 'package:flutter/material.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_text_field.dart';

class ArgumentEditSheet extends StatefulWidget {
  const ArgumentEditSheet({super.key, required this.argument});
  final String argument;

  @override
  State<ArgumentEditSheet> createState() => _ArgumentEditSheetState();
}

class _ArgumentEditSheetState extends State<ArgumentEditSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.argument);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.pop(context, _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    );
    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Editar Argumento',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF172126),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Edite o texto do seu argumento',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Color(0xFF172126),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Argumento',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F3C46),
                    ),
                  ),
                  const SizedBox(height: 6),
                  AppTextField(
                    controller: _controller,
                    maxLines: 4,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _save(),
                    validator: (value) => (value ?? '').trim().isEmpty
                        ? 'Informe o argumento.'
                        : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF4F9FC),
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFB8CBD4)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFB8CBD4)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF245B6B)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF172126),
                            side: const BorderSide(color: Color(0xFF87949A)),
                            shape: buttonShape,
                            minimumSize: const Size.fromHeight(44),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF003541),
                            foregroundColor: Colors.white,
                            shape: buttonShape,
                            minimumSize: const Size.fromHeight(44),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Salvar Alterações',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
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
