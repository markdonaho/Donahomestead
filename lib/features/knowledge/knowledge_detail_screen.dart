import 'package:flutter/material.dart';
import 'knowledge_model.dart';
import 'knowledge_editor_screen.dart';

class KnowledgeDetailScreen extends StatelessWidget {
  final KnowledgeItem item;

  const KnowledgeDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KnowledgeEditorScreen(item: item),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
              Image.network(
                item.imageUrl!,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(height: 300, color: Colors.grey[300], child: const Icon(Icons.broken_image, size: 50)),
              ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    label: Text(item.category),
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    item.content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
