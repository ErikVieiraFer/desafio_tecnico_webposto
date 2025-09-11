import 'package:flutter/material.dart';
import 'package:desafio_tecnico/main.dart';
import 'package:desafio_tecnico/src/core/ui/theme/app_theme.dart';

class AddColumnDialog extends StatelessWidget {
  final bool isDarkMode;

  const AddColumnDialog({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    String newColumnName = '';
    return AlertDialog(
      title: Text(
        'Criar Nova Coluna',
        style: TextStyle(color: isDarkMode ? AppTheme.fontWhite : AppTheme.backgroundBlue),
      ),
      content: TextField(
        onChanged: (value) {
          newColumnName = value;
        },
        decoration: InputDecoration(
          hintText: 'Nome da Coluna',
          hintStyle: TextStyle(color: (isDarkMode ? AppTheme.fontWhite : AppTheme.backgroundBlue).withOpacity(0.7)),
        ),
        style: TextStyle(color: isDarkMode ? AppTheme.fontWhite : AppTheme.backgroundBlue),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancelar', style: TextStyle(color: AppTheme.detailRed)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Criar', style: TextStyle(color: isDarkMode ? AppTheme.fontWhite : AppTheme.backgroundBlue)),
          onPressed: () {
            if (newColumnName.isNotEmpty) {
              kanbanStore.addKanbanList(newColumnName);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}