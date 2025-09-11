import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_tecnico/main.dart';
import 'package:desafio_tecnico/src/features/tasks/domain/tag.dart';
import 'package:desafio_tecnico/src/features/tasks/domain/task.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/stores/comment_store.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/widgets/tag_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _commentController;
  late final CommentStore _commentStore;
  final List<Tag> _selectedTags = [];
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _commentController = TextEditingController();
    _commentStore = CommentStore(taskRepository, authStore);
    _commentStore.setupCommentsStream(widget.task.id!);

    _selectedTags.addAll(widget.task.tags);

    if (widget.task.startDate != null && widget.task.endDate != null) {
      _selectedDateRange = DateTimeRange(
        start: widget.task.startDate!.toDate(),
        end: widget.task.endDate!.toDate(),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _commentController.dispose();
    _commentStore.dispose();
    super.dispose();
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
      startDate: _selectedDateRange?.start != null
          ? Timestamp.fromDate(_selectedDateRange!.start)
          : null,
      endDate: _selectedDateRange?.end != null
          ? Timestamp.fromDate(_selectedDateRange!.end)
          : null,
      updatedAt: Timestamp.now(),
    );
    taskStore.updateTask(authStore.user!.uid, updatedTask);
    Navigator.of(context).pop();
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      _commentStore.addComment(_commentController.text);
      _commentController.clear();
      FocusScope.of(context).unfocus();
    }
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
      appBar: AppBar(title: const Text('Editar Tarefa')),
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
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text('Salvar Alterações'),
            ),
            const SizedBox(height: 24.0),
            const Divider(),
            const SizedBox(height: 16.0),
            Text('Comentários', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16.0),
            _buildCommentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentSection() {
    return Column(
      children: [
        Observer(
          builder: (_) {
            if (_commentStore.comments.isEmpty) {
              return const Center(child: Text('Nenhum comentário ainda.'));
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _commentStore.comments.length,
              itemBuilder: (context, index) {
                final comment = _commentStore.comments[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    title: Text(comment.content),
                    subtitle: Text(
                      DateFormat('dd/MM/yy HH:mm').format(comment.timestamp.toDate()),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(labelText: 'Adicionar um comentário...'),
                onFieldSubmitted: (_) => _addComment(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _addComment,
            ),
          ],
        ),
      ],
    );
  }
}
