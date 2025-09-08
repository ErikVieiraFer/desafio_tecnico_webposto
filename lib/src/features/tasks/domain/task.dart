import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_tecnico/src/features/tasks/domain/tag.dart';

class Task {
  final String? id;
  final String title;
  final String description;
  final bool isDone;
  final List<String> tagIds;

  // Este campo não é salvo no Firestore, mas populado após a busca.
  List<Tag> tags;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isDone = false,
    this.tagIds = const [],
    this.tags = const [],
  });

  factory Task.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isDone: data['isDone'] ?? false,
      tagIds: List<String>.from(data['tagIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
      'tagIds': tagIds,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isDone,
    List<String>? tagIds,
    List<Tag>? tags,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      tagIds: tagIds ?? this.tagIds,
      tags: tags ?? this.tags,
    );
  }
}
