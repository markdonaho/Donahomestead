import 'package:cloud_firestore/cloud_firestore.dart';
import 'garden_model.dart';

class GardenService {
  final CollectionReference _gardensCollection =
      FirebaseFirestore.instance.collection('gardens');

  Stream<List<Garden>> getGardensStream() {
    return _gardensCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Garden.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addGarden(Garden garden) {
    return _gardensCollection.add(garden.toMap());
  }

  Future<void> updateGarden(Garden garden) {
    return _gardensCollection.doc(garden.id).update(garden.toMap());
  }

  Future<void> deleteGarden(String id) {
    return _gardensCollection.doc(id).delete();
  }
}
