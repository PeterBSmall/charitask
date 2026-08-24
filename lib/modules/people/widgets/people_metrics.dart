import 'package:flutter/material.dart';

class PeopleMetrics extends StatelessWidget {
  const PeopleMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _PeopleMetricCard(
            icon: Icons.people_outline,
            value: '128',
            label: 'People',
            subtitle: 'Total',
            iconColor: Color(0xFF5B4BC4),
          ),
        ),

        SizedBox(width: 16),

        Expanded(
          child: _PeopleMetricCard(
            icon: Icons.check_circle_outline,
            value: '24',
            label: 'Active Today',
            subtitle: 'People clocked in',
            iconColor: Color(0xFF6B8E62),
          ),
        ),

        SizedBox(width: 16),

        Expanded(
          child: _PeopleMetricCard(
            icon: Icons.mail_outline,
            value: '12',
            label: 'Invited',
            subtitle: 'Pending invitation',
            iconColor: Color(0xFF5B4BC4),
          ),
        ),

        SizedBox(width: 16),

        Expanded(
          child: _PeopleMetricCard(
            icon: Icons.person_off_outlined,
            value: '8',
            label: 'Inactive',
            subtitle: 'Not currently active',
            iconColor: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

class _PeopleMetricCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String subtitle;
  final Color iconColor;

  const _PeopleMetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.subtitle,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 26,
                    height: 1.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2F3A4A),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.1,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.2,
                    color: Color(0xFF6B7280),
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
