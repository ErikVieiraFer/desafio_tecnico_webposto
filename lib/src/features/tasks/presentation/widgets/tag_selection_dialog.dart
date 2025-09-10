import 'package:desafio_tecnico/main.dart';
import 'package:desafio_tecnico/src/features/tasks/domain/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

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
                  if (authStore.user != null) { // Ensure user is authenticated
                    tagStore.addTag(authStore.user!.uid, newTag);
                  }
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
                      return ListTile(
                        leading: CircleAvatar(backgroundColor: Color(tag.color), radius: 10),
                        title: Text(tag.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: isSelected,
                              onChanged: (bool? selected) {
                                setState(() {
                                  if (selected == true) {
                                    _tempSelectedTags.add(tag);
                                  } else {
                                    _tempSelectedTags.removeWhere((t) => t.id == tag.id);
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: const Text('Excluir Etiqueta'),
                                      content: Text(
                                          'Tem certeza que deseja excluir a etiqueta "${tag.name}"? Esta ação não pode ser desfeita.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Cancelar'),
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Excluir', style: TextStyle(color: theme.colorScheme.error)),
                                          onPressed: () {
                                            if (authStore.user != null && tag.id != null) {
                                              tagStore.deleteTag(authStore.user!.uid, tag.id!);
                                              _tempSelectedTags.removeWhere((t) => t.id == tag.id);
                                            }
                                            Navigator.of(dialogContext).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            if (!isSelected) {
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
