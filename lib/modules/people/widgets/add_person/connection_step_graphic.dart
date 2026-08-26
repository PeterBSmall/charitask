import 'package:flutter/material.dart';

class ConnectionStepGraphic extends StatelessWidget {
  const ConnectionStepGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF5B4BC4);
    const lightPurple = Color(0xFFF0EEFF);
    const darkText = Color(0xFF2F3A4A);
    const mutedText = Color(0xFF6B7280);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Visual connection diagram
          SizedBox(
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Connecting lines
                Positioned(
                  top: 78,
                  left: 48,
                  right: 48,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: purple.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // Left connection node
                Positioned(
                  left: 16,
                  top: 50,
                  child: _ConnectionNode(
                    icon: Icons.person_outline,
                    label: 'Person',
                    backgroundColor: lightPurple,
                    iconColor: purple,
                  ),
                ),

                // Center connection
                Positioned(
                  top: 42,
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: purple,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: purple.withValues(alpha: 0.20),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.link_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Connection',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: darkText,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right organization node
                Positioned(
                  right: 8,
                  top: 50,
                  child: _ConnectionNode(
                    icon: Icons.account_balance_outlined,
                    label: 'Organization',
                    backgroundColor: const Color(0xFFF1F5F9),
                    iconColor: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Every person starts with a connection.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: darkText,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Connect this person to your organization and define how they relate to your team.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, height: 1.6, color: mutedText),
          ),
        ],
      ),
    );
  }
}

class _ConnectionNode extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color iconColor;

  const _ConnectionNode({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 27, color: iconColor),
          ),

          const SizedBox(height: 8),

          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }
}
