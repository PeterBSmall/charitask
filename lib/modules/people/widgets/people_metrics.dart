import 'package:flutter/material.dart';

class PeopleMetrics extends StatelessWidget {
  final List<Map<String, dynamic>> people;

  const PeopleMetrics({super.key, required this.people});

  @override
  Widget build(BuildContext context) {
    final total = people.length;

    final active = people.where((person) {
      return person['status'] == 'active';
    }).length;

    final inactive = people.where((person) {
      return person['status'] == 'inactive';
    }).length;

    const cards = [
      _PeopleMetricData(
        icon: Icons.people_outline,
        label: 'People',
        subtitle: 'Total',
        iconColor: Color(0xFF5B4BC4),
      ),
      _PeopleMetricData(
        icon: Icons.check_circle_outline,
        label: 'Active',
        subtitle: 'Currently active',
        iconColor: Color(0xFF6B8E62),
      ),
      _PeopleMetricData(
        icon: Icons.mail_outline,
        label: 'Invited',
        subtitle: 'Pending invitation',
        iconColor: Color(0xFF5B4BC4),
      ),
      _PeopleMetricData(
        icon: Icons.person_off_outlined,
        label: 'Inactive',
        subtitle: 'Not currently active',
        iconColor: Color(0xFF6B7280),
      ),
    ];

    final values = [
      total.toString(),
      active.toString(),
      '—',
      inactive.toString(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 900;
        final columns = isNarrow ? 2 : 4;
        const spacing = 16.0;

        final cardWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(cards.length, (index) {
            final card = cards[index];

            return SizedBox(
              width: cardWidth,
              child: _PeopleMetricCard(
                icon: card.icon,
                value: values[index],
                label: card.label,
                subtitle: card.subtitle,
                iconColor: card.iconColor,
              ),
            );
          }),
        );
      },
    );
  }
}

class _PeopleMetricData {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color iconColor;

  const _PeopleMetricData({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.iconColor,
  });
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
                    height: 1,
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
