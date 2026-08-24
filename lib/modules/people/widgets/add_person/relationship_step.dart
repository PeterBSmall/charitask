import 'package:flutter/material.dart';

class RelationshipStep extends StatelessWidget {
  const RelationshipStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Relationship Details',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2F3A4A),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Define this person’s relationship with your organization.',
                      style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                'Relationship Type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select relationship type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Donor', child: Text('Donor')),
                  DropdownMenuItem(value: 'Customer', child: Text('Customer')),
                  DropdownMenuItem(value: 'Vendor', child: Text('Vendor')),
                  DropdownMenuItem(value: 'Partner', child: Text('Partner')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
