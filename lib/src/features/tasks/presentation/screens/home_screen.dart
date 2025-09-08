import 'package:desafio_tecnico/main.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/providers.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/screens/add_task_screen.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/screens/edit_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:desafio_tecnico/src/features/news/presentation/widgets/news_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _userId = 'test_user_id'; // TODO: Substituir pelo ID do usuário logado

  @override
  void initState() {
    super.initState();
    // Inicia o fetch de ambas as listas
    tagStore.fetchTags(_userId);
    taskStore.fetchTasks(_userId);
  }

  @override
  void dispose() {
    taskStore.dispose();
    tagStore.dispose();
    super.dispose();
  }

  void _showFilterDialog(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTaskScreen(),
                ),
              );
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
                  return Center(
                    child: Text(taskStore.selectedTag == null
                        ? 'Nenhuma tarefa ainda. Adicione uma!'
                        : 'Nenhuma tarefa com a etiqueta "${taskStore.selectedTag}"'),
                  );
                }

                return ListView.builder(
                  itemCount: taskStore.filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = taskStore.filteredTasks[index];
                    return Dismissible(
                      key: Key(task.id!),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        taskStore.deleteTask(_userId, task.id!);
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
                            decoration: task.isDone
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
                                  color: theme.colorScheme.onPrimary.withAlpha(204),
                                  decoration: task.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditTaskScreen(task: task),
                                  ),
                                );
                              },
                            ),
                            Checkbox(
                              value: task.isDone,
                              onChanged: (value) {
                                if (value != null) {
                                  final updatedTask = task.copyWith(
                                    isDone: value,
                                  );
                                  taskStore.updateTask(_userId, updatedTask);
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
