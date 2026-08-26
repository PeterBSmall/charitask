import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'add_person_step_template.dart';
import 'add_person_story_panel.dart';
import 'basic_information/connection_status_section.dart';

class BasicInformationStep extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController preferredNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String connectionType;
  final String membershipStatus;
  final TextEditingController joinDateController;
  final ValueChanged<String> onMembershipStatusChanged;

  final String? preferredContactMethod;
  final ValueChanged<String?> onPreferredContactMethodChanged;

  const BasicInformationStep({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.preferredNameController,
    required this.emailController,
    required this.phoneController,
    required this.connectionType,
    required this.membershipStatus,
    required this.joinDateController,
    required this.onMembershipStatusChanged,
    required this.preferredContactMethod,
    required this.onPreferredContactMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AddPersonStepTemplate(
      storyContent: const AddPersonStoryPanel(
        title: 'People',
        highlightedText: 'power progress.',
        description:
            'Every person brings something valuable to your organization. '
            'Start by getting to know the basics.',
        icon: Icons.person_add_alt_1_rounded,
      ),

      title: 'Basic information',
      description:
          'Add the essential details that help identify and connect with this person.',

      child: _BasicInformationForm(
        firstNameController: firstNameController,
        lastNameController: lastNameController,
        preferredNameController: preferredNameController,
        emailController: emailController,
        phoneController: phoneController,

        connectionType: connectionType,
        membershipStatus: membershipStatus,
        joinDateController: joinDateController,
        onMembershipStatusChanged: onMembershipStatusChanged,

        preferredContactMethod: preferredContactMethod,
        onPreferredContactMethodChanged: onPreferredContactMethodChanged,
      ),

      sideContent: const _BasicInformationHelp(),
    );
  }
}

class _BasicInformationForm extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController preferredNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String connectionType;
  final String membershipStatus;
  final TextEditingController joinDateController;
  final ValueChanged<String> onMembershipStatusChanged;

  final String? preferredContactMethod;
  final ValueChanged<String?> onPreferredContactMethodChanged;

  const _BasicInformationForm({
    required this.firstNameController,
    required this.lastNameController,
    required this.preferredNameController,
    required this.emailController,
    required this.phoneController,

    required this.connectionType,
    required this.membershipStatus,
    required this.joinDateController,
    required this.onMembershipStatusChanged,

    required this.preferredContactMethod,
    required this.onPreferredContactMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel(
            title: 'Name',
            subtitle: 'How should this person appear in ChariTask?',
          ),

          const SizedBox(height: 20),

          LayoutBuilder(
            builder: (context, constraints) {
              final stackFields = constraints.maxWidth < 600;

              if (stackFields) {
                return Column(
                  children: [
                    _PersonTextField(
                      controller: firstNameController,
                      label: 'First name',
                      hint: 'Enter first name',
                      validator: _validateFirstName,
                      required: true,
                    ),

                    const SizedBox(height: 16),

                    _PersonTextField(
                      controller: lastNameController,
                      label: 'Last name',
                      hint: 'Enter last name',
                      validator: _validateLastName,
                      required: true,
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: _PersonTextField(
                      controller: firstNameController,
                      label: 'First name',
                      hint: 'Enter first name',
                      validator: _validateFirstName,
                      required: true,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: _PersonTextField(
                      controller: lastNameController,
                      label: 'Last name',
                      hint: 'Enter last name',
                      validator: _validateLastName,
                      required: true,
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 16),

          _PersonTextField(
            controller: preferredNameController,
            label: 'Preferred name',
            hint: 'Optional',
          ),

          const SizedBox(height: 32),

          const Divider(),

          const SizedBox(height: 28),

          const _SectionLabel(
            title: 'Contact information',
            subtitle: 'Add the best ways to reach this person.',
          ),

          const SizedBox(height: 20),

          _PersonTextField(
            controller: emailController,
            label: 'Email address',
            hint: 'name@example.com',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: _validateEmail,
          ),

          const SizedBox(height: 16),

          _PersonTextField(
            controller: phoneController,
            label: 'Phone number',
            hint: '(555) 555-5555',
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone_outlined,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _UsPhoneNumberFormatter(),
            ],
            validator: _validatePhone,
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
                selected: preferredContactMethod == 'email',
                onTap: () => onPreferredContactMethodChanged('email'),
              ),

              _ContactMethodChip(
                label: 'Phone',
                icon: Icons.phone_outlined,
                selected: preferredContactMethod == 'phone',
                onTap: () => onPreferredContactMethodChanged('phone'),
              ),

              _ContactMethodChip(
                label: 'Text',
                icon: Icons.chat_bubble_outline_rounded,
                selected: preferredContactMethod == 'text',
                onTap: () => onPreferredContactMethodChanged('text'),
              ),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String? _validateFirstName(String value) {
    if (value.trim().isEmpty) {
      return 'Enter a first name.';
    }

    return null;
  }

  String? _validateLastName(String value) {
    if (value.trim().isEmpty) {
      return 'Enter a last name.';
    }

    return null;
  }

  String? _validateEmail(String value) {
    final trimmedValue = value.trim();

    if (trimmedValue.isEmpty) {
      return null;
    }

    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

    if (!emailRegex.hasMatch(trimmedValue)) {
      return 'Enter a valid email address.';
    }

    return null;
  }

  String? _validatePhone(String value) {
    if (value.trim().isEmpty) {
      return null;
    }

    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length != 10) {
      return 'Enter a valid 10-digit phone number.';
    }

    return null;
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

class _PersonTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final String? Function(String value)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool required;

  const _PersonTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.prefixIcon,
    this.validator,
    this.inputFormatters,
    this.required = false,
  });

  @override
  State<_PersonTextField> createState() => _PersonTextFieldState();
}

class _PersonTextFieldState extends State<_PersonTextField> {
  late final FocusNode _focusNode;

  String? _errorText;
  bool _hasBeenFocused = false;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _hasBeenFocused = true;
      } else if (_hasBeenFocused) {
        _validate();
      }
    });

    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_errorText != null) {
      _validate();
    }
  }

  void _validate() {
    final validator = widget.validator;

    if (validator == null) return;

    final error = validator(widget.controller.text);

    if (error != _errorText && mounted) {
      setState(() {
        _errorText = error;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _errorText != null;

    const purple = Color(0xFF5B4BC4);
    const errorColor = Color(0xFFD14343);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),

            if (widget.required) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  color: Color(0xFFD14343),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 8),

        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            hintText: widget.hint,

            prefixIcon: widget.prefixIcon == null
                ? null
                : Icon(
                    widget.prefixIcon,
                    size: 20,
                    color: hasError ? errorColor : const Color(0xFF9CA3AF),
                  ),

            filled: true,
            fillColor: hasError
                ? const Color(0xFFFFFAFA)
                : const Color(0xFFFBFBFC),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? errorColor : const Color(0xFFE5E7EB),
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? errorColor : const Color(0xFFE5E7EB),
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? errorColor : purple,
                width: 2,
              ),
            ),
          ),
        ),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: hasError
              ? Padding(
                  key: ValueKey(_errorText),
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: errorColor,
                      ),

                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          _errorText!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: errorColor,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _UsPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    final limitedDigits = digits.length > 10 ? digits.substring(0, 10) : digits;

    String formatted = '';

    if (limitedDigits.isNotEmpty) {
      if (limitedDigits.length <= 3) {
        formatted = '($limitedDigits';
      } else if (limitedDigits.length <= 6) {
        formatted =
            '(${limitedDigits.substring(0, 3)}) '
            '${limitedDigits.substring(3)}';
      } else {
        formatted =
            '(${limitedDigits.substring(0, 3)}) '
            '${limitedDigits.substring(3, 6)}-'
            '${limitedDigits.substring(6)}';
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ContactMethodChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ContactMethodChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF0EDFF) : const Color(0xFFFBFBFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF5B4BC4) : const Color(0xFFE5E7EB),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected
                  ? const Color(0xFF5B4BC4)
                  : const Color(0xFF6B7280),
            ),

            const SizedBox(width: 8),

            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected
                    ? const Color(0xFF5B4BC4)
                    : const Color(0xFF4B5563),
              ),
            ),

            if (selected) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.check_circle_rounded,
                size: 18,
                color: Color(0xFF5B4BC4),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BasicInformationHelp extends StatelessWidget {
  const _BasicInformationHelp();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFF5B4BC4),
                    size: 24,
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

              SizedBox(height: 18),

              Text(
                'Basic information helps your team identify the right person, '
                'communicate with them, and keep your organization connected.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F1FF),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF5B4BC4)),

              SizedBox(height: 12),

              Text(
                'Tip',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2F3A4A),
                ),
              ),

              SizedBox(height: 6),

              Text(
                'You can always update this information later.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
