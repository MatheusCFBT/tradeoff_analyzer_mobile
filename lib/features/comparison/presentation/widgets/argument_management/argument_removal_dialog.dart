import 'package:flutter/material.dart';

class ArgumentRemovalDialog extends StatelessWidget {
  const ArgumentRemovalDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      scrollable: true,
      icon: const Align(
        alignment: Alignment.centerLeft,
        child: CircleAvatar(
          backgroundColor: Color(0xFFE4F0F5),
          child: Icon(Icons.delete, color: Color(0xFF245B6B)),
        ),
      ),
      title: const Text(
        'Remover Argumento?',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      content: const Text(
        'Esta ação não pode ser desfeita. Tem certeza que deseja excluir permanentemente este argumento?',
        style: TextStyle(height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD71919),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Excluir'),
        ),
      ],
    );
  }
}
