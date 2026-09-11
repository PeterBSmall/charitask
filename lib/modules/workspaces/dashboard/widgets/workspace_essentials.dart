import 'package:flutter/material.dart';

class WorkspaceEssentials extends StatelessWidget {
  final Color accentColor;

  const WorkspaceEssentials({super.key, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final actions = [
      (
        'Add a Volunteer',
        'Build your team by adding a volunteer.',
        Icons.person_add_alt_1_outlined,
        const Color(0xFF2563EB),
      ),
      (
        'Create a Shift',
        'Set up a shift and get volunteers signed up.',
        Icons.event_available_outlined,
        const Color(0xFF0F9D8A),
      ),
      (
        'Add an Event',
        'Create an event to engage your community.',
        Icons.calendar_month_outlined,
        const Color(0xFFF59E0B),
      ),
      (
        'Create a Group',
        'Organize volunteers with a group.',
        Icons.groups_outlined,
        const Color(0xFF7C4DFF),
      ),
      (
        'Create a Form',
        'Build registration forms, surveys, and applications.',
        Icons.description_outlined,
        const Color(0xFF4F46E5),
      ),
      (
        'Create a Project',
        'Organize larger initiatives.',
        Icons.folder_outlined,
        const Color(0xFF16A34A),
      ),
      (
        'Make a Schedule',
        'Generate recurring or one-time schedules.',
        Icons.calendar_today_outlined,
        const Color(0xFFD97706),
      ),
      (
        'Send an Invite',
        'Invite volunteers, leaders, and partners.',
        Icons.send_outlined,
        const Color(0xFFE85D75),
      ),
    ];

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SectionIcon(icon: Icons.bolt_rounded, color: accentColor),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The Essentials',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF17204D),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Quick actions to keep your volunteer program running smoothly.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF68738A)),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 10.0;

              final columns = constraints.maxWidth < 700 ? 2 : 4;

              final cardWidth =
                  (constraints.maxWidth - ((columns - 1) * spacing)) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final action in actions)
                    SizedBox(
                      width: cardWidth,
                      child: _ActionCard(
                        title: action.$1,
                        description: action.$2,
                        icon: action.$3,
                        accentColor: action.$4,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;

  const _ActionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFCFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 19, color: accentColor),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF27345B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9,
                    height: 1.2,
                    color: Color(0xFF7A8498),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 16, color: accentColor),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3E7EF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _SectionIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
