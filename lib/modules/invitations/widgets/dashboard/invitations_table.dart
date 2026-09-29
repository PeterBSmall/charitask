import 'package:flutter/material.dart';

import '../../domain/models/invitation_list_item.dart';

class InvitationsTable extends StatelessWidget {
  const InvitationsTable({
    super.key,
    required this.invitations,
    required this.onInvitationSelected,
  });

  final List<InvitationListItem> invitations;
  final ValueChanged<InvitationListItem> onInvitationSelected;

  static const _purple = Color(0xFF7C3AED);
  static const _text = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    if (invitations.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStatePropertyAll(const Color(0xFFF8FAFC)),
            columnSpacing: 28,
            horizontalMargin: 18,
            dataRowMinHeight: 68,
            dataRowMaxHeight: 76,
            headingTextStyle: const TextStyle(
              color: _muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
            columns: const [
              DataColumn(label: Text('PERSON')),
              DataColumn(label: Text('TYPE')),
              DataColumn(label: Text('INVITED TO')),
              DataColumn(label: Text('ASSIGNMENT')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('SENT')),
              DataColumn(label: Text('EXPIRES')),
            ],
            rows: [
              for (final invitation in invitations)
                DataRow(
                  onSelectChanged: (_) {
                    onInvitationSelected(invitation);
                  },
                  cells: [
                    DataCell(_PersonCell(invitation: invitation)),
                    DataCell(
                      _TypeCell(
                        invitationType: invitation.invitationType,
                        recipientType: invitation.recipientType,
                      ),
                    ),
                    DataCell(_TextCell(invitation.invitedTo)),
                    DataCell(_TextCell(invitation.assignment)),
                    DataCell(_StatusBadge(status: invitation.status)),
                    DataCell(_DateCell(invitation.sentAt)),
                    DataCell(_DateCell(invitation.expiresAt)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: const Column(
        children: [
          Icon(Icons.mark_email_unread_outlined, size: 44, color: _purple),
          SizedBox(height: 12),
          Text(
            'No invitations found',
            style: TextStyle(
              color: _text,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Invitations will appear here once they are created.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _PersonCell extends StatelessWidget {
  const _PersonCell({required this.invitation});

  final InvitationListItem invitation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: Row(
        children: [
          CircleAvatar(
            radius: 19,
            backgroundColor: const Color(0xFF7C3AED).withValues(alpha: 0.10),
            child: Text(
              _initials(invitation.name),
              style: const TextStyle(
                color: Color(0xFF7C3AED),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invitation.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  invitation.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
}

class _TypeCell extends StatelessWidget {
  const _TypeCell({required this.invitationType, required this.recipientType});

  final String invitationType;
  final String recipientType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 125,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            invitationType,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            recipientType,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _TextCell extends StatelessWidget {
  const _TextCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Color(0xFF1E293B), fontSize: 12),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: style.foreground,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _StatusStyle _styleFor(String value) {
    switch (value.toLowerCase()) {
      case 'accepted':
        return const _StatusStyle(
          background: Color(0xFFDCFCE7),
          foreground: Color(0xFF15803D),
        );
      case 'expired':
        return const _StatusStyle(
          background: Color(0xFFF1F5F9),
          foreground: Color(0xFF64748B),
        );
      case 'revoked':
        return const _StatusStyle(
          background: Color(0xFFFEE2E2),
          foreground: Color(0xFFB91C1C),
        );
      case 'pending':
      default:
        return const _StatusStyle(
          background: Color(0xFFFEF3C7),
          foreground: Color(0xFFB45309),
        );
    }
  }
}

class _StatusStyle {
  const _StatusStyle({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}

class _DateCell extends StatelessWidget {
  const _DateCell(this.date);

  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    if (date == null) {
      return const Text(
        '—',
        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
      );
    }

    return Text(
      '${date!.month}/${date!.day}/${date!.year}',
      style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
    );
  }
}
