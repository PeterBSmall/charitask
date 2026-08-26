import 'package:flutter/material.dart';

class DetailsHelpPanel extends StatelessWidget {
  const DetailsHelpPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildWhyWeAskCard(),

        const SizedBox(height: 20),

        _buildGoodToKnowCard(),
      ],
    );
  }

  Widget _buildWhyWeAskCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2DDF7)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Color(0xFF5B3FC4),
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'Why we ask',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2F3A4A),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Text(
            'These details help ChariTask understand how this person '
            'participates in your organization and make their profile '
            'more useful as your workspace grows.',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoodToKnowCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: Color(0xFF7B68CC),
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'Good to know',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2F3A4A),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Text(
            'People and roles can change over time. You can always update '
            'these details later as their relationship with your organization evolves.',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
