import 'package:flutter/material.dart';

class PersonalHomeActivity extends StatelessWidget {
  const PersonalHomeActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF273247),
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View All',
                style: TextStyle(
                  color: Color(0xFF6547E8),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE7E8EE)),
          ),
          child: const Column(
            children: [
              _ActivityItem(
                icon: Icons.check_circle_outline_rounded,
                title: 'Task completed',
                description: 'Volunteer orientation checklist was completed.',
                time: 'Today, 10:24 AM',
                accent: Color(0xFF7C4DFF),
              ),
              Divider(height: 24),
              _ActivityItem(
                icon: Icons.groups_outlined,
                title: 'Joined a group',
                description: 'You joined the Holiday Fundraising Team.',
                time: 'Yesterday, 3:15 PM',
                accent: Color(0xFF06B6D4),
              ),
              Divider(height: 24),
              _ActivityItem(
                icon: Icons.event_outlined,
                title: 'Event updated',
                description: 'The Christmas Tree Sale schedule was updated.',
                time: 'Yesterday, 11:42 AM',
                accent: Color(0xFFE07A00),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String time;
  final Color accent;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 21, color: accent),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF273247),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: Color(0xFF718096),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                time,
                style: const TextStyle(fontSize: 11, color: Color(0xFF98A2B3)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
