import 'package:flutter/material.dart';

import 'package:charitask/modules/people/domain/services/credential_compliance_evaluator.dart';

class CredentialComplianceDetailsDialog extends StatelessWidget {
  const CredentialComplianceDetailsDialog({
    super.key,
    required this.personName,
    required this.compliance,
  });

  final String personName;
  final CredentialComplianceResult compliance;

  static const _navy = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);
  static const _purple = Color(0xFF5B4BC4);
  static const _red = Color(0xFFB91C1C);
  static const _orange = Color(0xFFB45309);
  static const _green = Color(0xFF047857);

  Color _statusColor(CredentialRequirementItemStatus status) {
    switch (status) {
      case CredentialRequirementItemStatus.satisfied:
        return _green;
      case CredentialRequirementItemStatus.missing:
      case CredentialRequirementItemStatus.reviewRequired:
        return _orange;
      case CredentialRequirementItemStatus.expired:
        return _red;
      case CredentialRequirementItemStatus.accessRestricted:
        return _muted;
    }
  }

  IconData _statusIcon(CredentialRequirementItemStatus status) {
    switch (status) {
      case CredentialRequirementItemStatus.satisfied:
        return Icons.check_circle_outline;
      case CredentialRequirementItemStatus.missing:
        return Icons.error_outline;
      case CredentialRequirementItemStatus.expired:
        return Icons.event_busy_outlined;
      case CredentialRequirementItemStatus.reviewRequired:
        return Icons.pending_outlined;
      case CredentialRequirementItemStatus.accessRestricted:
        return Icons.lock_outline;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String get _subtitle {
    if (compliance.accessRestricted) {
      return 'Your current permissions do not allow all requirements '
          'to be checked.';
    }

    if (!compliance.hasRequirements) {
      return 'No credential requirements are configured for this person’s '
          'active functional roles.';
    }

    return '${compliance.satisfiedRequirements} of '
        '${compliance.totalRequirements} requirements satisfied';
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.fact_check_outlined, color: _purple, size: 25),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Credential Requirements',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: screenSize.width < 700 ? screenSize.width * 0.82 : 540,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: screenSize.height * 0.62),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                personName,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _subtitle,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: _border),
              const SizedBox(height: 12),
              Flexible(
                child: SingleChildScrollView(
                  child: _buildRequirements(context),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildRequirements(BuildContext context) {
    if (compliance.accessRestricted) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 22),
        child: Column(
          children: [
            Icon(Icons.lock_outline, color: _muted, size: 34),
            SizedBox(height: 10),
            Text(
              'Credential details are restricted',
              style: TextStyle(color: _navy, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'You need the appropriate credential and background-check '
              'permissions to view all requirement details.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 13, height: 1.5),
            ),
          ],
        ),
      );
    }

    if (!compliance.hasRequirements) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 22),
        child: Column(
          children: [
            Icon(Icons.info_outline, color: _muted, size: 34),
            SizedBox(height: 10),
            Text(
              'No requirements configured',
              style: TextStyle(color: _navy, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'Add credential requirements to the person’s functional roles '
              'to assess compliance.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 13, height: 1.5),
            ),
          ],
        ),
      );
    }

    return Column(
      children: compliance.requirementAssessments
          .map((assessment) => _buildRequirementCard(context, assessment))
          .toList(),
    );
  }

  Widget _buildRequirementCard(
    BuildContext context,
    CredentialRequirementAssessment assessment,
  ) {
    final color = _statusColor(assessment.status);
    final credential = assessment.matchingCredential;
    final canManage =
        assessment.status != CredentialRequirementItemStatus.satisfied &&
        assessment.status != CredentialRequirementItemStatus.accessRestricted;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_statusIcon(assessment.status), color: color, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assessment.displayName,
                      style: const TextStyle(
                        color: _navy,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${assessment.requirement.category.label} · '
                      '${assessment.roleName}',
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    assessment.statusLabel,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (assessment.requirement.description?.trim().isNotEmpty ==
              true) ...[
            const SizedBox(height: 8),
            Text(
              assessment.requirement.description!.trim(),
              style: const TextStyle(color: _muted, fontSize: 12, height: 1.45),
            ),
          ],
          if (credential != null) ...[
            const SizedBox(height: 8),
            Text(
              [
                credential.status.label,
                if (credential.expirationDate != null)
                  '${credential.isExpired ? 'Expired' : 'Expires'} '
                      '${_formatDate(credential.expirationDate!)}',
              ].join(' · '),
              style: TextStyle(color: color, fontSize: 12, height: 1.4),
            ),
          ],
          if (canManage) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(assessment),
                style: FilledButton.styleFrom(
                  backgroundColor: _purple,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.edit_outlined, size: 17),
                label: const Text('Manage Credential'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
