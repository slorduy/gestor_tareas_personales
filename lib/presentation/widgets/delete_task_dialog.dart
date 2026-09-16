import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void confirmDelete(
  BuildContext context,
  WidgetRef ref,
  String title,
  String subtitle,
  void Function() onPress,
) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(subtitle),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: onPress,
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );
}
