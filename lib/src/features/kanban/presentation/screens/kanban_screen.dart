import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:desafio_tecnico/main.dart';
import 'package:desafio_tecnico/src/features/kanban/presentation/widgets/kanban_column_widget.dart';
import 'package:desafio_tecnico/src/features/kanban/presentation/widgets/add_column_dialog.dart';

class KanbanScreen extends StatelessWidget {
  const KanbanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authStore.user != null) {
        taskStore.fetchTasks(authStore.user!.uid);
      }
    });

    if (!kanbanStore.isLoading && kanbanStore.kanbanLists.isEmpty) {
      kanbanStore.loadKanbanLists();
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Observer(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Quadro Kanban'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Adicionar Coluna',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddColumnDialog(isDarkMode: isDarkMode);
                    },
                  );
                },
              ),
            ],
          ),
          body: kanbanStore.isLoading
              ? const Center(child: CircularProgressIndicator())
              : kanbanStore.kanbanLists.isEmpty
                  ? const Center(child: Text('Nenhuma coluna Kanban encontrada.'))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: kanbanStore.kanbanLists.map((kanbanList) {
                          return KanbanColumnWidget(kanbanList: kanbanList);
                        }).toList(),
                      ),
                    ),
        );
      },
    );
  }
}
