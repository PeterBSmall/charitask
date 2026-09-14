import 'package:flutter/material.dart';

class PersonalHomeActionCenter extends StatelessWidget {
  const PersonalHomeActionCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Action Center',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF273247),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE7E8EE)),
          ),
          child: Column(
            children: const [
              _ActionItem(
                icon: Icons.check_circle_outline_rounded,
                title: 'Complete volunteer orientation',
                subtitle: 'Due today',
                accent: Color(0xFF7C4DFF),
              ),
              Divider(height: 24),
              _ActionItem(
                icon: Icons.mail_outline_rounded,
                title: 'Review your pending invitation',
                subtitle: 'Needs your attention',
                accent: Color(0xFF06B6D4),
              ),
              Divider(height: 24),
              _ActionItem(
                icon: Icons.event_outlined,
                title: 'Prepare for tomorrow’s event',
                subtitle: 'Starts tomorrow',
                accent: Color(0xFFE07A00),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;

  const _ActionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 21, color: accent),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF273247),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Color(0xFF718096)),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
          color: Color(0xFF98A2B3),
        ),
      ],
    );
  }
}
