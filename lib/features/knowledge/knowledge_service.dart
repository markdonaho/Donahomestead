import 'package:cloud_firestore/cloud_firestore.dart';
import 'knowledge_model.dart';

class KnowledgeService {
  final CollectionReference _knowledgeCollection =
      FirebaseFirestore.instance.collection('knowledge_items');

  // Get all knowledge items
  Stream<List<KnowledgeItem>> getKnowledgeItems() {
    return _knowledgeCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => KnowledgeItem.fromSnapshot(doc)).toList();
    });
  }

  // Add new item
  Future<void> addKnowledgeItem(KnowledgeItem item) async {
    await _knowledgeCollection.add(item.toMap());
  }

  // Update existing item
  Future<void> updateKnowledgeItem(KnowledgeItem item) async {
    await _knowledgeCollection.doc(item.id).update(item.toMap());
  }

  // Delete item
  Future<void> deleteKnowledgeItem(String id) async {
    await _knowledgeCollection.doc(id).delete();
  }
}
