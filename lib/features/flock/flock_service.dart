import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_model.dart';

class FlockService {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');
  final CollectionReference _dailyRoutineCollection =
      FirebaseFirestore.instance.collection('daily_routine');

  // Get daily tasks for a specific date
  Stream<List<Task>> getDailyTasks(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _tasksCollection
        .where('isRecurring', isEqualTo: true)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThan: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromSnapshot(doc)).toList();
    });
  }

  // Get incomplete one-off tasks
  Stream<List<Task>> getIncompleteOneOffTasks() {
    return _tasksCollection
        .where('isRecurring', isEqualTo: false)
        .where('isCompleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromSnapshot(doc)).toList();
    });
  }

  // Toggle task completion
  Future<void> toggleTask(String taskId, bool isCompleted) async {
    await _tasksCollection.doc(taskId).update({'isCompleted': isCompleted});
  }

  // Update task title
  Future<void> updateTask(String taskId, String newTitle) async {
    await _tasksCollection.doc(taskId).update({'title': newTitle});
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }

  // Add a new task
  Future<void> addTask(String title, {bool isRecurring = false, DateTime? date}) async {
    final taskData = {
      'title': title,
      'isCompleted': false,
      'isRecurring': isRecurring,
      'date': date != null ? Timestamp.fromDate(date) : null,
      'createdAt': FieldValue.serverTimestamp(),
    };
    await _tasksCollection.add(taskData);
  }

  // Add item to daily routine
  Future<void> addDailyRoutineItem(String title) async {
    await _dailyRoutineCollection.add({
      'title': title,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Remove item from daily routine (by title, for simplicity in this MVP)
  Future<void> removeDailyRoutineItem(String title) async {
    final snapshot = await _dailyRoutineCollection.where('title', isEqualTo: title).get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // Initialize daily tasks
  Future<void> initializeDailyTasks() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // 1. Check if routine exists, if not seed it
    final routineSnapshot = await _dailyRoutineCollection.limit(1).get();
    if (routineSnapshot.docs.isEmpty) {
      final defaultTasks = [
        'Feed Chickens',
        'Water Chickens',
        'Collect Eggs',
        'Check Coop Door',
      ];
      final batch = FirebaseFirestore.instance.batch();
      for (final title in defaultTasks) {
        final docRef = _dailyRoutineCollection.doc();
        batch.set(docRef, {
          'title': title,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
    }

    // 2. Check if tasks exist for today
    final todayTasksSnapshot = await _tasksCollection
        .where('isRecurring', isEqualTo: true)
        .where('date', isEqualTo: Timestamp.fromDate(today))
        .limit(1)
        .get();

    if (todayTasksSnapshot.docs.isEmpty) {
      // 3. Fetch routine and create tasks
      final routineDocs = await _dailyRoutineCollection.get();
      final batch = FirebaseFirestore.instance.batch();

      for (final doc in routineDocs.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final title = data['title'] as String;
        
        final newTaskRef = _tasksCollection.doc();
        batch.set(newTaskRef, {
          'title': title,
          'isCompleted': false,
          'isRecurring': true,
          'date': Timestamp.fromDate(today),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
    }
  }
}
