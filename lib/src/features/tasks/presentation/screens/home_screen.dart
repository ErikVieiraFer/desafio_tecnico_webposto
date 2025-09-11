import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_tecnico/main.dart';
import 'package:desafio_tecnico/src/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:desafio_tecnico/src/features/news/presentation/widgets/news_card_widget.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    if (authStore.user != null) {
      tagStore.fetchTags(authStore.user!.uid);
      taskStore.fetchTasks(authStore.user!.uid);
    }
  }

  @override
  void dispose() {
    taskStore.dispose();
    tagStore.dispose();
    super.dispose();
  }

  void _showTagFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filtrar por Etiqueta'),
          content: SizedBox(
            width: double.maxFinite,
            child: Observer(
              builder: (_) {
                final tags = taskStore.allTags;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: tags.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ListTile(
                        title: const Text('Todas as tarefas'),
                        onTap: () {
                          taskStore.setTagFilter(null);
                          Navigator.of(context).pop();
                        },
                      );
                    }
                    final tag = tags[index - 1];
                    return ListTile(
                      title: Text(tag),
                      onTap: () {
                        taskStore.setTagFilter(tag);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDateFilterPicker() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: taskStore.dateFilter,
    );
    if (picked != null) {
      taskStore.setDateFilter(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtrar por Etiqueta',
            onPressed: () => _showTagFilterDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.date_range),
            tooltip: 'Filtrar por Data',
            onPressed: _showDateFilterPicker,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.addTask);
            },
          ),
          IconButton(
            icon: const Icon(Icons.view_kanban),
            tooltip: 'Visualizar Kanban',
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.kanban);
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'toggle_theme') {
                themeStore.toggleTheme();
              } else if (value == 'logout') {
                authStore.signOut();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'toggle_theme',
                  child: Observer(
                    builder: (_) {
                      return ListTile(
                        leading: Icon(
                          themeStore.currentThemeMode == ThemeMode.light
                              ? Icons.dark_mode
                              : Icons.light_mode,
                        ),
                        title: const Text('Mudar Tema'),
                      );
                    },
                  ),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Sair'),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Observer(
            builder: (_) {
              if (taskStore.dateFilter == null && taskStore.selectedTag == null) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Wrap(
                  spacing: 8.0,
                  children: [
                    if (taskStore.selectedTag != null)
                      Chip(
                        label: Text('Etiqueta: ${taskStore.selectedTag}'),
                        onDeleted: () => taskStore.setTagFilter(null),
                      ),
                    if (taskStore.dateFilter != null)
                      Chip(
                        label: Text(
                          'Período: ${DateFormat('dd/MM/yy').format(taskStore.dateFilter!.start)} - ${DateFormat('dd/MM/yy').format(taskStore.dateFilter!.end)}',
                        ),
                        onDeleted: () => taskStore.setDateFilter(null),
                      ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: Observer(
              builder: (_) {
                if (taskStore.isLoading || tagStore.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (taskStore.error != null || tagStore.error != null) {
                  return Center(
                    child: Text(
                        'Ocorreu um erro: ${taskStore.error ?? tagStore.error}'),
                  );
                }

                if (taskStore.filteredTasks.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Nenhuma tarefa encontrada para os filtros selecionados.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: taskStore.filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = taskStore.filteredTasks[index];
                    return Dismissible(
                      key: ValueKey(task.id ?? UniqueKey().toString()),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        if (authStore.user != null) {
                          taskStore.deleteTask(authStore.user!.uid, task.id!);
                        }
                      },
                      background: Container(
                        color: theme.colorScheme.secondary,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        title: Text(
                          task.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                              child: Text(
                                task.description,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onPrimary.withOpacity(0.8),
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                            if (task.endDate != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: theme.colorScheme.onPrimary.withOpacity(0.8),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Vence em: ${DateFormat('dd/MM/yyyy').format(task.endDate!.toDate())}',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onPrimary.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (task.tags.isNotEmpty)
                              Wrap(
                                spacing: 6.0,
                                runSpacing: 4.0,
                                children: task.tags.map((tag) {
                                  return Chip(
                                    label: Text(tag.name, style: const TextStyle(fontSize: 12)),
                                    backgroundColor: Color(tag.color),
                                    labelStyle: const TextStyle(color: Colors.white),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              color: theme.colorScheme.onPrimary,
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRouter.editTask,
                                  arguments: task,
                                );
                              },
                            ),
                            Checkbox(
                              value: task.isCompleted,
                              onChanged: (value) {
                                if (value != null) {
                                  final updatedTask = task.copyWith(
                                    isCompleted: value,
                                    createdAt: task.createdAt,
                                    updatedAt: Timestamp.now(), 
                                  );
                                  if (authStore.user != null) {
                                    taskStore.updateTask(authStore.user!.uid, updatedTask);
                                  }
                                }
                              },
                              activeColor: theme.colorScheme.secondary,
                              checkColor: theme.colorScheme.onPrimary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const NewsCardWidget(),
        ],
      ),
      floatingActionButton: null,
    );
  }
}
