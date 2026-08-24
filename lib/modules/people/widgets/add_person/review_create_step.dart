import 'package:flutter/material.dart';

class ReviewCreateStep extends StatelessWidget {
  const ReviewCreateStep({
    super.key,
    required this.connectionType,
    required this.firstName,
    required this.lastName,
    required this.preferredName,
    required this.email,
    required this.phone,
    required this.hasSystemAccess,
  });

  final String connectionType;
  final String firstName;
  final String lastName;
  final String preferredName;
  final String email;
  final String phone;
  final bool hasSystemAccess;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Review & Create',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2F3A4A),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Review the information before creating this person.',
                      style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              _ReviewSection(
                title: 'Connection',
                child: _ReviewRow(
                  label: 'Connection Type',
                  value: connectionType.isEmpty
                      ? 'Not selected'
                      : connectionType,
                ),
              ),

              const SizedBox(height: 24),

              _ReviewSection(
                title: 'Basic Information',
                child: Column(
                  children: [
                    _ReviewRow(
                      label: 'Name',
                      value: '$firstName $lastName'.trim().isEmpty
                          ? 'Not provided'
                          : '$firstName $lastName'.trim(),
                    ),
                    _ReviewRow(
                      label: 'Preferred Name',
                      value: preferredName.isEmpty
                          ? 'Not provided'
                          : preferredName,
                    ),
                    _ReviewRow(
                      label: 'Email',
                      value: email.isEmpty ? 'Not provided' : email,
                    ),
                    _ReviewRow(
                      label: 'Phone',
                      value: phone.isEmpty ? 'Not provided' : phone,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _ReviewSection(
                title: 'Assignments',
                child: const _ReviewRow(
                  label: 'Groups, Locations & Functional Roles',
                  value: 'Assignments can be reviewed here.',
                ),
              ),

              const SizedBox(height: 24),

              _ReviewSection(
                title: 'Access',
                child: _ReviewRow(
                  label: 'Account Access',
                  value: hasSystemAccess
                      ? 'System access enabled'
                      : 'No system access',
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E5EC)),
      ),
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
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 190,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, color: Color(0xFF2F3A4A)),
            ),
          ),
        ],
      ),
    );
  }
}
