import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:charitask/modules/people/widgets/add_person/add_person_phone_formatter.dart';
import 'package:charitask/modules/people/widgets/add_person/add_person_text_field.dart';

class BasicInformationStep extends StatelessWidget {
  const BasicInformationStep({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.preferredNameController,
    required this.emailController,
    required this.phoneController,
    required this.preferredContactMethod,
    required this.onPreferredContactMethodChanged,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController preferredNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  final String? preferredContactMethod;
  final ValueChanged<String> onPreferredContactMethodChanged;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1050),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Basic Information',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2F3A4A),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tell us a little about this person.',
                      style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AddPersonTextField(
                                label: 'First Name',
                                controller: firstNameController,
                                hint: 'Enter first name',
                              ),
                            ),

                            const SizedBox(width: 20),

                            Expanded(
                              child: AddPersonTextField(
                                label: 'Last Name',
                                controller: lastNameController,
                                hint: 'Enter last name',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        AddPersonTextField(
                          label: 'Preferred Name',
                          controller: preferredNameController,
                          hint: 'Optional',
                          required: false,
                        ),

                        const SizedBox(height: 18),

                        Row(
                          children: [
                            Expanded(
                              child: AddPersonTextField(
                                label: 'Email Address',
                                controller: emailController,
                                hint: 'name@example.com',
                                keyboardType: TextInputType.emailAddress,
                                required: false,
                              ),
                            ),

                            const SizedBox(width: 20),

                            Expanded(
                              child: AddPersonTextField(
                                label: 'Phone Number',
                                controller: phoneController,
                                hint: '(555) 123-4567',
                                keyboardType: TextInputType.phone,
                                inputFormatters: [AddPersonPhoneFormatter()],
                                required: false,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F7FF),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE1DDFC)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    color: Color(0xFF5B4BC4),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'How does this person prefer to be contacted?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2F3A4A),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              const Text(
                                'Choose their preferred way to receive communications.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                ),
                              ),

                              const SizedBox(height: 12),

                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  _ContactMethodButton(
                                    label: 'Email',
                                    icon: Icons.email_outlined,
                                    isSelected:
                                        preferredContactMethod == 'Email',
                                    onTap: () =>
                                        onPreferredContactMethodChanged(
                                          'Email',
                                        ),
                                  ),

                                  _ContactMethodButton(
                                    label: 'Phone Call',
                                    icon: Icons.phone_outlined,
                                    isSelected:
                                        preferredContactMethod == 'Phone Call',
                                    onTap: () =>
                                        onPreferredContactMethodChanged(
                                          'Phone Call',
                                        ),
                                  ),

                                  _ContactMethodButton(
                                    label: 'Text Message',
                                    icon: Icons.chat_outlined,
                                    isSelected:
                                        preferredContactMethod ==
                                        'Text Message',
                                    onTap: () =>
                                        onPreferredContactMethodChanged(
                                          'Text Message',
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 48),

                  Container(
                    width: 1,
                    height: 420,
                    color: const Color(0xFFE5E7EB),
                  ),

                  const SizedBox(width: 48),

                  SizedBox(
                    width: 260,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Color(0xFF5B4BC4),
                                size: 28,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Why we ask',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2F3A4A),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20),

                          Text(
                            'This basic information helps your organization identify and connect with the right person.',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              const Text(
                'A profile photo or avatar can be added later.',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactMethodButton extends StatelessWidget {
  const _ContactMethodButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEDEAFF) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF5B4BC4)
                  : const Color(0xFFE1E5EC),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? const Color(0xFF5B4BC4)
                    : const Color(0xFF6B7280),
              ),

              const SizedBox(width: 8),

              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF5B4BC4)
                      : const Color(0xFF4B5563),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
