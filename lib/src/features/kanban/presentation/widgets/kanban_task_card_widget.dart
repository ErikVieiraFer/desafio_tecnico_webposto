import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_tecnico/main.dart';
import 'package:desafio_tecnico/src/core/routing/app_router.dart';
import 'package:desafio_tecnico/src/core/ui/theme/app_theme.dart';
import 'package:desafio_tecnico/src/features/tasks/domain/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KanbanTaskCardWidget extends StatelessWidget {
  final Task task;
  final String sourceListId;
  final bool isDarkMode;

  const KanbanTaskCardWidget({
    super.key,
    required this.task,
    required this.sourceListId,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = isDarkMode ? AppTheme.backgroundBlue : AppTheme.fontWhite;
    final textColor = isDarkMode ? AppTheme.fontWhite : AppTheme.backgroundBlue;

    final cardContent = Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: textColor,
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: textColor),
                  onSelected: (value) {
                    if (value == 'edit') {
                      Navigator.pushNamed(
                        context,
                        AppRouter.editTask,
                        arguments: task,
                      );
                    } else if (value == 'delete') {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text('Excluir Tarefa'),
                            content: Text(
                                'Tem certeza que deseja excluir a tarefa "${task.title}"?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancelar'),
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(),
                              ),
                              TextButton(
                                child: Text('Excluir',
                                    style:
                                        TextStyle(color: theme.colorScheme.error)),
                                onPressed: () {
                                  if (authStore.user != null &&
                                      task.id != null) {
                                    taskStore.deleteTask(
                                        authStore.user!.uid, task.id!);
                                  }
                                  Navigator.of(dialogContext).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Editar'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Excluir'),
                    ),
                  ],
                ),
              ],
            ),
            if (task.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                child: Text(
                  task.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textColor.withOpacity(0.8),
                    decoration:
                        task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (task.endDate != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 14, color: textColor.withOpacity(0.8)),
                    const SizedBox(width: 6),
                    Text(
                      'Vence em: ${DateFormat('dd/MM/yy').format(task.endDate!.toDate())}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: textColor.withOpacity(0.8)),
                    ),
                  ],
                ),
              ),
            if (task.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Wrap(
                  spacing: 6.0,
                  runSpacing: 4.0,
                  children: task.tags.map((tag) {
                    return Chip(
                      label: Text(tag.name, style: const TextStyle(fontSize: 10)),
                      backgroundColor: Color(tag.color),
                      labelStyle: const TextStyle(color: Colors.white),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 2.0),
                    );
                  }).toList(),
                ),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  if (value != null) {
                    final updatedTask = task.copyWith(
                      isCompleted: value,
                      createdAt: task.createdAt,
                      updatedAt: Timestamp.now(),
                    );
                    if (authStore.user != null) {
                      taskStore.updateTask(
                          authStore.user!.uid, updatedTask);
                    }
                  }
                },
                activeColor: theme.colorScheme.secondary,
                checkColor: cardColor,
                side: BorderSide(color: textColor),
              ),
            ),
          ],
        ),
      ),
    );

    return Draggable<Map<String, String>>(
      data: {'taskId': task.id!, 'sourceListId': sourceListId},
      feedback: Material(
        elevation: 4.0,
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: cardContent,
        )
      ),
      childWhenDragging: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        color:
            (isDarkMode ? AppTheme.backgroundBlue : AppTheme.fontWhite).withOpacity(0.5),
        child: const SizedBox(
          height: 100,
        ),
      ),
      child: cardContent,
    );
  }
}