import 'package:flutter/material.dart';

class WorkspaceDashboardCustomizationBar extends StatelessWidget {
  final VoidCallback onDone;
  final VoidCallback? onReset;

  const WorkspaceDashboardCustomizationBar({
    super.key,
    required this.onDone,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBFDBFE), width: 1),
      ),
      child: Row(
        children: [
          // ------------------------------------------------------
          // ICON
          // ------------------------------------------------------
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.dashboard_customize_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 14),

          // ------------------------------------------------------
          // MESSAGE
          // ------------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Customize Your Dashboard',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF17204D),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Drag and rearrange sections to make your workspace '
                  'work the way you do.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF52627A),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // ------------------------------------------------------
          // RESET
          // ------------------------------------------------------
          if (onReset != null)
            TextButton(
              onPressed: onReset,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF52627A),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Reset to Default',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),

          const SizedBox(width: 8),

          // ------------------------------------------------------
          // DONE
          // ------------------------------------------------------
          ElevatedButton.icon(
            onPressed: onDone,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            icon: const Icon(Icons.check_rounded, size: 18),
            label: const Text(
              'Done',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
