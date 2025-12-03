import 'package:flutter/material.dart';
import 'garden_model.dart';
import 'garden_service.dart';

class GardenDetailScreen extends StatefulWidget {
  final Garden garden;

  const GardenDetailScreen({super.key, required this.garden});

  @override
  State<GardenDetailScreen> createState() => _GardenDetailScreenState();
}

class _GardenDetailScreenState extends State<GardenDetailScreen> {
  late Garden _garden;
  final GardenService _gardenService = GardenService();

  @override
  void initState() {
    super.initState();
    _garden = widget.garden;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_garden.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditNameDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Visual Layout (The "Stack")
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _garden.zones.length,
              itemBuilder: (context, index) {
                final zone = _garden.zones[index];
                return _buildZoneItem(zone, index);
              },
            ),
          ),
          // Add Button Area
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAddButton('Row', Icons.grass, Colors.green),
                _buildAddButton('Walkway', Icons.edit_road, Colors.brown),
                _buildAddButton('Bed', Icons.crop_square, Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneItem(GardenZone zone, int index) {
    Color color;
    IconData icon;
    String title;

    switch (zone.type.toLowerCase()) {
      case 'row':
        color = Colors.green[100]!;
        icon = Icons.grass;
        title = zone.content ?? 'Empty Row';
        break;
      case 'walkway':
        color = Colors.brown[100]!;
        icon = Icons.edit_road;
        title = 'Walkway';
        break;
      case 'bed':
        color = Colors.orange[100]!;
        icon = Icons.crop_square;
        title = zone.content ?? 'Raised Bed';
        break;
      default:
        color = Colors.grey[200]!;
        icon = Icons.help_outline;
        title = 'Unknown';
    }

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _deleteZone(index);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      child: InkWell(
        onTap: () => _showEditZoneDialog(zone, index),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 30, color: Colors.black54),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              if (zone.width != null)
                Text(
                  zone.width!,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(String label, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () => _showAddZoneDialog(label),
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  void _showAddZoneDialog(String type) {
    final TextEditingController contentController = TextEditingController();
    final TextEditingController widthController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add $type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (type != 'Walkway')
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    hintText: 'e.g., Potatoes, Corn',
                  ),
                  autofocus: true,
                ),
              const SizedBox(height: 16),
              TextField(
                controller: widthController,
                decoration: const InputDecoration(
                  labelText: 'Width (Optional)',
                  hintText: 'e.g., 2ft',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(fontSize: 20)),
            ),
            ElevatedButton(
              onPressed: () {
                _addZone(type, contentController.text, widthController.text);
                Navigator.pop(context);
              },
              child: const Text('Add', style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );
  }

  void _addZone(String type, String content, String width) {
    final newZone = GardenZone(
      type: type.toLowerCase(),
      content: content.isNotEmpty ? content : null,
      width: width.isNotEmpty ? width : null,
      status: 'planned',
    );

    final updatedZones = List<GardenZone>.from(_garden.zones)..add(newZone);
    final updatedGarden = _garden.copyWith(zones: updatedZones);

    setState(() {
      _garden = updatedGarden;
    });

    _gardenService.updateGarden(updatedGarden);
  }

  void _deleteZone(int index) {
    final updatedZones = List<GardenZone>.from(_garden.zones)..removeAt(index);
    final updatedGarden = _garden.copyWith(zones: updatedZones);

    setState(() {
      _garden = updatedGarden;
    });

    _gardenService.updateGarden(updatedGarden);
  }

  void _showEditNameDialog() {
    final TextEditingController nameController =
        TextEditingController(text: _garden.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Garden Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Garden Name',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(fontSize: 20)),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final updatedGarden =
                      _garden.copyWith(name: nameController.text);
                  setState(() {
                    _garden = updatedGarden;
                  });
                  _gardenService.updateGarden(updatedGarden);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save', style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );
  }

  void _showEditZoneDialog(GardenZone zone, int index) {
    final TextEditingController contentController =
        TextEditingController(text: zone.content);
    final TextEditingController widthController =
        TextEditingController(text: zone.width);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ${zone.type}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (zone.type.toLowerCase() != 'walkway')
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    hintText: 'e.g., Potatoes, Corn',
                  ),
                  autofocus: true,
                ),
              const SizedBox(height: 16),
              TextField(
                controller: widthController,
                decoration: const InputDecoration(
                  labelText: 'Width (Optional)',
                  hintText: 'e.g., 2ft',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(fontSize: 20)),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedZone = zone.copyWith(
                  content: contentController.text.isNotEmpty
                      ? contentController.text
                      : null,
                  width: widthController.text.isNotEmpty
                      ? widthController.text
                      : null,
                );

                final updatedZones = List<GardenZone>.from(_garden.zones);
                updatedZones[index] = updatedZone;
                final updatedGarden = _garden.copyWith(zones: updatedZones);

                setState(() {
                  _garden = updatedGarden;
                });

                _gardenService.updateGarden(updatedGarden);
                Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );
  }
}
