import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class FoundationActiveTasks extends StatelessWidget {
  const FoundationActiveTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 260),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7E9EF)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Tasks',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2F3A4A),
            ),
          ),

          SizedBox(height: 8),

          Text(
            'No active tasks yet.',
            style: TextStyle(fontSize: 14, color: Color(0xFF7B8494)),
          ),
        ],
      ),
    );
  }
}
