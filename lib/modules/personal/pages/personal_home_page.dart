import 'package:flutter/material.dart';

class PersonalHomePage extends StatelessWidget {
  const PersonalHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Personal Home',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
