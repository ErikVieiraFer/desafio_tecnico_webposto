import 'package:desafio_tecnico/main.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/screens/add_task_screen.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/screens/edit_task_screen.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/stores/task_store.dart';
import 'package:desafio_tecnico/src/features/tasks/data/task_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:desafio_tecnico/src/features/news/presentation/widgets/news_card_widget.dart';

final taskRepository = TaskRepository();
final taskStore = TaskStore(taskRepository);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _userId = 'test_user_id';

  @override
  void initState() {
    super.initState();

    taskStore.fetchTasks(_userId);
  }

  @override
  void dispose() {
    taskStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskScreen(taskStore: taskStore),
                ),
              );
            },
          ),
          IconButton(
            icon: Observer(
              builder: (_) {
                return Icon(
                  themeStore.currentThemeMode == ThemeMode.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                );
              },
            ),
            onPressed: () {
              themeStore.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authStore.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Observer(
              builder: (_) {
                if (taskStore.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (taskStore.error != null) {
                  return Center(
                    child: Text('Ocorreu um erro: ${taskStore.error}'),
                  );
                }

                if (taskStore.tasks.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma tarefa ainda. Adicione uma!'),
                  );
                }

                return ListView.builder(
                  itemCount: taskStore.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskStore.tasks[index];
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
                        subtitle: Text(
                          task.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimary.withAlpha(204),
                            decoration: task.isDone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
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
                                    builder: (context) => EditTaskScreen(
                                      task: task,
                                      taskStore: taskStore,
                                    ),
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
