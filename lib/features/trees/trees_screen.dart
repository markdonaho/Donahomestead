import 'package:flutter/material.dart';
import '../../models/tree_model.dart';
import '../../services/trees_service.dart';
import 'add_edit_tree_screen.dart';
import 'tree_detail_screen.dart';

class TreesScreen extends StatelessWidget {
  const TreesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TreesService treesService = TreesService();

    return Scaffold(
      body: StreamBuilder<List<Tree>>(
        stream: treesService.getTreesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final trees = snapshot.data!;
          if (trees.isEmpty) {
            return const Center(
              child: Text(
                'No trees in the orchard yet.',
                style: TextStyle(fontSize: 24, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: trees.length,
            itemBuilder: (context, index) {
              final tree = trees[index];
              return _buildTreeCard(context, tree);
            },
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddEditTreeScreen()),
            );
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.add, size: 40, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTreeCard(BuildContext context, Tree tree) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TreeDetailScreen(tree: tree),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Photo Placeholder
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  image: tree.photoUrl != null
                      ? DecorationImage(
                          image: NetworkImage(tree.photoUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: tree.photoUrl == null
                    ? const Icon(Icons.park, size: 50, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 24),
              // Text Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tree.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tree.type,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[700],
                            fontSize: 20,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 40, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
