import 'package:flutter/material.dart';
import '../../models/tree_model.dart';
import 'add_edit_tree_screen.dart';

class TreeDetailScreen extends StatelessWidget {
  final Tree tree;

  const TreeDetailScreen({super.key, required this.tree});

  @override
  Widget build(BuildContext context) {
    final age = _calculateAge(tree.plantedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(tree.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditTreeScreen(tree: tree),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          if (tree.photoUrl != null)
            Image.network(
              tree.photoUrl!,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          else
            Container(
              height: 200,
              color: Colors.grey[300],
              child: const Icon(Icons.park, size: 100, color: Colors.grey),
            ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tree.name,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  tree.type,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
                const SizedBox(height: 24),
                _buildInfoRow(context, 'Planted',
                    '${tree.plantedDate.year}-${tree.plantedDate.month}-${tree.plantedDate.day}'),
                const SizedBox(height: 16),
                _buildInfoRow(context, 'Age', age),
                const SizedBox(height: 32),
                Text(
                  'Notes',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  tree.notes.isNotEmpty ? tree.notes : 'No notes yet.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 20,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

  String _calculateAge(DateTime plantedDate) {
    final now = DateTime.now();
    final difference = now.difference(plantedDate);
    final days = difference.inDays;

    if (days < 30) {
      return '$days days';
    } else if (days < 365) {
      final months = (days / 30).floor();
      return '$months months';
    } else {
      final years = (days / 365).floor();
      final remainingMonths = ((days % 365) / 30).floor();
      if (remainingMonths > 0) {
        return '$years years, $remainingMonths months';
      }
      return '$years years';
    }
  }
}
