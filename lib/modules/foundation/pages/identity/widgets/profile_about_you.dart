import 'package:flutter/material.dart';

class ProfileAboutYou extends StatelessWidget {
  final String firstName;
  final String lastName;
  final TextEditingController preferredNameController;
  final String? pronouns;
  final ValueChanged<String?> onPronounsChanged;

  const ProfileAboutYou({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.preferredNameController,
    required this.pronouns,
    required this.onPronounsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile Photo',
            style: TextStyle(
              color: Color(0xFF263248),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0ECFF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  size: 42,
                  color: Color(0xFF6246E5),
                ),
              ),

              const SizedBox(width: 16),

              OutlinedButton.icon(
                onPressed: () {
                  // Photo picker will be connected here.
                },
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Add photo'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF6246E5),
                  side: const BorderSide(color: Color(0xFFB9A8FF)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          Row(
            children: [
              Expanded(
                child: _ReadOnlyField(
                  label: 'First Name',
                  value: firstName,
                  required: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ReadOnlyField(
                  label: 'Last Name',
                  value: lastName,
                  required: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          TextField(
            controller: preferredNameController,
            decoration: InputDecoration(
              labelText: 'Preferred Name',
              hintText: 'What should we call you?',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFD9DDE7)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF6246E5),
                  width: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          DropdownButtonFormField<String>(
            initialValue: pronouns,
            decoration: InputDecoration(
              labelText: 'Pronouns',
              hintText: 'Select your pronouns',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFD9DDE7)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF6246E5),
                  width: 1.5,
                ),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'She / Her', child: Text('She / Her')),
              DropdownMenuItem(value: 'He / Him', child: Text('He / Him')),
              DropdownMenuItem(
                value: 'They / Them',
                child: Text('They / Them'),
              ),
              DropdownMenuItem(
                value: 'Prefer not to say',
                child: Text('Prefer not to say'),
              ),
            ],
            onChanged: onPronounsChanged,
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final bool required;

  const _ReadOnlyField({
    required this.label,
    required this.value,
    required this.required,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        filled: true,
        fillColor: const Color(0xFFF8F9FC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E3EB)),
        ),
      ),
    );
  }
}
