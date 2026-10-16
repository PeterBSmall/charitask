import 'package:flutter/material.dart';

class EditPersonSection {
  const EditPersonSection({
    required this.id,
    required this.title,
    required this.icon,
  });

  final String id;
  final String title;
  final IconData icon;
}

class EditPersonSectionNavigation extends StatelessWidget {
  const EditPersonSectionNavigation({
    super.key,
    required this.sections,
    required this.selectedSectionId,
    required this.onSectionSelected,
    required this.compact,
  });

  final List<EditPersonSection> sections;
  final String selectedSectionId;
  final ValueChanged<String> onSectionSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: sections.map((section) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildSectionButton(context, section),
            );
          }).toList(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(12, 8, 12, 16),
          child: Text(
            'PERSON PROFILE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: Color(0xFF7B8494),
            ),
          ),
        ),
        ...sections.map(
          (section) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildSectionButton(context, section),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionButton(BuildContext context, EditPersonSection section) {
    final theme = Theme.of(context);
    final selected = selectedSectionId == section.id;

    final foregroundColor = selected
        ? const Color(0xFF5B4BC4)
        : theme.colorScheme.onSurfaceVariant;

    return Material(
      color: selected ? const Color(0xFFEDE9FE) : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => onSectionSelected(section.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
            children: [
              Icon(section.icon, size: 20, color: foregroundColor),
              const SizedBox(width: 10),
              if (compact)
                Text(
                  section.title,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                )
              else
                Expanded(
                  child: Text(
                    section.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              if (selected && !compact) ...[
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Color(0xFF5B4BC4),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
