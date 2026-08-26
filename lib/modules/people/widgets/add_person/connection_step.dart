import 'package:flutter/material.dart';

import 'add_person_step_template.dart';
import 'add_person_story_panel.dart';
import 'connection_step_graphic.dart';
import 'add_person_story_panel.dart';

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
    return AddPersonStepTemplate(
      storyContent: const AddPersonStoryPanel(
        title: 'People',
        highlightedText: 'power progress',
        description:
            'Add someone new to your organization and help them connect, '
            'contribute, and make an impact.',
      ),

      title: 'How is this person connected?',
      description:
          'Choose the primary way this person is connected to your organization.',

      sideContent: const ConnectionStepGraphic(),

      child: Row(
        children: [
          Expanded(
            child: _ConnectionCard(
              title: 'Internal',
              description:
                  'They are part of your organization, such as an employee, '
                  'volunteer, or internal team member.',
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
                  'They are connected to your organization, such as a donor, '
                  'customer, vendor, or contact.',
              icon: Icons.handshake_outlined,
              selected: selectedType == 'external',
              onTap: () => onSelected('external'),
            ),
          ),
        ],
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
    final bool isInternal = title == 'Internal';

    final Color backgroundColor = isInternal
        ? const Color(0xFFF5F1FF)
        : const Color(0xFFEFF8FA);

    final Color borderColor = selected
        ? (isInternal ? const Color(0xFF5B4BC4) : const Color(0xFF2F8F9D))
        : (isInternal ? const Color(0xFFE1D8F7) : const Color(0xFFD2E9ED));

    final Color iconColor = selected
        ? (isInternal ? const Color(0xFF5B4BC4) : const Color(0xFF2F8F9D))
        : (isInternal ? const Color(0xFF7565B8) : const Color(0xFF4C8F9A));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: selected
              ? backgroundColor
              : backgroundColor.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: selected ? 2 : 1),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: borderColor.withValues(alpha: 0.14),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(icon, size: 56, color: iconColor),

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

              Icon(
                Icons.check_circle,
                color: isInternal
                    ? const Color(0xFF5B4BC4)
                    : const Color(0xFF2F8F9D),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
