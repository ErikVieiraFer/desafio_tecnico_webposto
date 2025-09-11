import 'package:desafio_tecnico/firebase_options.dart';
import 'package:desafio_tecnico/src/core/routing/app_router.dart';
import 'package:desafio_tecnico/src/core/ui/theme/app_theme.dart';
import 'package:desafio_tecnico/src/repositories/auth_repository.dart';
import 'package:desafio_tecnico/src/features/auth/presentation/stores/auth_store.dart';
import 'package:desafio_tecnico/src/repositories/task_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:desafio_tecnico/src/core/ui/theme/theme_store.dart';
import 'package:desafio_tecnico/src/repositories/kanban_list_repository.dart';
import 'package:desafio_tecnico/src/features/kanban/presentation/stores/kanban_store.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/stores/tag_store.dart';
import 'package:desafio_tecnico/src/features/tasks/data/tag_repository.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/stores/task_store.dart';

final authRepository = AuthRepository();
final authStore = AuthStore(authRepository);

final themeStore = ThemeStore();

final kanbanListRepository = KanbanListRepository();
final kanbanStore = KanbanStore(kanbanListRepository, authRepository);

final taskRepository = TaskRepository();
final tagRepository = TagRepository();
final tagStore = TagStore(tagRepository);
final taskStore = TaskStore(taskRepository, tagStore);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return MaterialApp(
          title: 'Desafio Tecnico',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeStore.currentThemeMode,
          initialRoute: AppRouter.authWrapper,
          onGenerateRoute: AppRouter.generateRoute,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}