import 'package:flutter/material.dart';

class RoleBrandPanel extends StatelessWidget {
  const RoleBrandPanel({super.key});

  static const _purple = Color(0xFF5633D8);
  static const _darkText = Color(0xFF182238);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F7FD),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(36, 34, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ChariTask logo / wordmark
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: _purple,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.favorite_border_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'ChariTask',
                style: TextStyle(
                  color: _darkText,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 78),

          const Text(
            'Let’s build\n'
            'something\n'
            'meaningful\n'
            'together.',
            style: TextStyle(
              color: _darkText,
              fontSize: 28,
              height: 1.18,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'ChariTask helps mission-driven organizations '
            'work smarter, collaborate better, and amplify '
            'their impact.',
            style: TextStyle(
              color: Color(0xFF3F4960),
              fontSize: 15,
              height: 1.55,
            ),
          ),

          const Spacer(),

          // Simple mission illustration area
          Center(
            child: Container(
              width: 190,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFFEDE8FF),
                borderRadius: BorderRadius.circular(95),
              ),
              child: const Center(
                child: Icon(
                  Icons.favorite_rounded,
                  color: Color(0xFF9B83EA),
                  size: 70,
                ),
              ),
            ),
          ),

          const SizedBox(height: 34),

          // Help
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _purple, width: 1.5),
                ),
                child: const Center(
                  child: Text(
                    '?',
                    style: TextStyle(
                      color: _purple,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Need help?',
                    style: TextStyle(
                      color: _darkText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Visit our Help Center',
                    style: TextStyle(color: _purple, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
