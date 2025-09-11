import 'package:flutter/material.dart';
import 'package:desafio_tecnico/main.dart';
import 'package:desafio_tecnico/src/core/ui/theme/app_theme.dart';
import 'package:desafio_tecnico/src/features/kanban/data/models/kanban_list.dart';

class RenameColumnDialog extends StatelessWidget {
  final KanbanList kanbanList;
  final bool isDarkMode;

  const RenameColumnDialog({
    super.key,
    required this.kanbanList,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: kanbanList.name);
    return AlertDialog(
      title: Text(
        'Renomear Coluna',
        style: TextStyle(color: isDarkMode ? AppTheme.fontWhite : AppTheme.backgroundBlue),
      ),
      content: TextField(
        controller: nameController,
        decoration: InputDecoration(
          hintText: 'Novo Nome da Coluna',
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
          child: Text('Renomear', style: TextStyle(color: isDarkMode ? AppTheme.fontWhite : AppTheme.backgroundBlue)),
          onPressed: () {
            if (nameController.text.isNotEmpty) {
              final updatedList = kanbanList.copyWith(name: nameController.text);
              kanbanStore.updateKanbanList(updatedList);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}