import 'package:flutter/material.dart';
import 'features/flock/flock_screen.dart';
import 'features/knowledge/knowledge_screen.dart';
import 'features/trees/trees_screen.dart';
import 'features/gardens/gardens_screen.dart';

class HomesteadScaffold extends StatefulWidget {
  const HomesteadScaffold({super.key});

  @override
  State<HomesteadScaffold> createState() => _HomesteadScaffoldState();
}

class _HomesteadScaffoldState extends State<HomesteadScaffold> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    FlockScreen(),
    TreesScreen(),
    GardensScreen(),
    KnowledgeScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homestead Companion'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.egg, size: 32),
            label: 'Flock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.park, size: 32),
            label: 'Trees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grass, size: 32),
            label: 'Garden',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book, size: 32),
            label: 'Knowledge',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensure labels are always shown
      ),
    );
  }
}
