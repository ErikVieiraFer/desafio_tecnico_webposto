import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_tecnico/main.dart';
import 'package:desafio_tecnico/src/features/tasks/domain/tag.dart';
import 'package:desafio_tecnico/src/features/tasks/domain/task.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/widgets/tag_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  final String? kanbanListId;

  const AddTaskScreen({super.key, this.kanbanListId});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<Tag> _selectedTags = [];
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    // Ensure stores are initialized
    if (authStore.user != null) {
      tagStore.fetchTags(authStore.user!.uid);
    }
  }

  void _saveTask() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O título é obrigatório.')),
      );
      return;
    }

    if (authStore.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você precisa estar logado para criar uma tarefa.')),
      );
      return;
    }

    String targetKanbanListId;
    if (widget.kanbanListId != null) {
      targetKanbanListId = widget.kanbanListId!;
    } else {
      // Fetch kanban lists if they are not loaded
      if (kanbanStore.kanbanLists.isEmpty) {
        await kanbanStore.loadKanbanLists();
      }
      // Default to the first list if available
      if (kanbanStore.kanbanLists.isNotEmpty) {
        targetKanbanListId = kanbanStore.kanbanLists.first.id;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nenhuma coluna Kanban encontrada para adicionar a tarefa.')),
        );
        return;
      }
    }

    final task = Task(
      title: _titleController.text,
      description: _descriptionController.text,
      tagIds: _selectedTags.map((t) => t.id).whereType<String>().toList(),
      kanbanListId: targetKanbanListId,
      position: DateTime.now().millisecondsSinceEpoch,
      startDate: _selectedDateRange?.start != null
          ? Timestamp.fromDate(_selectedDateRange!.start)
          : null,
      endDate: _selectedDateRange?.end != null
          ? Timestamp.fromDate(_selectedDateRange!.end)
          : null,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );

    await taskStore.addTask(authStore.user!.uid, task);
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

  Future<void> _showDateRangePicker() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _selectedDateRange,
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Nova Tarefa')),
      body: SingleChildScrollView(
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
                side: BorderSide(color: theme.colorScheme.onPrimary.withAlpha(128)),
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
            const SizedBox(height: 24.0),
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: const Text('Definir Prazo'),
              onPressed: _showDateRangePicker,
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.onPrimary,
                side: BorderSide(color: theme.colorScheme.onPrimary.withAlpha(128)),
              ),
            ),
            const SizedBox(height: 16.0),
            if (_selectedDateRange != null)
              Center(
                child: Text(
                  'Prazo: ${DateFormat('dd/MM/yy').format(_selectedDateRange!.start)} - ${DateFormat('dd/MM/yy').format(_selectedDateRange!.end)}',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            const SizedBox(height: 48.0),
            ElevatedButton(onPressed: _saveTask, child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
