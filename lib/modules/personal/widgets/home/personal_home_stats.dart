import 'package:flutter/material.dart';

class PersonalHomeStats extends StatelessWidget {
  const PersonalHomeStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatCard(
            icon: Icons.calendar_today_outlined,
            title: "Today's Schedule",
            value: '4',
            subtitle: 'items today',
            iconBackground: Color(0xFFF0EBFF),
            iconColor: Color(0xFF7C4DFF),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            icon: Icons.dashboard_outlined,
            title: 'Pinned Workspace',
            value: 'Volunteer',
            subtitle: 'Coordinator',
            iconBackground: Color(0xFFE8F8FC),
            iconColor: Color(0xFF08738A),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle_outline_rounded,
            title: 'Active Tasks',
            value: '7',
            subtitle: 'open tasks',
            iconBackground: Color(0xFFF3F4F6),
            iconColor: Color(0xFF475467),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            icon: Icons.event_outlined,
            title: 'Upcoming Events',
            value: '3',
            subtitle: 'this week',
            iconBackground: Color(0xFFFFF4E8),
            iconColor: Color(0xFFB76E00),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color iconBackground;
  final Color iconColor;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.iconBackground,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7E8EE)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF273247),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF98A2B3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
