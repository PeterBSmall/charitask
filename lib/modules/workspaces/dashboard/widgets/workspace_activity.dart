import 'package:flutter/material.dart';

import '../models/workspace_dashboard_config.dart';

class WorkspaceActivity extends StatelessWidget {
  final WorkspaceDashboardConfig config;

  const WorkspaceActivity({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE1E6F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: config.accentColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.history_rounded,
                  size: 21,
                  color: config.accentColor,
                ),
              ),

              const SizedBox(width: 11),

              const Expanded(
                child: Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF17204D),
                  ),
                ),
              ),

              Text(
                'View all →',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: config.accentColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _buildActivityItem(
            icon: Icons.person_add_alt_1_rounded,
            label: 'Jamie Diaz joined Volunteer Coordinator',
            time: '2 hours ago',
          ),

          _buildActivityItem(
            icon: Icons.event_available_outlined,
            label: 'Community Clean-Up event created',
            time: 'Yesterday at 9:30 AM',
          ),

          _buildActivityItem(
            icon: Icons.check_circle_outline_rounded,
            label: 'Morgan Kim accepted shift invitation',
            time: 'Yesterday at 3:45 PM',
          ),

          _buildActivityItem(
            icon: Icons.description_outlined,
            label: 'Volunteer Orientation form submitted',
            time: 'May 16, 2026 at 11:20 AM',
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String label,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: config.accentColor.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: config.accentColor),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF33405C),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF7A8499),
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
