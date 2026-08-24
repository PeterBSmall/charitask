import 'package:flutter/material.dart';

class AccessStep extends StatelessWidget {
  final bool hasSystemAccess;
  final ValueChanged<bool> onAccessChanged;

  const AccessStep({
    super.key,
    required this.hasSystemAccess,
    required this.onAccessChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Access',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2F3A4A),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Configure this person’s access to ChariTask.',
                      style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              _AccessOption(
                icon: Icons.person_outline,
                title: 'No System Access',
                description:
                    'This person will be added to your organization but will not be able to sign in to ChariTask.',
                isSelected: !hasSystemAccess,
                onTap: () => onAccessChanged(false),
              ),

              const SizedBox(height: 20),

              _AccessOption(
                icon: Icons.login,
                title: 'Give System Access',
                description:
                    'This person will be able to access ChariTask and can be invited to sign in.',
                isSelected: hasSystemAccess,
                onTap: () => onAccessChanged(true),
              ),

              if (hasSystemAccess) ...[
                const SizedBox(height: 32),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F7FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFD8D2FF)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Color(0xFF5B4DB7)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'An invitation and account setup will be configured when this person is created.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4B5563),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AccessOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _AccessOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF5B4DB7);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF8F7FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? purple : const Color(0xFFD1D5DB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? purple.withValues(alpha: 0.12)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? purple : const Color(0xFF6B7280),
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2F3A4A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? purple : const Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}
