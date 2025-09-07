import 'package:desafio_tecnico/src/features/tasks/domain/task.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/stores/task_store.dart';
import 'package:flutter/material.dart';

class AddTaskScreen extends StatelessWidget {
  final TaskStore taskStore;

  const AddTaskScreen({super.key, required this.taskStore});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    const userId = 'test_user_id';

    void saveTask() {
      final task = Task(
        title: titleController.text,
        description: descriptionController.text,
      );
      taskStore.addTask(userId, task);
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Nova Tarefa')),
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
            ElevatedButton(onPressed: saveTask, child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
