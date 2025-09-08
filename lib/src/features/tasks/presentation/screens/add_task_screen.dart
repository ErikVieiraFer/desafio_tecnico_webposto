import 'package:desafio_tecnico/src/features/tasks/domain/tag.dart';
import 'package:desafio_tecnico/src/features/tasks/domain/task.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<Tag> _selectedTags = [];

  void _saveTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O título é obrigatório.')),
      );
      return;
    }

    final task = Task(
      title: _titleController.text,
      description: _descriptionController.text,
      tagIds: _selectedTags.map((t) => t.id!).toList(),
    );
    taskStore.addTask('test_user_id', task);
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Nova Tarefa')),
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
                foregroundColor: theme.colorScheme.onPrimary,
                side: BorderSide(color: theme.colorScheme.onPrimary.withOpacity(0.5)),
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
            ElevatedButton(onPressed: _saveTask, child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }
}

class TagSelectionDialog extends StatefulWidget {
  final List<Tag> selectedTags;
  final ValueChanged<List<Tag>> onSelectionChanged;

  const TagSelectionDialog({
    super.key,
    required this.selectedTags,
    required this.onSelectionChanged,
  });

  @override
  State<TagSelectionDialog> createState() => _TagSelectionDialogState();
}

class _TagSelectionDialogState extends State<TagSelectionDialog> {
  late final List<Tag> _tempSelectedTags;

  @override
  void initState() {
    super.initState();
    _tempSelectedTags = List.from(widget.selectedTags);
  }

  void _showCreateTagDialog() {
    final nameController = TextEditingController();
    Color pickerColor = Colors.blue;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: const Text('Criar Nova Etiqueta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome da Etiqueta'),
              ),
              const SizedBox(height: 20),
              ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (color) => pickerColor = color,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.secondary,
              ),
            ),
            ElevatedButton(
              child: const Text('Criar'),
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  final newTag = Tag(name: name, color: pickerColor.value);
                  tagStore.addTag('test_user_id', newTag);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Selecione as Etiquetas'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Criar nova etiqueta'),
              onPressed: _showCreateTagDialog,
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.onPrimary,
              ),
            ),
            const Divider(),
            Expanded(
              child: Observer(
                builder: (_) {
                  if (tagStore.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: tagStore.tags.length,
                    itemBuilder: (context, index) {
                      final tag = tagStore.tags[index];
                      final isSelected = _tempSelectedTags.any((t) => t.id == tag.id);
                      return CheckboxListTile(
                        title: Text(tag.name),
                        value: isSelected,
                        secondary: CircleAvatar(backgroundColor: Color(tag.color), radius: 10),
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              _tempSelectedTags.add(tag);
                            } else {
                              _tempSelectedTags.removeWhere((t) => t.id == tag.id);
                            }
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.secondary,
          ),
        ),
        ElevatedButton(
          child: const Text('Confirmar'),
          onPressed: () {
            widget.onSelectionChanged(_tempSelectedTags);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}