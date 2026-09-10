import 'package:flutter/material.dart';

import '../models/workspace_dashboard_config.dart';

class WorkspaceHealthCard extends StatelessWidget {
  final WorkspaceDashboardConfig config;

  const WorkspaceHealthCard({super.key, required this.config});

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
                  Icons.favorite_outline,
                  size: 21,
                  color: config.accentColor,
                ),
              ),

              const SizedBox(width: 11),

              const Expanded(
                child: Text(
                  'Workspace Health',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF17204D),
                  ),
                ),
              ),

              Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: config.accentColor,
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '92%',
                style: TextStyle(
                  fontSize: 30,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF17204D),
                ),
              ),

              const SizedBox(width: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Excellent',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4F8A52),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'Based on key activity across your workspace.',
            style: TextStyle(
              fontSize: 12,
              height: 1.35,
              color: Color(0xFF68738A),
            ),
          ),

          const SizedBox(height: 14),

          _buildHealthRow(
            icon: Icons.check_circle,
            label: 'Shift coverage',
            value: '87%',
          ),

          _buildHealthRow(
            icon: Icons.check_circle,
            label: 'Volunteer engagement',
            value: 'High',
          ),

          _buildHealthRow(
            icon: Icons.check_circle,
            label: 'Open tasks',
            value: '3',
          ),

          _buildHealthRow(
            icon: Icons.check_circle,
            label: 'Event participation',
            value: 'Strong',
          ),

          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'View details →',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: config.accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Icon(icon, size: 17, color: const Color(0xFF65A765)),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Color(0xFF4E5A72)),
            ),
          ),

          const SizedBox(width: 8),

          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF33405C),
            ),
          ),
        ],
      ),
    );
  }
}
