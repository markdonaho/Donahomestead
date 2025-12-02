import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime? date; // If null, it's a one-off task
  final bool isRecurring; // Helper to distinguish

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.date,
    this.isRecurring = false,
  });

  // Factory to create a Task from Firestore DocumentSnapshot
  factory Task.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      date: data['date'] != null ? (data['date'] as Timestamp).toDate() : null,
      isRecurring: data['isRecurring'] ?? false,
    );
  }

  // Convert Task to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'isRecurring': isRecurring,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? date,
    bool? isRecurring,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      isRecurring: isRecurring ?? this.isRecurring,
    );
  }
}
