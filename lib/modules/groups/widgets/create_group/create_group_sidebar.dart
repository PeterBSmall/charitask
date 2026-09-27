import 'package:flutter/material.dart';

class CreateGroupSidebar extends StatelessWidget {
  final int currentStep;

  const CreateGroupSidebar({super.key, required this.currentStep});

  static const _descriptions = [
    'Define the group and its primary owner.',
    'Choose people and assign group roles.',
    'Connect the group to locations and programs.',
    'Set access and management permissions.',
    'Review everything before creating the group.',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.groups_rounded, size: 34, color: Color(0xFF06B6D4)),
          const SizedBox(height: 18),
          const Text(
            'Build your group',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _descriptions[currentStep],
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF64748B),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFECFEFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFA5F3FC)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 18,
                  color: Color(0xFF0891B2),
                ),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'You can customize group settings after the group is created.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: Color(0xFF155E75),
                    ),
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
