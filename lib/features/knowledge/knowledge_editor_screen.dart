import 'package:flutter/material.dart';
import 'knowledge_model.dart';
import 'knowledge_service.dart';

class KnowledgeEditorScreen extends StatefulWidget {
  final KnowledgeItem? item; // If null, we are adding a new item

  const KnowledgeEditorScreen({super.key, this.item});

  @override
  State<KnowledgeEditorScreen> createState() => _KnowledgeEditorScreenState();
}

class _KnowledgeEditorScreenState extends State<KnowledgeEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String _selectedCategory = 'General';
  final KnowledgeService _knowledgeService = KnowledgeService();

  final List<String> _categories = ['Chicken', 'Veggie', 'Tree', 'Pest', 'General'];

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _titleController.text = widget.item!.title;
      _contentController.text = widget.item!.content;
      _imageUrlController.text = widget.item!.imageUrl ?? '';
      _selectedCategory = widget.item!.category;
    }
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      final newItem = KnowledgeItem(
        id: widget.item?.id ?? '', // ID is ignored for new items
        title: _titleController.text,
        category: _selectedCategory,
        content: _contentController.text,
        imageUrl: _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
      );

      if (widget.item == null) {
        await _knowledgeService.addKnowledgeItem(newItem);
      } else {
        await _knowledgeService.updateKnowledgeItem(newItem);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Knowledge' : 'Edit Knowledge'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              items: _categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL (Optional)'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content', alignLabelWithHint: true),
              maxLines: 10,
              validator: (value) => value == null || value.isEmpty ? 'Please enter content' : null,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveItem,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
