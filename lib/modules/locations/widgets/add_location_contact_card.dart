import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/design_system.dart';
import 'package:charitask/shared/validation/ct_email_validator.dart';
import 'package:charitask/shared/validation/ct_phone_validator.dart';

class AddLocationContactCard extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController phoneExtensionController;
  final TextEditingController emailController;
  final TextEditingController contactNameController;
  final TextEditingController contactRoleController;
  final TextEditingController contactPhoneController;
  final TextEditingController contactPhoneExtensionController;

  const AddLocationContactCard({
    super.key,
    required this.phoneController,
    required this.phoneExtensionController,
    required this.emailController,
    required this.contactNameController,
    required this.contactRoleController,
    required this.contactPhoneController,
    required this.contactPhoneExtensionController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Green accent rail.
          Container(
            width: 4,
            height: 170,
            decoration: BoxDecoration(
              color: const Color(0xFF059669),
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header.
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F7F1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.contact_phone_outlined,
                        color: Color(0xFF059669),
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Contact Information',
                      style: AppTypography.title.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Phone, email, and primary contact for this location.',
                        style: AppTypography.body.copyWith(
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Location contact row.
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 700) {
                      return Column(
                        children: [
                          _phoneField(),
                          const SizedBox(height: AppSpacing.md),
                          _extensionField(
                            controller: phoneExtensionController,
                            label: 'Extension',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _emailField(),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(flex: 2, child: _phoneField()),
                        const SizedBox(width: AppSpacing.md),
                        SizedBox(
                          width: 130,
                          child: _extensionField(
                            controller: phoneExtensionController,
                            label: 'Extension',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(flex: 2, child: _emailField()),
                      ],
                    );
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                // Primary contact row.
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 700) {
                      return Column(
                        children: [
                          _contactNameField(),
                          const SizedBox(height: AppSpacing.md),
                          _contactPhoneField(),
                          const SizedBox(height: AppSpacing.md),
                          _extensionField(
                            controller: contactPhoneExtensionController,
                            label: 'Extension',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _contactRoleField(),
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _contactNameField()),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(flex: 2, child: _contactPhoneField()),
                        const SizedBox(width: AppSpacing.md),
                        SizedBox(
                          width: 130,
                          child: _extensionField(
                            controller: contactPhoneExtensionController,
                            label: 'Extension',
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                _contactRoleField(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _phoneField() {
    return TextFormField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: const [CTPhoneInputFormatter()],
      decoration: const InputDecoration(
        labelText: 'Location Phone',
        hintText: '(508) 555-1234',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        return CTPhoneValidator.validate(value, required: false);
      },
    );
  }

  Widget _extensionField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'e.g. 101',
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        labelText: 'Location Email',
        hintText: 'office@example.org',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        return CTEmailValidator.validate(value, required: false);
      },
    );
  }

  Widget _contactNameField() {
    return TextFormField(
      controller: contactNameController,
      decoration: const InputDecoration(
        labelText: 'Contact Name',
        hintText: 'e.g. John Smith',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _contactPhoneField() {
    return TextFormField(
      controller: contactPhoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: const [CTPhoneInputFormatter()],
      decoration: const InputDecoration(
        labelText: 'Contact Phone',
        hintText: '(508) 555-5678',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        return CTPhoneValidator.validate(value, required: false);
      },
    );
  }

  Widget _contactRoleField() {
    return TextFormField(
      controller: contactRoleController,
      decoration: const InputDecoration(
        labelText: 'Contact Role / Relationship',
        hintText: 'e.g. Store Manager',
        border: OutlineInputBorder(),
      ),
    );
  }
}
