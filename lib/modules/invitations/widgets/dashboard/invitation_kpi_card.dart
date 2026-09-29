import 'package:flutter/material.dart';

class InvitationKpiCard extends StatelessWidget {
  const InvitationKpiCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.description,
    this.iconBackground,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final String description;
  final Color? iconBackground;
  final Color? iconColor;

  static const _text = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);
  static const _purple = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    final resolvedIconBackground =
        iconBackground ?? _purple.withValues(alpha: 0.10);
    final resolvedIconColor = iconColor ?? _purple;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: resolvedIconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: resolvedIconColor, size: 23),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
