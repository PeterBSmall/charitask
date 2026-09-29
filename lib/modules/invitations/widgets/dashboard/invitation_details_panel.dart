import 'package:flutter/material.dart';

import '../../domain/models/invitation_list_item.dart';

class InvitationDetailsPanel extends StatelessWidget {
  const InvitationDetailsPanel({
    super.key,
    required this.invitation,
    required this.onClose,
    this.onResend,
  });

  final InvitationListItem invitation;
  final VoidCallback onClose;
  final VoidCallback? onResend;

  static const _purple = Color(0xFF7C3AED);
  static const _text = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPerson(),
                  const SizedBox(height: 20),
                  _buildStatus(),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Invitation Details',
                    children: [
                      _DetailRow(
                        label: 'Invitation Type',
                        value: invitation.invitationType,
                      ),
                      _DetailRow(
                        label: 'Recipient',
                        value: invitation.recipientType,
                      ),
                      _DetailRow(
                        label: 'Invited To',
                        value: invitation.invitedTo,
                      ),
                      _DetailRow(
                        label: 'Access Type',
                        value: invitation.accessType,
                      ),
                      _DetailRow(
                        label: 'Assignment',
                        value: invitation.assignment,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Invitation Timeline',
                    children: [
                      _DetailRow(
                        label: 'Sent',
                        value: _formatDate(invitation.sentAt),
                      ),
                      _DetailRow(
                        label: 'Expires',
                        value: _formatDate(invitation.expiresAt),
                      ),
                      if (invitation.status.toLowerCase() == 'accepted')
                        const _DetailRow(label: 'Accepted', value: 'Accepted'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Invitation Details',
              style: TextStyle(
                color: _text,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: onClose,
            tooltip: 'Close',
            icon: const Icon(Icons.close_rounded, color: _muted, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildPerson() {
    return Row(
      children: [
        CircleAvatar(
          radius: 27,
          backgroundColor: _purple.withValues(alpha: 0.10),
          child: Text(
            _initials(invitation.name),
            style: const TextStyle(
              color: _purple,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                invitation.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _text,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                invitation.email,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatus() {
    final style = _statusStyle(invitation.status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(style.icon, color: style.foreground, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              invitation.status,
              style: TextStyle(
                color: style.foreground,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _text,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: _border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  const Divider(height: 1, indent: 14, endIndent: 14),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (onResend != null)
            FilledButton.icon(
              onPressed: onResend,
              icon: const Icon(Icons.send_outlined, size: 17),
              label: const Text('Resend Invitation'),
              style: FilledButton.styleFrom(
                backgroundColor: _purple,
                foregroundColor: Colors.white,
              ),
            ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_rounded, size: 18),
            label: const Text('More'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _text,
              side: const BorderSide(color: _border),
            ),
          ),
        ],
      ),
    );
  }

  _StatusStyle _statusStyle(String value) {
    switch (value.toLowerCase()) {
      case 'accepted':
        return const _StatusStyle(
          background: Color(0xFFDCFCE7),
          foreground: Color(0xFF15803D),
          icon: Icons.check_circle_outline_rounded,
        );
      case 'expired':
        return const _StatusStyle(
          background: Color(0xFFF1F5F9),
          foreground: Color(0xFF64748B),
          icon: Icons.schedule_rounded,
        );
      case 'revoked':
        return const _StatusStyle(
          background: Color(0xFFFEE2E2),
          foreground: Color(0xFFB91C1C),
          icon: Icons.block_outlined,
        );
      case 'pending':
      default:
        return const _StatusStyle(
          background: Color(0xFFFEF3C7),
          foreground: Color(0xFFB45309),
          icon: Icons.schedule_outlined,
        );
    }
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusStyle {
  const _StatusStyle({
    required this.background,
    required this.foreground,
    required this.icon,
  });

  final Color background;
  final Color foreground;
  final IconData icon;
}
