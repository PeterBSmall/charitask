import 'package:flutter/material.dart';
import 'package:charitask/modules/people/widgets/add_person/connection_step.dart';

class ConnectionStep extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String> onSelected;

  const ConnectionStep({
    super.key,
    required this.selectedType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              const Text(
                'How is this person connected?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2F3A4A),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Choose the primary way this person is connected to your organization.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
              ),

              const SizedBox(height: 40),

              Row(
                children: [
                  Expanded(
                    child: _ConnectionCard(
                      title: 'Internal',
                      description:
                          'They are part of your organization, such as an employee, volunteer, or internal team member.',
                      icon: Icons.groups_outlined,
                      selected: selectedType == 'internal',
                      onTap: () => onSelected('internal'),
                    ),
                  ),

                  const SizedBox(width: 24),

                  Expanded(
                    child: _ConnectionCard(
                      title: 'External',
                      description:
                          'They are connected to your organization, such as a donor, customer, vendor, or contact.',
                      icon: Icons.handshake_outlined,
                      selected: selectedType == 'external',
                      onTap: () => onSelected('external'),
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

class _ConnectionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ConnectionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFF5B4BC4) : const Color(0xFFE5E7EB),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 56,
              color: selected
                  ? const Color(0xFF5B4BC4)
                  : const Color(0xFF6B7280),
            ),

            const SizedBox(height: 20),

            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2F3A4A),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Color(0xFF6B7280),
              ),
            ),

            if (selected) ...[
              const SizedBox(height: 20),
              const Icon(Icons.check_circle, color: Color(0xFF5B4BC4)),
            ],
          ],
        ),
      ),
    );
  }
}
