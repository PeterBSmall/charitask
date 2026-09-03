import 'package:flutter/material.dart';

class PersonalWorkspaceActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonLabel;
  final bool isPrimary;
  final VoidCallback onPressed;

  const PersonalWorkspaceActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFFF8F6FF) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPrimary ? const Color(0xFFD9D0FF) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isPrimary
                      ? const Color(0xFFE9E4FF)
                      : const Color(0xFFF0F1F3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: isPrimary
                      ? const Color(0xFF6246E5)
                      : const Color(0xFF475467),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF182230),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: Color(0xFF667085),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: isPrimary
                    ? const Color(0xFF6246E5)
                    : Colors.white,
                foregroundColor: isPrimary
                    ? Colors.white
                    : const Color(0xFF344054),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: isPrimary
                      ? BorderSide.none
                      : const BorderSide(color: Color(0xFFD0D5DD)),
                ),
              ),
              child: Text(
                buttonLabel,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
