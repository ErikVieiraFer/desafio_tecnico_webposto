import 'package:desafio_tecnico/src/features/tasks/domain/task.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/stores/task_store.dart';
import 'package:flutter/material.dart';

class EditTaskScreen extends StatelessWidget {
  final Task task;
  final TaskStore taskStore;

  const EditTaskScreen({
    super.key,
    required this.task,
    required this.taskStore,
  });

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);

    const userId = 'test_user_id';

    void saveTask() {
      final updatedTask = task.copyWith(
        title: titleController.text,
        description: descriptionController.text,
      );
      taskStore.updateTask(userId, updatedTask);
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 3,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: saveTask,
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
