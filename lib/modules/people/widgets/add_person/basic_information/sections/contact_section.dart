import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/person_text_field.dart';

class ContactSection extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String? preferredContactMethod;
  final ValueChanged<String?> onPreferredContactMethodChanged;

  const ContactSection({
    super.key,
    required this.emailController,
    required this.phoneController,
    required this.preferredContactMethod,
    required this.onPreferredContactMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(
          title: 'Contact information',
          subtitle: 'Add the best ways to reach this person.',
        ),

        const SizedBox(height: 20),

        PersonTextField(
          controller: emailController,
          label: 'Email address',
          hint: 'name@example.com',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
        ),

        const SizedBox(height: 16),

        PersonTextField(
          controller: phoneController,
          label: 'Phone number',
          hint: '(555) 555-5555',
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_outlined,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _PhoneNumberFormatter(),
          ],
        ),

        const SizedBox(height: 24),

        const Text(
          'Preferred contact method',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ContactMethodChip(
              label: 'Email',
              icon: Icons.email_outlined,
              isSelected: preferredContactMethod == 'email',
              onTap: () => onPreferredContactMethodChanged('email'),
            ),

            _ContactMethodChip(
              label: 'Phone',
              icon: Icons.phone_outlined,
              isSelected: preferredContactMethod == 'phone',
              onTap: () => onPreferredContactMethodChanged('phone'),
            ),

            _ContactMethodChip(
              label: 'Text',
              icon: Icons.chat_bubble_outline_rounded,
              isSelected: preferredContactMethod == 'text',
              onTap: () => onPreferredContactMethodChanged('text'),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionLabel({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2F3A4A),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

class _ContactMethodChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ContactMethodChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF5B3FC4);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF1EEFF) : const Color(0xFFFBFBFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? purple : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? purple : const Color(0xFF6B7280),
            ),

            const SizedBox(width: 8),

            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? purple : const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final buffer = StringBuffer();

    for (var i = 0; i < digits.length && i < 10; i++) {
      if (i == 0) buffer.write('(');
      if (i == 3) buffer.write(') ');
      if (i == 6) buffer.write('-');

      buffer.write(digits[i]);
    }

    final text = buffer.toString();

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
