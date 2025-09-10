import 'package:cloud_firestore/cloud_firestore.dart';

class KanbanList {
  final String? id;
  final String name;
  final int order;

  KanbanList({this.id, required this.name, required this.order});

  factory KanbanList.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return KanbanList(
      id: snapshot.id,
      name: data['name'] as String,
      order: data['order'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'order': order,
    };
  }
}
