import 'package:flutter/material.dart';

class PersonalHomeQuote extends StatelessWidget {
  const PersonalHomeQuote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF5F0FF), Color(0xFFF9F7FF)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7E0FA)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inspirational Quote of the Day',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Color(0xFF6547E8),
            ),
          ),
          SizedBox(height: 10),
          Text(
            '“Alone we can do so little; together we can do so much.”',
            style: TextStyle(
              fontSize: 12,
              height: 1.45,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475467),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '— Helen Keller',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }
}
