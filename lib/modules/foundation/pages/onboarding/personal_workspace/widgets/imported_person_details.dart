import 'package:flutter/material.dart';

class ImportedPersonDetails extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String organizationalRole;

  const ImportedPersonDetails({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.organizationalRole,
  });

  @override
  Widget build(BuildContext context) {
    final fullName = [
      firstName.trim(),
      lastName.trim(),
    ].where((name) => name.isNotEmpty).join(' ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Column(
        children: [
          _DetailRow(
            icon: Icons.person_outline_rounded,
            label: 'Full name',
            value: fullName.isEmpty ? 'Not provided' : fullName,
          ),

          const _DetailDivider(),

          _DetailRow(
            icon: Icons.work_outline_rounded,
            label: 'Organization role',
            value: organizationalRole.isEmpty
                ? 'Not provided'
                : organizationalRole,
          ),

          const _DetailDivider(),

          _DetailRow(
            icon: Icons.mail_outline_rounded,
            label: 'Email',
            value: email.isEmpty ? 'Not provided' : email,
          ),

          const _DetailDivider(),

          _DetailRow(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: phone?.trim().isNotEmpty == true
                ? phone!.trim()
                : 'Not provided',
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 480;

        if (compact) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(),
                      const SizedBox(height: 4),
                      _buildValue(),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              _buildIcon(),
              const SizedBox(width: 16),
              SizedBox(width: 130, child: _buildLabel()),
              const SizedBox(width: 12),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _buildValue(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIcon() {
    return SizedBox(
      width: 28,
      child: Icon(icon, size: 22, color: const Color(0xFF344054)),
    );
  }

  Widget _buildLabel() {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF475467),
      ),
    );
  }

  Widget _buildValue() {
    return Text(
      value,
      textAlign: TextAlign.right,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF182230),
      ),
    );
  }
}

class _DetailDivider extends StatelessWidget {
  const _DetailDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFE4E7EC));
  }
}
