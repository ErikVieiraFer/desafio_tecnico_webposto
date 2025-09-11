import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_tecnico/src/features/tasks/domain/tag.dart';

class Task {
  final String? id;
  final String title;
  final String description;
  final bool isCompleted;
  final List<String> tagIds;
  final String? kanbanListId;
  final int position;
  final Timestamp? startDate;
  final Timestamp? endDate;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  List<Tag> tags;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.tagIds = const [],
    this.tags = const [],
    this.kanbanListId,
    required this.position,
    this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      tagIds: List<String>.from(data['tagIds'] ?? []),
      kanbanListId: data['kanbanListId'] as String?,
      position: data['position'] ?? 0,
      startDate: data['startDate'] as Timestamp?,
      endDate: data['endDate'] as Timestamp?,
      createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
      updatedAt: data['updatedAt'] as Timestamp? ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'tagIds': tagIds,
      'kanbanListId': kanbanListId,
      'position': position,
      'startDate': startDate,
      'endDate': endDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    List<String>? tagIds,
    List<Tag>? tags,
    String? kanbanListId,
    int? position,
    Timestamp? startDate,
    Timestamp? endDate,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      tagIds: tagIds ?? this.tagIds,
      tags: tags ?? this.tags,
      kanbanListId: kanbanListId ?? this.kanbanListId,
      position: position ?? this.position,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}