import 'package:desafio_tecnico/src/features/tasks/domain/tag.dart';
import 'package:desafio_tecnico/src/features/tasks/domain/task.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/providers.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/screens/add_task_screen.dart'; // Reutilizando o diálogo
import 'package:flutter/material.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final List<Tag> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _selectedTags.addAll(widget.task.tags);
  }

  void _saveTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O título é obrigatório.')),
      );
      return;
    }

    final updatedTask = widget.task.copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      tagIds: _selectedTags.map((t) => t.id!).toList(),
    );
    taskStore.updateTask('test_user_id', updatedTask);
    Navigator.of(context).pop();
  }

  void _showTagSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return TagSelectionDialog(
          selectedTags: _selectedTags,
          onSelectionChanged: (tags) {
            setState(() {
              _selectedTags.clear();
              _selectedTags.addAll(tags);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 3,
            ),
            const SizedBox(height: 24.0),
            OutlinedButton.icon(
              icon: const Icon(Icons.label_outline),
              label: const Text('Adicionar/Gerenciar Etiquetas'),
              onPressed: _showTagSelectionDialog,
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                side: BorderSide(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
              ),
            ),
            const SizedBox(height: 16.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _selectedTags.map((tag) {
                return Chip(
                  label: Text(tag.name),
                  backgroundColor: Color(tag.color),
                  labelStyle: const TextStyle(color: Colors.white),
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
