import 'package:flutter/material.dart';

import 'glance_card.dart';

class GroupsGlanceCard extends StatelessWidget {
  final Color accentColor;

  const GroupsGlanceCard({super.key, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return GlanceCard(
      icon: Icons.groups_2_outlined,
      title: 'Groups',
      headerAction: 'View all →',
      accentColor: const Color(0xFFF59E0B),
      child: Column(
        children: [
          _GroupRow(
            icon: Icons.storefront_outlined,
            iconColor: const Color(0xFF2563EB),
            name: 'ReStore Team',
            members: '18 members',
            progress: 0.78,
          ),
          _GroupRow(
            icon: Icons.volunteer_activism_outlined,
            iconColor: const Color(0xFF16A34A),
            name: 'Event Volunteers',
            members: '12 members',
            progress: 0.60,
          ),
          _GroupRow(
            icon: Icons.campaign_outlined,
            iconColor: const Color(0xFF7C4DFF),
            name: 'Outreach Crew',
            members: '6 members',
            progress: 0.42,
            showBottomBorder: false,
          ),
        ],
      ),
    );
  }
}

class _GroupRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String name;
  final String members;
  final double progress;
  final bool showBottomBorder;

  const _GroupRow({
    required this.icon,
    required this.iconColor,
    required this.name,
    required this.members,
    required this.progress,
    this.showBottomBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      decoration: BoxDecoration(
        border: showBottomBorder
            ? const Border(bottom: BorderSide(color: Color(0xFFE8ECF2)))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF33405C),
                  ),
                ),
              ),
              Text(
                members,
                style: const TextStyle(fontSize: 9, color: Color(0xFF68738A)),
              ),
            ],
          ),

          const SizedBox(height: 6),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: const Color(0xFFE8ECF4),
              valueColor: AlwaysStoppedAnimation<Color>(iconColor),
            ),
          ),
        ],
      ),
    );
  }
}
