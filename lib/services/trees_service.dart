import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tree_model.dart';

class TreesService {
  final CollectionReference _treesCollection =
      FirebaseFirestore.instance.collection('trees');

  Stream<List<Tree>> getTreesStream() {
    return _treesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Tree.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addTree(Tree tree) {
    return _treesCollection.add(tree.toMap());
  }

  Future<void> updateTree(Tree tree) {
    return _treesCollection.doc(tree.id).update(tree.toMap());
  }

  Future<void> deleteTree(String id) {
    return _treesCollection.doc(id).delete();
  }
}
