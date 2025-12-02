import 'package:cloud_firestore/cloud_firestore.dart';

class KnowledgeItem {
  final String id;
  final String title;
  final String category; // 'Chicken', 'Veggie', 'Tree', 'Pest', 'General'
  final String content;
  final String? imageUrl;

  KnowledgeItem({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    this.imageUrl,
  });

  factory KnowledgeItem.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return KnowledgeItem(
      id: doc.id,
      title: data['title'] ?? '',
      category: data['category'] ?? 'General',
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'content': content,
      'imageUrl': imageUrl,
    };
  }

  KnowledgeItem copyWith({
    String? id,
    String? title,
    String? category,
    String? content,
    String? imageUrl,
  }) {
    return KnowledgeItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
