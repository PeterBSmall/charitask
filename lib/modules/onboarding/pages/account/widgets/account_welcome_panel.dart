import 'package:flutter/material.dart';

class AccountWelcomePanel extends StatelessWidget {
  const AccountWelcomePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(52, 48, 48, 48),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF24145F), Color(0xFF4B2DB8)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: const Center(
                  child: Text(
                    'C',
                    style: TextStyle(
                      color: Color(0xFF4326A8),
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Text(
                'ChariTask',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 70),

          const Text(
            'Welcome to\nChariTask',
            style: TextStyle(
              color: Colors.white,
              fontSize: 46,
              height: 1.08,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            width: 62,
            height: 5,
            decoration: BoxDecoration(
              color: Color(0xFF7652FF),
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'The all-in-one platform built for '
            'mission-driven organizations.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 48),

          const _Benefit(
            icon: Icons.people_alt_outlined,
            title: 'Bring your team together',
            description: 'Manage people, roles, and volunteers in one place.',
          ),

          const SizedBox(height: 30),

          const _Benefit(
            icon: Icons.calendar_month_outlined,
            title: 'Plan and stay organized',
            description: 'Schedule events, manage tasks, and track impact.',
          ),

          const SizedBox(height: 30),

          const _Benefit(
            icon: Icons.bar_chart_rounded,
            title: 'Make a bigger impact',
            description:
                'Gain insights, streamline operations, and focus on your mission.',
          ),

          const Spacer(),

          Container(height: 1, color: Colors.white.withValues(alpha: 0.25)),

          const SizedBox(height: 24),

          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.favorite_border_rounded,
                color: Color(0xFF8D70FF),
                size: 30,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Built for organizations that serve.\n'
                  'Designed for the people who lead.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _Benefit({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: const BoxDecoration(
            color: Color(0xFF5135C7),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.82),
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
