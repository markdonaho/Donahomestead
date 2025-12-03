import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'knowledge_model.dart';
import 'knowledge_service.dart';
import 'knowledge_detail_screen.dart';
import 'knowledge_editor_screen.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  final KnowledgeService _knowledgeService = KnowledgeService();
  String _searchQuery = '';
  String? _selectedCategory;


  final List<String> _categories = ['All', 'Chicken', 'Veggie', 'Tree', 'Pest', 'General'];

  @override
  void initState() {
    super.initState();
    // YouTube integration disabled by user request
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Knowledge Base'),
          actions: [],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Library', icon: Icon(Icons.library_books)),
              Tab(text: 'Learning Center', icon: Icon(Icons.video_library)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: LIBRARY (Existing Search + List)
            Column(
              children: [
                // Search and Filter Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Search Knowledge Base',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _categories.map((category) {
                            final isSelected = _selectedCategory == category || (_selectedCategory == null && category == 'All');
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(category),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCategory = category == 'All' ? null : category;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                // List of Items
                Expanded(
                  child: StreamBuilder<List<KnowledgeItem>>(
                    stream: _knowledgeService.getKnowledgeItems(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      var items = snapshot.data!;

                      // Filter by Search Query
                      if (_searchQuery.isNotEmpty) {
                        items = items.where((item) =>
                            item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            item.content.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
                      }

                      // Filter by Category
                      if (_selectedCategory != null) {
                        items = items.where((item) => item.category == _selectedCategory).toList();
                      }

                      if (items.isEmpty) {
                        return const Center(child: Text('No items found.'));
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => KnowledgeDetailScreen(item: item),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                                    Image.network(
                                      item.imageUrl!,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(height: 150, color: Colors.grey[300], child: const Icon(Icons.broken_image)),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.title,
                                                style: Theme.of(context).textTheme.titleLarge,
                                              ),
                                              const SizedBox(height: 8),
                                              Chip(
                                                label: Text(item.category),
                                                visualDensity: VisualDensity.compact,
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.grey),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Delete Item?'),
                                                content: Text('Are you sure you want to delete "${item.title}"?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                    onPressed: () {
                                                      _knowledgeService.deleteKnowledgeItem(item.id);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            // TAB 2: LEARNING CENTER (YouTube Player)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.construction, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Learning Center Coming Soon', style: TextStyle(fontSize: 24, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: SizedBox(
          width: 80,
          height: 80,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KnowledgeEditorScreen()),
              );
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add, size: 40, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
