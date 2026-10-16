import 'package:flutter/material.dart';

import 'package:charitask/modules/people/domain/models/person_credential.dart';
import 'package:charitask/modules/people/widgets/add_person/credential_entry_dialog.dart';

class CredentialsComplianceCard extends StatelessWidget {
  final List<PersonCredentialDraft> credentials;
  final ValueChanged<List<PersonCredentialDraft>> onChanged;

  const CredentialsComplianceCard({
    super.key,
    required this.credentials,
    required this.onChanged,
  });

  static const _cyan = Color(0xFF0891B2);
  static const _navy = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  bool _isExpired(PersonCredentialDraft credential) {
    final expiration = credential.expirationDate;
    if (expiration == null) return false;

    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final expirationOnly = DateTime(
      expiration.year,
      expiration.month,
      expiration.day,
    );

    return expirationOnly.isBefore(todayOnly);
  }

  bool _isExpiringSoon(PersonCredentialDraft credential) {
    final expiration = credential.expirationDate;
    if (expiration == null || _isExpired(credential)) return false;

    if (!credential.status.isSuccessful) return false;

    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final expirationOnly = DateTime(
      expiration.year,
      expiration.month,
      expiration.day,
    );

    return !expirationOnly.isAfter(todayOnly.add(const Duration(days: 30)));
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Color _statusColor(PersonCredentialDraft credential) {
    if (_isExpired(credential)) {
      return const Color(0xFFB91C1C);
    }

    if (_isExpiringSoon(credential)) {
      return const Color(0xFFB45309);
    }

    switch (credential.status) {
      case CredentialStatus.verified:
      case CredentialStatus.cleared:
        return const Color(0xFF047857);
      case CredentialStatus.pending:
      case CredentialStatus.reviewRequired:
        return const Color(0xFFB45309);
      case CredentialStatus.rejected:
      case CredentialStatus.notCleared:
        return const Color(0xFFB91C1C);
    }
  }

  String _statusLabel(PersonCredentialDraft credential) {
    if (_isExpired(credential)) return 'Expired';
    if (_isExpiringSoon(credential)) return 'Expiring Soon';

    return credential.status.label;
  }

  Future<void> _addCredential(BuildContext context) async {
    final result = await showDialog<PersonCredentialDraft>(
      context: context,
      builder: (_) => const CredentialEntryDialog(),
    );

    if (result == null || !context.mounted) return;

    onChanged([...credentials, result]);
  }

  Future<void> _editCredential(BuildContext context, int index) async {
    final result = await showDialog<PersonCredentialDraft>(
      context: context,
      builder: (_) =>
          CredentialEntryDialog(initialCredential: credentials[index]),
    );

    if (result == null || !context.mounted) return;

    final updated = List<PersonCredentialDraft>.from(credentials);
    updated[index] = result;

    onChanged(updated);
  }

  Future<void> _removeCredential(BuildContext context, int index) async {
    final credential = credentials[index];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove Credential?'),
        content: Text(
          'Remove "${credential.credentialName}" from this person\'s '
          'draft credentials?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB91C1C),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final updated = List<PersonCredentialDraft>.from(credentials)
      ..removeAt(index);

    onChanged(updated);
  }

  Widget _metric({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 12, color: _muted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _credentialTile(
    BuildContext context,
    int index,
    PersonCredentialDraft credential,
  ) {
    final statusColor = _statusColor(credential);
    final expired = _isExpired(credential);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  credential.category.label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF075985),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel(credential),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            credential.credentialName,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _navy,
            ),
          ),
          if (credential.issuingOrganization != null &&
              credential.issuingOrganization!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              credential.issuingOrganization!,
              style: const TextStyle(fontSize: 13, color: _muted),
            ),
          ],
          if (credential.issueDate != null ||
              credential.expirationDate != null) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                if (credential.issueDate != null)
                  Text(
                    'Issued ${_formatDate(credential.issueDate!)}',
                    style: const TextStyle(fontSize: 12, color: _muted),
                  ),
                if (credential.expirationDate != null)
                  Text(
                    '${expired ? 'Expired' : 'Expires'} '
                    '${_formatDate(credential.expirationDate!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: expired ? const Color(0xFFB91C1C) : _muted,
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _editCredential(context, index),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit'),
              ),
              IconButton(
                tooltip: 'Remove credential',
                onPressed: () => _removeCredential(context, index),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFB91C1C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final verifiedCount = credentials
        .where(
          (credential) =>
              credential.status.isSuccessful && !_isExpired(credential),
        )
        .length;

    final expiringCount = credentials.where(_isExpiringSoon).length;

    final pendingCount = credentials
        .where((credential) => credential.status == CredentialStatus.pending)
        .length;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFCFE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB6E3EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 540;

              final heading = Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.workspace_premium_outlined,
                      color: _cyan,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Credentials & Compliance',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: _navy,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Track certifications, licenses, background '
                          'checks, and training.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: _muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              final addButton = OutlinedButton.icon(
                onPressed: () => _addCredential(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Credential'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _cyan,
                  side: const BorderSide(color: _cyan),
                ),
              );

              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    heading,
                    const SizedBox(height: 12),
                    Align(alignment: Alignment.centerRight, child: addButton),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: heading),
                  const SizedBox(width: 12),
                  addButton,
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 10.0;
              final columns = constraints.maxWidth >= 600 ? 4 : 2;
              final width =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  _metric(
                    value: '${credentials.length}',
                    label: 'Credentials',
                    icon: Icons.fact_check_outlined,
                    color: _navy,
                    width: width,
                  ),
                  _metric(
                    value: '$verifiedCount',
                    label: 'Verified',
                    icon: Icons.verified_outlined,
                    color: const Color(0xFF047857),
                    width: width,
                  ),
                  _metric(
                    value: '$expiringCount',
                    label: 'Expiring Soon',
                    icon: Icons.schedule_outlined,
                    color: const Color(0xFFB45309),
                    width: width,
                  ),
                  _metric(
                    value: '$pendingCount',
                    label: 'Pending Verification',
                    icon: Icons.hourglass_empty_outlined,
                    color: const Color(0xFF64748B),
                    width: width,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          if (credentials.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _border),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 32,
                    color: Color(0xFF94A3B8),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No credentials added',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _navy,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Credentials are optional. Add qualifications or '
                    'compliance items relevant to this volunteer.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, height: 1.5, color: _muted),
                  ),
                ],
              ),
            )
          else
            ...credentials.asMap().entries.map(
              (entry) => _credentialTile(context, entry.key, entry.value),
            ),
          if (credentials.any(
            (credential) =>
                credential.category == CredentialCategory.backgroundCheck,
          )) ...[
            const SizedBox(height: 14),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lock_outline, size: 17, color: Color(0xFF64748B)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Record background-check status and relevant dates '
                    'only. Do not enter report details here.',
                    style: TextStyle(fontSize: 12, height: 1.5, color: _muted),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
