import 'package:flutter/material.dart';

import 'package:charitask/modules/people/domain/models/person_credential.dart';
import 'package:charitask/modules/people/domain/services/credential_compliance_evaluator.dart';

class PersonCredentialsCell extends StatelessWidget {
  final List<PersonCredential> credentials;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback? onViewCompliance;
  final CredentialComplianceResult? compliance;

  const PersonCredentialsCell({
    super.key,
    required this.credentials,
    required this.isExpanded,
    required this.onToggle,
    this.compliance,
    this.onViewCompliance,
  });

  @override
  Widget build(BuildContext context) {
    final expiredCount = credentials.where((item) => item.isExpired).length;
    final expiringCount = credentials
        .where((item) => item.isExpiringSoon())
        .length;

    final badge = _getBadge(
      expiredCount: expiredCount,
      expiringCount: expiringCount,
    );

    return SizedBox(
      width: 150,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    credentials.isEmpty
                        ? 'No credentials'
                        : '${credentials.length} credential'
                              '${credentials.length == 1 ? '' : 's'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 5),
                  _statusBadge(
                    label: badge.label,
                    color: badge.color,
                    tooltip: badge.tooltip,
                    onTap: onViewCompliance,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onToggle,
              tooltip: isExpanded
                  ? 'Collapse credentials'
                  : 'Expand credentials',
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 28, height: 32),
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 18,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _CredentialBadgeData _getBadge({
    required int expiredCount,
    required int expiringCount,
  }) {
    // Any expired credential is a visible compliance concern.
    if (expiredCount > 0 ||
        compliance?.status == CredentialComplianceStatus.expired) {
      return _CredentialBadgeData(
        label: 'Expired',
        color: const Color(0xFFDC2626),
        tooltip: compliance != null && compliance!.expiredRequirements > 0
            ? '${compliance!.expiredRequirements} required credential '
                  'requirement(s) have expired.'
            : '$expiredCount credential(s) have expired.',
      );
    }

    if (compliance?.status == CredentialComplianceStatus.missingRequired) {
      return _CredentialBadgeData(
        label: 'Missing Required',
        color: const Color(0xFFD97706),
        tooltip:
            '${compliance!.missingRequirements} required credential '
            'requirement(s) are not satisfied.',
      );
    }

    if (compliance?.status == CredentialComplianceStatus.accessRestricted) {
      return const _CredentialBadgeData(
        label: 'Restricted',
        color: Color(0xFF6B7280),
        tooltip:
            'Credential compliance cannot be assessed with your '
            'current permissions.',
      );
    }

    if (compliance?.status == CredentialComplianceStatus.reviewRequired) {
      return _CredentialBadgeData(
        label: 'Review Required',
        color: const Color(0xFFD97706),
        tooltip:
            '${compliance!.reviewRequirements} credential '
            'requirement(s) need review.',
      );
    }

    if (expiringCount > 0) {
      return _CredentialBadgeData(
        label: 'Expiring Soon',
        color: const Color(0xFFD97706),
        tooltip: '$expiringCount credential(s) expire within 30 days.',
      );
    }

    if (compliance?.status == CredentialComplianceStatus.valid) {
      return const _CredentialBadgeData(
        label: 'Valid',
        color: Color(0xFF15803D),
        tooltip:
            'All configured credential requirements are satisfied '
            'by current credentials in acceptable statuses.',
      );
    }

    if (compliance?.status == CredentialComplianceStatus.noRequirements) {
      return const _CredentialBadgeData(
        label: 'No requirements',
        color: Color(0xFF6B7280),
        tooltip:
            'No credential requirements are configured for this '
            "person's active Functional Roles.",
      );
    }

    return const _CredentialBadgeData(
      label: 'Status unavailable',
      color: Color(0xFF6B7280),
      tooltip: 'Credential compliance could not be determined.',
    );
  }

  Widget _statusBadge({
    required String label,
    required Color color,
    required String tooltip,
    VoidCallback? onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 120),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CredentialBadgeData {
  final String label;
  final Color color;
  final String tooltip;

  const _CredentialBadgeData({
    required this.label,
    required this.color,
    required this.tooltip,
  });
}

/// Expanded credential details displayed beneath a person's table row.
class PersonCredentialsExpansion extends StatelessWidget {
  final List<PersonCredential> credentials;

  const PersonCredentialsExpansion({super.key, required this.credentials});

  @override
  Widget build(BuildContext context) {
    if (credentials.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'No credential records available to display.',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      color: const Color(0xFFF8FAFC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CREDENTIAL DETAILS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 10),
          ...credentials.map(_buildCredentialRow),
        ],
      ),
    );
  }

  Widget _buildCredentialRow(PersonCredential credential) {
    final expired = credential.isExpired;
    final expiring = credential.isExpiringSoon();

    final statusLabel = expired
        ? 'Expired'
        : expiring
        ? 'Expiring Soon'
        : credential.status.label;

    final statusColor = expired
        ? const Color(0xFFDC2626)
        : expiring
        ? const Color(0xFFD97706)
        : switch (credential.status) {
            CredentialStatus.verified ||
            CredentialStatus.cleared => const Color(0xFF15803D),
            CredentialStatus.pending => const Color(0xFF2563EB),
            CredentialStatus.rejected ||
            CredentialStatus.notCleared => const Color(0xFFDC2626),
            CredentialStatus.reviewRequired => const Color(0xFFD97706),
          };

    final details = <String>[
      credential.category.label,
      if (credential.issuingOrganization?.trim().isNotEmpty == true)
        credential.issuingOrganization!.trim(),
      if (credential.expirationDate != null)
        '${expired ? 'Expired' : 'Expires'} '
            '${_formatDate(credential.expirationDate!)}',
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.workspace_premium_outlined,
            size: 20,
            color: Color(0xFF0891B2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  credential.credentialName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  details.join(' • '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
