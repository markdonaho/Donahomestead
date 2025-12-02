import 'package:flutter/material.dart';
import 'flock_service.dart';
import 'task_model.dart';

class FlockScreen extends StatefulWidget {
  const FlockScreen({super.key});

  @override
  State<FlockScreen> createState() => _FlockScreenState();
}

class _FlockScreenState extends State<FlockScreen> {
  final FlockService _flockService = FlockService();

  @override
  void initState() {
    super.initState();
    _flockService.initializeDailyTasks();
  }

  void _showAddTaskDialog() {
    final TextEditingController controller = TextEditingController();
    bool isRecurring = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'e.g., Fix Coop Door',
                      border: OutlineInputBorder(),
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Repeat Daily'),
                    value: isRecurring,
                    onChanged: (value) {
                      setState(() {
                        isRecurring = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(fontSize: 18)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      if (isRecurring) {
                        _flockService.addDailyRoutineItem(controller.text);
                        // Also add to today's list immediately
                        final now = DateTime.now();
                        final today = DateTime(now.year, now.month, now.day);
                        _flockService.addTask(controller.text, isRecurring: true, date: today);
                      } else {
                        _flockService.addTask(controller.text, isRecurring: false);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Daily Tasks Section
          Text(
            'Daily To-Do',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          StreamBuilder<List<Task>>(
            stream: _flockService.getDailyTasks(today),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final tasks = snapshot.data!;
              if (tasks.isEmpty) {
                return const Text('No daily tasks found.');
              }

              return Column(
                children: tasks.map((task) => _buildTaskTile(task)).toList(),
              );
            },
          ),

          const SizedBox(height: 32),

          // One-off Tasks Section
          Text(
            'Other Tasks',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          StreamBuilder<List<Task>>(
            stream: _flockService.getIncompleteOneOffTasks(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData) {
                return const SizedBox(); // Loading or empty
              }

              final tasks = snapshot.data!;
              if (tasks.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('No other tasks pending.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                );
              }

              return Column(
                children: tasks.map((task) => _buildTaskTile(task)).toList(),
              );
            },
          ),
          
          const SizedBox(height: 32),

          // Flock Info Card
          Card(
            color: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Icon(Icons.pets, size: 48, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    'The Flock',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '6 Chickens',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Breeds: Rhode Island Red(3), Leghorn(1), Chocolate Orpington(1), Australorp(1)',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 80), // Space for FAB
        ],
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: _showAddTaskDialog,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.add, size: 40, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTaskTile(Task task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 22, // Large text
            fontWeight: FontWeight.w500,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? Colors.grey : Colors.black,
          ),
        ),
        leading: Transform.scale(
          scale: 1.5,
          child: Checkbox(
            value: task.isCompleted,
            onChanged: (bool? value) async {
              if (value != null) {
                try {
                  await _flockService.toggleTask(task.id, value);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              }
            },
            activeColor: Theme.of(context).colorScheme.primary,
            checkColor: Colors.white,
          ),
        ),
        onTap: () async {
          try {
            await _flockService.toggleTask(task.id, !task.isCompleted);
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          }
        },
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showEditTaskDialog(task);
            } else if (value == 'delete') {
              _confirmDeleteTask(task);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    final TextEditingController controller = TextEditingController(text: task.title);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _flockService.updateTask(task.id, controller.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteTask(Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task?'),
          content: Text(task.isRecurring
              ? 'This is a daily task. Do you want to remove it from your daily routine?'
              : 'Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                if (task.isRecurring) {
                  _flockService.removeDailyRoutineItem(task.title);
                }
                _flockService.deleteTask(task.id);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
