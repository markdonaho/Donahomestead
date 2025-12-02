import 'package:flutter/material.dart';

void main() {
  runApp(const HomesteadApp());
}

class HomesteadApp extends StatelessWidget {
  const HomesteadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homestead Companion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Homestead Companion Setup Complete'),
        ),
      ),
    );
  }
}
