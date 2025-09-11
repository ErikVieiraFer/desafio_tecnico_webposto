import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_tecnico/main.dart';
import 'package:desafio_tecnico/src/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:desafio_tecnico/src/features/kanban/data/models/kanban_list.dart';
import 'package:desafio_tecnico/src/core/ui/theme/app_theme.dart';
import 'package:desafio_tecnico/src/features/kanban/presentation/widgets/kanban_task_card_widget.dart';
import 'package:desafio_tecnico/src/features/kanban/presentation/widgets/rename_column_dialog.dart';

class KanbanColumnWidget extends StatelessWidget {
  final KanbanList kanbanList;

  const KanbanColumnWidget({super.key, required this.kanbanList});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Draggable<KanbanList>(
      data: kanbanList,
      feedback: Material(
        elevation: 4.0,
        child: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            color: (isDarkMode ? AppTheme.backgroundBlue : AppTheme.fontWhite).withOpacity(0.5),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              kanbanList.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppTheme.fontWhite : AppTheme.backgroundBlue,
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        width: 300,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: (isDarkMode ? AppTheme.backgroundBlue : AppTheme.fontWhite).withOpacity(0.5),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: isDarkMode ? AppTheme.fontWhite : AppTheme.backgroundBlue, width: 2.0),
        ),
        child: Center(
          child: Text(
            kanbanList.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppTheme.fontWhite : AppTheme.backgroundBlue,
            ),
          ),
        ),
      ),
      child: DragTarget<KanbanList>(
        onWillAcceptWithDetails: (details) => details.data.id != kanbanList.id,
        onAcceptWithDetails: (details) {
          final draggedList = details.data;
          final oldIndex = kanbanStore.kanbanLists.indexOf(draggedList);
          final newIndex = kanbanStore.kanbanLists.indexOf(kanbanList);
          if (oldIndex != -1 && newIndex != -1) {
            kanbanStore.reorderKanbanLists(oldIndex, newIndex);
          }
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            width: 300,
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: isDarkMode ? AppTheme.backgroundBlue : AppTheme.fontWhite,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: candidateData.isNotEmpty
                    ? AppTheme.detailRed
                    : isDarkMode ? AppTheme.fontWhite : AppTheme.backgroundBlue,
                width: 2.0,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          kanbanList.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? AppTheme.fontWhite
                                : AppTheme.backgroundBlue,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert,
                            color: isDarkMode
                                ? AppTheme.fontWhite
                                : AppTheme.backgroundBlue),
                        onSelected: (value) {
                          if (value == 'rename') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return RenameColumnDialog(
                                    kanbanList: kanbanList,
                                    isDarkMode: isDarkMode);
                              },
                            );
                          } else if (value == 'delete') {
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: const Text('Excluir Coluna'),
                                  content: Text(
                                      'Tem certeza que deseja excluir a coluna "${kanbanList.name}"? As tarefas nesta coluna não serão excluídas, mas ficarão sem uma coluna visível no quadro.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancelar'),
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Excluir',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error)),
                                      onPressed: () {
                                        kanbanStore
                                            .deleteKanbanList(kanbanList.id);
                                        Navigator.of(dialogContext).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          final items = <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'rename',
                              child: Text('Renomear'),
                            ),
                          ];
                          if (kanbanList.isDeletable) {
                            items.add(
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Excluir Coluna'),
                              ),
                            );
                          }
                          return items;
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: DragTarget<Map<String, String>>(
                    onWillAcceptWithDetails: (details) => details.data['taskId'] != null,
                    onAcceptWithDetails: (details) async {
                      final taskId = details.data['taskId']!;
                      final oldListId = details.data['sourceListId']!;
                      final newListId = kanbanList.id;

                      if (oldListId != newListId) {
                        final taskToUpdate = taskStore.tasks
                            .firstWhere((task) => task.id == taskId);
                        final updatedTask = taskToUpdate.copyWith(
                          kanbanListId: newListId,
                          updatedAt: Timestamp.now(),
                        );
                        await taskStore.updateTask(
                            authStore.user!.uid, updatedTask);
                      }
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Observer(
                        builder: (_) {
                          final tasksInColumn = taskStore.tasks
                              .where((task) => task.kanbanListId == kanbanList.id)
                              .toList();

                          return ListView.builder(
                            itemCount: tasksInColumn.length,
                            itemBuilder: (context, taskIndex) {
                              final task = tasksInColumn[taskIndex];
                              return KanbanTaskCardWidget(task: task, sourceListId: kanbanList.id, isDarkMode: isDarkMode);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.addTask,
                        arguments: kanbanList.id,
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar Tarefa'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.detailRed,
                      foregroundColor: AppTheme.fontWhite,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
