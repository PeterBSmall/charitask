import 'package:flutter/material.dart';

class FoundationWorkspace extends StatelessWidget {
  const FoundationWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foundation Workspace'),
      ),
      body: const Center(
        child: Text(
          'Welcome to ChariTask 2.0',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}