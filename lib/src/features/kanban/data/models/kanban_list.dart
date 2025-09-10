import 'package:cloud_firestore/cloud_firestore.dart';

class KanbanList {
  String id;
  String name;
  int order;
  String userId;

  KanbanList({
    required this.id,
    required this.name,
    required this.order,
    required this.userId,
  });

  // Add copyWith method
  KanbanList copyWith({
    String? id,
    String? name,
    int? order,
    String? userId,
  }) {
    return KanbanList(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      userId: userId ?? this.userId,
    );
  }

  factory KanbanList.fromMap(Map<String, dynamic> map, String id) {
    return KanbanList(
      id: id,
      name: map['name'] ?? '',
      order: map['order'] ?? 0,
      userId: map['userId'] ?? '',
    );
  }

  factory KanbanList.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return KanbanList(
      id: snapshot.id,
      name: data['name'] ?? '',
      order: data['order'] ?? 0,
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'order': order,
      'userId': userId,
    };
  }
}
