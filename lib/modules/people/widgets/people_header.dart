import 'package:flutter/material.dart';

class PeopleHeader extends StatelessWidget {
  const PeopleHeader({super.key, this.onAddPerson, this.onImportPeople});

  final VoidCallback? onAddPerson;
  final VoidCallback? onImportPeople;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.people_outline, size: 32, color: Color(0xFF5B4BC4)),

        const SizedBox(width: 16),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'People',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2F3A4A),
                ),
              ),

              SizedBox(height: 4),

              Text(
                'Manage and connect people in your organization.',
                style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),

        OutlinedButton.icon(
          onPressed: onAddPerson,
          icon: const Icon(Icons.add),
          label: const Text('Add Person'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
        ),

        const SizedBox(width: 12),

        ElevatedButton.icon(
          onPressed: onImportPeople,
          icon: const Icon(Icons.upload_outlined),
          label: const Text('Import People'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5B4BC4),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
        ),
      ],
    );
  }
}
