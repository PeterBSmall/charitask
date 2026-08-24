import 'package:flutter/material.dart';

class AssignmentsStep extends StatelessWidget {
  const AssignmentsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 950),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Assignments',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2F3A4A),
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      'Connect this person to the parts of your organization where they belong.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              Row(
                children: [
                  Expanded(
                    child: _AssignmentCard(
                      icon: Icons.groups_outlined,
                      title: 'Groups',
                      description:
                          'Assign this person to one or more groups or teams.',
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: _AssignmentCard(
                      icon: Icons.location_on_outlined,
                      title: 'Locations',
                      description:
                          'Connect this person to one or more locations.',
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: _AssignmentCard(
                      icon: Icons.badge_outlined,
                      title: 'Functional Roles',
                      description: 'Assign the roles this person performs.',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _AssignmentCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E5EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: const Color(0xFF5B4BC4)),

          const SizedBox(height: 20),

          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2F3A4A),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF6B7280),
            ),
          ),

          const SizedBox(height: 20),

          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Assign'),
          ),
        ],
      ),
    );
  }
}
