import 'package:cloud_firestore/cloud_firestore.dart';

class Tree {
  final String id;
  final String name;
  final String type;
  final DateTime plantedDate;
  final String? photoUrl;
  final String notes;

  Tree({
    required this.id,
    required this.name,
    required this.type,
    required this.plantedDate,
    this.photoUrl,
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'plantedDate': Timestamp.fromDate(plantedDate),
      'photoUrl': photoUrl,
      'notes': notes,
    };
  }

  factory Tree.fromMap(Map<String, dynamic> map, String id) {
    return Tree(
      id: id,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      plantedDate: (map['plantedDate'] as Timestamp).toDate(),
      photoUrl: map['photoUrl'],
      notes: map['notes'] ?? '',
    );
  }

  Tree copyWith({
    String? id,
    String? name,
    String? type,
    DateTime? plantedDate,
    String? photoUrl,
    String? notes,
  }) {
    return Tree(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      plantedDate: plantedDate ?? this.plantedDate,
      photoUrl: photoUrl ?? this.photoUrl,
      notes: notes ?? this.notes,
    );
  }
}
