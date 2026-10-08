import 'package:flutter/material.dart';

import '../../../models/argument_change_model.dart';
import 'argument_edit_sheet.dart';
import 'argument_modal_routes.dart';
import 'argument_removal_dialog.dart';

class ArgumentManagementSheet extends StatefulWidget {
  const ArgumentManagementSheet({super.key, required this.argument});
  final String argument;

  @override
  State<ArgumentManagementSheet> createState() =>
      _ArgumentManagementSheetState();
}

class _ArgumentManagementSheetState extends State<ArgumentManagementSheet> {
  Future<void> _edit() async {
    final updated = await Navigator.of(context).push(
      ArgumentBottomSheetRoute<String>(
        builder: (_) => ArgumentEditSheet(argument: widget.argument),
        capturedThemes: InheritedTheme.capture(
          from: context,
          to: Navigator.of(context).context,
        ),
        barrierLabel: MaterialLocalizations.of(
          context,
        ).modalBarrierDismissLabel,
        maxHeight: MediaQuery.sizeOf(context).height * .85,
      ),
    );
    if (!mounted || updated == null) return;
    Navigator.pop(context, ArgumentEditedModel(updated));
  }

  Future<void> _remove() async {
    final confirmed = await Navigator.of(context).push(
      ArgumentDialogRoute<bool>(
        context: context,
        builder: (_) => const ArgumentRemovalDialog(),
      ),
    );
    if (!mounted || confirmed != true) return;
    Navigator.pop(context, const ArgumentRemovedModel());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Gerenciar Argumento',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF172126),
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE4F0F5),
                  child: Icon(Icons.edit_outlined, color: Color(0xFF245B6B)),
                ),
                title: const Text('Editar'),
                subtitle: const Text('Modificar texto'),
                onTap: _edit,
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFE5E5),
                  child: Icon(Icons.delete_outline, color: Color(0xFFD71919)),
                ),
                title: const Text(
                  'Remover',
                  style: TextStyle(color: Color(0xFFD71919)),
                ),
                subtitle: const Text(
                  'Excluir este argumento permanentemente',
                  style: TextStyle(color: Color(0xFFD71919)),
                ),
                onTap: _remove,
              ),
              const SizedBox(height: 28),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF172126),
                  side: const BorderSide(color: Color(0xFF87949A)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size.fromHeight(44),
                ),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
