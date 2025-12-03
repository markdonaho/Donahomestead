import 'package:flutter/material.dart';
import 'tree_model.dart';
import 'trees_service.dart';

class AddEditTreeScreen extends StatefulWidget {
  final Tree? tree;

  const AddEditTreeScreen({super.key, this.tree});

  @override
  State<AddEditTreeScreen> createState() => _AddEditTreeScreenState();
}

class _AddEditTreeScreenState extends State<AddEditTreeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _photoUrlController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _plantedDate = DateTime.now();
  final TreesService _treesService = TreesService();

  @override
  void initState() {
    super.initState();
    if (widget.tree != null) {
      _nameController.text = widget.tree!.name;
      _typeController.text = widget.tree!.type;
      _photoUrlController.text = widget.tree!.photoUrl ?? '';
      _notesController.text = widget.tree!.notes;
      _plantedDate = widget.tree!.plantedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tree == null ? 'Add Tree' : 'Edit Tree'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Tree Name',
              hint: 'e.g., Honeycrisp Apple',
              validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a name' : null,
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _typeController,
              label: 'Tree Type',
              hint: 'e.g., Apple, Pear, Cherry',
              validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a type' : null,
            ),
            const SizedBox(height: 24),
            // Date Picker
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date Planted',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                ),
                child: Text(
                  '${_plantedDate.year}-${_plantedDate.month}-${_plantedDate.day}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _photoUrlController,
              label: 'Photo URL',
              hint: 'https://example.com/image.jpg',
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _notesController,
              label: 'Notes',
              hint: 'Any initial notes...',
              maxLines: 3,
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 60,
              child: ElevatedButton(
                onPressed: _saveTree,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  widget.tree == null ? 'Add Tree' : 'Save Changes',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        labelStyle: const TextStyle(fontSize: 20),
      ),
      style: const TextStyle(fontSize: 20),
      validator: validator,
      maxLines: maxLines,
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _plantedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _plantedDate = picked;
      });
    }
  }

  void _saveTree() {
    if (_formKey.currentState!.validate()) {
      final tree = Tree(
        id: widget.tree?.id ?? '', // ID is ignored for new trees in addTree
        name: _nameController.text,
        type: _typeController.text,
        plantedDate: _plantedDate,
        photoUrl: _photoUrlController.text.isNotEmpty
            ? _photoUrlController.text
            : null,
        notes: _notesController.text,
      );

      if (widget.tree == null) {
        _treesService.addTree(tree);
      } else {
        _treesService.updateTree(tree);
      }

      Navigator.pop(context);
    }
  }
}
