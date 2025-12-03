import 'dart:convert';
import 'package:flutter/services.dart';
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

  // Get Learning Center Playlist ID
  Future<String> getLearningCenterPlaylistId() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('settings')
          .doc('learning_center')
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('playlistId')) {
          return data['playlistId'] as String;
        }
      }
    } catch (e) {
      // Ignore errors and return default
      // debugPrint('Error fetching playlist ID: $e');
    }

    return 'PLAnbjvO8DSpd7K7APVtil6OgjMKsBaQGk';
  }

  // Seed from JSON Asset
  Future<void> seedFromAsset() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/knowledge_data.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      final batch = FirebaseFirestore.instance.batch();

      for (var item in jsonList) {
        final docRef = _knowledgeCollection.doc();
        batch.set(docRef, item);
      }

      await batch.commit();
    } catch (e) {
      // debugPrint('Error seeding from asset: $e');
      rethrow;
    }
  }


}
