
import 'package:desafio_tecnico/src/core/routing/auth_wrapper.dart';
import 'package:desafio_tecnico/src/features/auth/presentation/screens/login_screen.dart';
import 'package:desafio_tecnico/src/features/auth/presentation/screens/registration_screen.dart';
import 'package:desafio_tecnico/src/features/kanban/presentation/screens/kanban_screen.dart';
import 'package:desafio_tecnico/src/features/news/domain/news_article.dart';
import 'package:desafio_tecnico/src/features/news/presentation/screens/news_detail_screen.dart';
import 'package:desafio_tecnico/src/features/tasks/domain/task.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/screens/add_task_screen.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/screens/edit_task_screen.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String authWrapper = '/';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String home = '/home';
  static const String addTask = '/add-task';
  static const String editTask = '/edit-task';
  static const String kanban = '/kanban';
  static const String newsDetail = '/news-detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case authWrapper:
        return MaterialPageRoute(builder: (_) => const AuthWrapper());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case registration:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case addTask:
        return MaterialPageRoute(builder: (_) => const AddTaskScreen());
      case editTask:
        final task = settings.arguments as Task;
        return MaterialPageRoute(builder: (_) => EditTaskScreen(task: task));
      case kanban:
        return MaterialPageRoute(builder: (_) => const KanbanScreen());
      case newsDetail:
        final article = settings.arguments as NewsArticle;
        return MaterialPageRoute(builder: (_) => NewsDetailScreen(article: article));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for \${settings.name}'),
            ),
          ),
        );
    }
  }
}
