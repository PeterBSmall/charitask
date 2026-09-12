import 'package:flutter/material.dart';

import 'glance_card.dart';

class VolunteersGlanceCard extends StatelessWidget {
  final Color accentColor;

  const VolunteersGlanceCard({super.key, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return GlanceCard(
      icon: Icons.groups_outlined,
      title: 'Volunteers',
      headerAction: 'View all →',
      accentColor: const Color(0xFF7C4DFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PersonRow(
            initials: 'JD',
            name: 'Jamie Diaz',
            joined: 'Joined 2 days ago',
          ),
          _PersonRow(
            initials: 'MK',
            name: 'Morgan Kim',
            joined: 'Joined 4 days ago',
          ),
          _PersonRow(
            initials: 'AL',
            name: 'Alex Lee',
            joined: 'Joined 6 days ago',
            showBottomBorder: false,
          ),

          const SizedBox(height: 8),

          const Text(
            '142 active volunteers',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6241D8),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Newest Members',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF33405C),
            ),
          ),

          const SizedBox(height: 4),

          _PersonRow(
            initials: 'JD',
            name: 'Jamie Diaz',
            joined: 'Joined 2 days ago',
          ),
          _PersonRow(
            initials: 'MK',
            name: 'Morgan Kim',
            joined: 'Joined 4 days ago',
          ),
          _PersonRow(
            initials: 'AL',
            name: 'Alex Lee',
            joined: 'Joined 6 days ago',
            showBottomBorder: false,
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initials;
  final Color color;

  const _Avatar({required this.initials, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w800,
            color: Color(0xFF4E4770),
          ),
        ),
      ),
    );
  }
}

class _PersonRow extends StatelessWidget {
  final String initials;
  final String name;
  final String joined;
  final bool showBottomBorder;

  const _PersonRow({
    required this.initials,
    required this.name,
    required this.joined,
    this.showBottomBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      decoration: BoxDecoration(
        border: showBottomBorder
            ? const Border(bottom: BorderSide(color: Color(0xFFE8ECF2)))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFFE8DFFF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF6241D8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF33405C),
              ),
            ),
          ),
          Text(
            joined,
            style: const TextStyle(fontSize: 8, color: Color(0xFF7A8498)),
          ),
        ],
      ),
    );
  }
}
