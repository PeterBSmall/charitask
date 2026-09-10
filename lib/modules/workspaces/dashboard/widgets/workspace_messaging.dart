import 'package:flutter/material.dart';

import '../models/workspace_dashboard_config.dart';

class WorkspaceMessaging extends StatelessWidget {
  final WorkspaceDashboardConfig config;

  const WorkspaceMessaging({super.key, required this.config});

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
                  Icons.chat_bubble_outline_rounded,
                  size: 20,
                  color: config.accentColor,
                ),
              ),

              const SizedBox(width: 11),

              const Expanded(
                child: Text(
                  'Internal Messaging',
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

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: config.accentColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: config.accentColor.withValues(alpha: 0.10),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: config.accentColor.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'PS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF34416B),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Peter Small',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF27345B),
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        'Reminder: Please log your hours for last week by Monday. Thanks!',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          height: 1.3,
                          color: Color(0xFF68738A),
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        'Today at 9:15 AM',
                        style: TextStyle(fontSize: 9, color: Color(0xFF8A93A5)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Icon(
                Icons.mark_chat_unread_outlined,
                size: 16,
                color: config.accentColor,
              ),
              const SizedBox(width: 7),
              const Expanded(
                child: Text(
                  '2 unread messages',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF68738A),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: config.accentColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
