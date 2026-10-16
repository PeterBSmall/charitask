import 'package:flutter/material.dart';

import 'package:charitask/modules/people/domain/models/person_credential.dart';
import 'package:charitask/modules/people/domain/services/credential_compliance_evaluator.dart';
import 'package:charitask/modules/people/widgets/person_credentials_cell.dart';

class PeopleTable extends StatefulWidget {
  final List<Map<String, dynamic>> people;
  final Map<String, List<PersonCredential>> credentialsByPerson;
  final bool canViewAnyCredentials;
  final Set<String> under18PersonIds;
  final ValueChanged<String>? onEditPerson;
  final Future<void> Function(
    String personId,
    String personName,
    CredentialComplianceResult compliance,
  )?
  onViewCredentialCompliance;

  const PeopleTable({
    super.key,
    required this.people,
    required this.credentialsByPerson,
    required this.canViewAnyCredentials,
    required this.under18PersonIds,
    this.onEditPerson,
    this.onViewCredentialCompliance,
  });

  @override
  State<PeopleTable> createState() => _PeopleTableState();
}

class _PeopleTableState extends State<PeopleTable> {
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  final Map<String, bool> _expandedCredentialRows = {};

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  String _initials(Map<String, dynamic> person) {
    final firstName = (person['first_name'] as String?)?.trim() ?? '';
    final lastName = (person['last_name'] as String?)?.trim() ?? '';

    final firstInitial = firstName.isNotEmpty
        ? firstName.substring(0, 1).toUpperCase()
        : '';
    final lastInitial = lastName.isNotEmpty
        ? lastName.substring(0, 1).toUpperCase()
        : '';

    final initials = '$firstInitial$lastInitial';
    return initials.isEmpty ? '?' : initials;
  }

  String _fullName(Map<String, dynamic> person) {
    final firstName = (person['first_name'] as String?)?.trim() ?? '';
    final lastName = (person['last_name'] as String?)?.trim() ?? '';

    return '$firstName $lastName'.trim();
  }

  String _displayValue(dynamic value) {
    if (value == null) return '—';

    final text = value.toString().trim();
    return text.isEmpty ? '—' : text;
  }

  @override
  Widget build(BuildContext context) {
    final showActionsColumn = widget.onEditPerson != null;

    final tableWidth = !showActionsColumn
        ? 1200.0
        : widget.canViewAnyCredentials
        ? 1260.0
        : 1120.0;

    return SizedBox(
      height: 420,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Scrollbar(
          controller: _horizontalController,
          thumbVisibility: true,
          trackVisibility: true,
          scrollbarOrientation: ScrollbarOrientation.bottom,
          child: SingleChildScrollView(
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: Scrollbar(
                controller: _verticalController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _verticalController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _PeopleTableHeader(
                        showCredentialsColumn: widget.canViewAnyCredentials,
                        showActionsColumn: showActionsColumn,
                      ),
                      const Divider(height: 1),
                      if (widget.people.isEmpty)
                        const SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 80),
                            child: Center(
                              child: Text(
                                'No people found.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF7B8494),
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        ...List.generate(widget.people.length, (index) {
                          final person = widget.people[index];
                          final status = _displayValue(person['status']);
                          final personId = person['id']?.toString() ?? '';

                          final credentials =
                              widget.credentialsByPerson[personId] ??
                              const <PersonCredential>[];

                          final credentialsExpanded =
                              _expandedCredentialRows[personId] ?? false;

                          final compliance =
                              person['credential_compliance']
                                  is CredentialComplianceResult
                              ? person['credential_compliance']
                                    as CredentialComplianceResult
                              : null;

                          return Column(
                            children: [
                              _PeopleRow(
                                initials: _initials(person),
                                name: _fullName(person),
                                email: _displayValue(person['email']),
                                role: _displayValue(person['role']),
                                groups: _displayValue(person['groups']),
                                locations: _displayValue(person['locations']),
                                status: status,
                                phone: _displayValue(person['phone']),
                                lastActive: '—',
                                isUnder18: widget.under18PersonIds.contains(
                                  personId,
                                ),
                                showCredentialsColumn:
                                    widget.canViewAnyCredentials,
                                credentials: credentials,
                                credentialsExpanded: credentialsExpanded,
                                compliance: compliance,
                                onToggleCredentials: () {
                                  if (personId.isEmpty) return;

                                  setState(() {
                                    _expandedCredentialRows[personId] =
                                        !credentialsExpanded;
                                  });
                                },
                                onViewCompliance:
                                    personId.isEmpty ||
                                        compliance == null ||
                                        widget.onViewCredentialCompliance ==
                                            null
                                    ? null
                                    : () async {
                                        await widget
                                            .onViewCredentialCompliance!(
                                          personId,
                                          _fullName(person),
                                          compliance,
                                        );
                                      },
                                onEdit:
                                    personId.isEmpty ||
                                        widget.onEditPerson == null
                                    ? null
                                    : () => widget.onEditPerson!(personId),
                              ),
                              if (widget.canViewAnyCredentials &&
                                  credentialsExpanded)
                                PersonCredentialsExpansion(
                                  credentials: credentials,
                                ),
                              if (index < widget.people.length - 1)
                                const Divider(height: 1),
                            ],
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PeopleTableHeader extends StatelessWidget {
  final bool showCredentialsColumn;
  final bool showActionsColumn;

  const _PeopleTableHeader({
    required this.showCredentialsColumn,
    required this.showActionsColumn,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            const SizedBox(width: 250, child: _HeaderText('NAME')),
            const SizedBox(width: 120, child: _HeaderText('ROLE')),
            const SizedBox(width: 120, child: _HeaderText('GROUP(S)')),
            const SizedBox(width: 120, child: _HeaderText('LOCATION(S)')),
            const SizedBox(width: 100, child: _HeaderText('STATUS')),
            const SizedBox(width: 150, child: _HeaderText('PHONE')),
            const SizedBox(width: 110, child: _HeaderText('LAST ACTIVE')),
            if (showCredentialsColumn)
              const SizedBox(width: 150, child: _HeaderText('CREDENTIALS')),
            if (showActionsColumn)
              const SizedBox(width: 70, child: _HeaderText('ACTIONS')),
          ],
        ),
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;

  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: Color(0xFF9CA3AF),
      ),
    );
  }
}

class _PeopleRow extends StatelessWidget {
  final String initials;
  final String name;
  final String email;
  final String role;
  final String groups;
  final String locations;
  final String status;
  final String phone;
  final String lastActive;
  final bool isUnder18;

  final bool showCredentialsColumn;
  final List<PersonCredential> credentials;
  final bool credentialsExpanded;
  final VoidCallback onToggleCredentials;
  final VoidCallback? onViewCompliance;
  final VoidCallback? onEdit;
  final CredentialComplianceResult? compliance;

  const _PeopleRow({
    required this.initials,
    required this.name,
    required this.email,
    required this.role,
    required this.groups,
    required this.locations,
    required this.status,
    required this.phone,
    required this.lastActive,
    required this.showCredentialsColumn,
    required this.credentials,
    required this.credentialsExpanded,
    required this.onToggleCredentials,
    required this.isUnder18,
    required this.onEdit,
    this.onViewCompliance,
    this.compliance,
  });

  Color get _statusColor {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF5F8D63);
      case 'inactive':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            SizedBox(
              width: 250,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFEDE9FE),
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Color(0xFF5B4BC4),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.isEmpty ? 'Unnamed person' : name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2F3A4A),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7B8494),
                          ),
                        ),
                        if (isUnder18) ...[
                          const SizedBox(height: 3),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Tooltip(
                              message: 'Minor. Guardian information required.',
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      size: 12,
                                      color: Color(0xFF92400E),
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      'Under 18',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF92400E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 120, child: _CellText(role)),
            SizedBox(width: 120, child: _CellText(groups)),
            SizedBox(width: 120, child: _CellText(locations)),
            SizedBox(
              width: 100,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _StatusBadge(label: status, color: _statusColor),
              ),
            ),
            SizedBox(width: 150, child: _CellText(phone)),
            SizedBox(width: 110, child: _CellText(lastActive)),
            if (showCredentialsColumn)
              PersonCredentialsCell(
                credentials: credentials,
                isExpanded: credentialsExpanded,
                onToggle: onToggleCredentials,
                compliance: compliance,
                onViewCompliance: onViewCompliance,
              ),
            if (onEdit != null)
              SizedBox(
                width: 70,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    tooltip: 'Edit person',
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    color: const Color(0xFF5B4BC4),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CellText extends StatelessWidget {
  final String text;

  const _CellText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563)),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
