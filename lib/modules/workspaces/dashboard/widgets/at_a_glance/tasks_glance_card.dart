import 'package:flutter/material.dart';

import 'glance_card.dart';

class TasksGlanceCard extends StatelessWidget {
  final Color accentColor;

  const TasksGlanceCard({super.key, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return GlanceCard(
      icon: Icons.check_box_outlined,
      title: 'Tasks',
      headerAction: 'View all →',
      accentColor: accentColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '3 open',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
              const Text(
                '  •  5 completed',
                style: TextStyle(fontSize: 11, color: Color(0xFF7A8498)),
              ),
            ],
          ),

          const SizedBox(height: 10),

          _TaskRow(
            icon: Icons.local_fire_department_rounded,
            iconColor: const Color(0xFFE53935),
            title: 'Order name badges',
            due: 'Today',
            dueColor: const Color(0xFFE53935),
          ),

          _TaskRow(
            icon: Icons.warning_amber_rounded,
            iconColor: const Color(0xFFF59E0B),
            title: 'Follow up with new volunteers',
            due: 'Tomorrow',
            dueColor: const Color(0xFFF59E0B),
          ),

          _TaskRow(
            icon: Icons.menu_book_rounded,
            iconColor: const Color(0xFF2563EB),
            title: 'Prepare training materials',
            due: 'May 20',
            dueColor: const Color(0xFF68738A),
          ),

          const SizedBox(height: 10),

          Row(
            children: const [
              Text(
                'Progress',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF33405C),
                ),
              ),
              Spacer(),
              Text(
                '65% complete',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF68738A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: LinearProgressIndicator(
              value: 0.65,
              minHeight: 7,
              backgroundColor: Color(0xFFE8ECF4),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
            ),
          ),

          const SizedBox(height: 7),

          Row(
            children: const [
              Text(
                '3 Open',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2563EB),
                ),
              ),
              SizedBox(width: 10),
              Text(
                '•',
                style: TextStyle(fontSize: 10, color: Color(0xFF9AA3B5)),
              ),
              SizedBox(width: 10),
              Text(
                '5 Completed',
                style: TextStyle(fontSize: 10, color: Color(0xFF68738A)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String due;
  final Color dueColor;

  const _TaskRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.due,
    required this.dueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE8ECF2))),
      ),
      child: Row(
        children: [
          Container(
            width: 23,
            height: 23,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 13, color: iconColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF33405C),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            due,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: dueColor,
            ),
          ),
        ],
      ),
    );
  }
}
