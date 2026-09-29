import 'package:flutter/material.dart';

import '../domain/models/invitation_list_item.dart';
import '../widgets/dashboard/invitation_details_panel.dart';
import '../widgets/dashboard/invitation_filters.dart';
import '../widgets/dashboard/invitation_kpi_row.dart';
import '../widgets/dashboard/invitations_hero.dart';
import '../widgets/dashboard/invitations_table.dart';

class InvitationsPage extends StatefulWidget {
  const InvitationsPage({
    super.key,
    required this.organizationId,
    required this.onCreateInvitation,
  });

  final String organizationId;
  final VoidCallback onCreateInvitation;

  @override
  State<InvitationsPage> createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  final TextEditingController _searchController = TextEditingController();

  String? _selectedStatus;
  String? _selectedInvitationType;
  String? _selectedInvitedTo;
  String? _selectedAccessType;

  InvitationListItem? _selectedInvitation;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedStatus = null;
      _selectedInvitationType = null;
      _selectedInvitedTo = null;
      _selectedAccessType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 700 ? 16.0 : 24.0;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                24,
                horizontalPadding,
                32,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InvitationsHero(
                        onCreateInvitation: widget.onCreateInvitation,
                      ),
                      const SizedBox(height: 18),
                      const InvitationKpiRow(
                        pending: 0,
                        accepted: 0,
                        expired: 0,
                        totalSent: 0,
                      ),
                      const SizedBox(height: 20),
                      _buildInvitationListSection(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInvitationListSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(),
          const SizedBox(height: 14),
          InvitationFilters(
            searchController: _searchController,
            selectedStatus: _selectedStatus,
            selectedInvitationType: _selectedInvitationType,
            selectedInvitedTo: _selectedInvitedTo,
            selectedAccessType: _selectedAccessType,
            onStatusChanged: (value) {
              setState(() => _selectedStatus = value);
            },
            onInvitationTypeChanged: (value) {
              setState(() => _selectedInvitationType = value);
            },
            onInvitedToChanged: (value) {
              setState(() => _selectedInvitedTo = value);
            },
            onAccessTypeChanged: (value) {
              setState(() => _selectedAccessType = value);
            },
            onClear: _clearFilters,
          ),
          const SizedBox(height: 16),
          _buildTableArea(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 700;

        final title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Invitations',
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Manage invitations and track access requests.',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
          ],
        );

        final action = FilledButton.icon(
          onPressed: widget.onCreateInvitation,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Create Invitation'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF7C3AED),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              title,
              const SizedBox(height: 12),
              Align(alignment: Alignment.centerLeft, child: action),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: title),
            const SizedBox(width: 16),
            action,
          ],
        );
      },
    );
  }

  Widget _buildTableArea() {
    const invitations = <InvitationListItem>[];

    if (_selectedInvitation == null) {
      return InvitationsTable(
        invitations: invitations,
        onInvitationSelected: (invitation) {
          setState(() => _selectedInvitation = invitation);
        },
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 1000;

        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InvitationsTable(
                invitations: invitations,
                onInvitationSelected: (invitation) {
                  setState(() => _selectedInvitation = invitation);
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 560,
                child: InvitationDetailsPanel(
                  invitation: _selectedInvitation!,
                  onClose: () {
                    setState(() => _selectedInvitation = null);
                  },
                ),
              ),
            ],
          );
        }

        return SizedBox(
          height: 560,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: InvitationsTable(
                  invitations: invitations,
                  onInvitationSelected: (invitation) {
                    setState(() => _selectedInvitation = invitation);
                  },
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 360,
                child: InvitationDetailsPanel(
                  invitation: _selectedInvitation!,
                  onClose: () {
                    setState(() => _selectedInvitation = null);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
