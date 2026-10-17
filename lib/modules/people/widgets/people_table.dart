import 'package:flutter/material.dart';

import 'package:charitask/modules/people/domain/models/person_credential.dart';
import 'package:charitask/modules/people/domain/services/credential_compliance_evaluator.dart';
import 'package:charitask/modules/people/widgets/person_credentials_cell.dart';

const Map<String, double> _peopleColumnWidths = {
  'name': 250,
  'type': 120,
  'roles': 165,
  'groups': 160,
  'status': 100,
  'phone': 130,
  'location': 140,
  'lastActive': 115,
  'credentials': 160,
  'actions': 95,
};

const Map<String, String> _peopleColumnTitles = {
  'name': 'NAME',
  'type': 'TYPE',
  'roles': 'ROLES',
  'groups': 'GROUPS',
  'status': 'STATUS',
  'phone': 'PHONE',
  'location': 'LOCATION',
  'lastActive': 'LAST ACTIVE',
  'credentials': 'CREDENTIALS',
  'actions': 'ACTIONS',
};

class PeopleTable extends StatefulWidget {
  final List<Map<String, dynamic>> people;
  final Map<String, List<PersonCredential>> credentialsByPerson;
  final bool canViewAnyCredentials;
  final Set<String> under18PersonIds;
  final Set<String> visibleColumns;
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
    this.visibleColumns = const {
      'type',
      'roles',
      'groups',
      'status',
      'credentials',
    },
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

  List<String> get _columnKeys {
    final showCredentials =
        widget.canViewAnyCredentials &&
        widget.visibleColumns.contains('credentials');
    return [
      'name',
      if (widget.visibleColumns.contains('type')) 'type',
      if (widget.visibleColumns.contains('roles')) 'roles',
      if (widget.visibleColumns.contains('groups')) 'groups',
      if (widget.visibleColumns.contains('status')) 'status',
      if (widget.visibleColumns.contains('phone')) 'phone',
      if (widget.visibleColumns.contains('location')) 'location',
      if (widget.visibleColumns.contains('lastActive')) 'lastActive',
      if (showCredentials) 'credentials',
      'actions',
    ];
  }

  double get _tableWidth => _columnKeys.fold<double>(
    32,
    (total, key) => total + _peopleColumnWidths[key]!,
  );

  @override
  Widget build(BuildContext context) {
    final showCredentialsColumn =
        widget.canViewAnyCredentials &&
        widget.visibleColumns.contains('credentials');
    final rows = widget.people;

    return SizedBox(
      height: 420,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
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
              width: _tableWidth,
              child: Scrollbar(
                controller: _verticalController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _verticalController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _PeopleTableHeader(columnKeys: _columnKeys),
                      const Divider(height: 1, color: Color(0xFFE8ECF3)),
                      if (rows.isEmpty)
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
                        ...List.generate(rows.length, (index) {
                          final person = rows[index];
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
                                person: person,
                                columnKeys: _columnKeys,
                                initials: _initials(person),
                                fullName: _fullName(person),
                                status: _displayValue(person['status']),
                                isUnder18: widget.under18PersonIds.contains(
                                  personId,
                                ),
                                credentials: credentials,
                                credentialsExpanded: credentialsExpanded,
                                onToggleCredentials: () {
                                  if (personId.isEmpty) return;
                                  setState(() {
                                    _expandedCredentialRows[personId] =
                                        !credentialsExpanded;
                                  });
                                },
                                compliance: compliance,
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
                                showCredentialsColumn: showCredentialsColumn,
                              ),
                              if (showCredentialsColumn && credentialsExpanded)
                                SizedBox(
                                  width: _tableWidth - 32,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: PersonCredentialsExpansion(
                                      credentials: credentials,
                                    ),
                                  ),
                                ),
                              if (index < rows.length - 1)
                                const Divider(
                                  height: 1,
                                  color: Color(0xFFE8ECF3),
                                ),
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
  const _PeopleTableHeader({required this.columnKeys});

  final List<String> columnKeys;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: columnKeys
              .map(
                (key) => SizedBox(
                  width: _peopleColumnWidths[key],
                  child: _HeaderText(
                    _peopleColumnTitles[key] ?? key.toUpperCase(),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.7,
        color: Color(0xFF64748B),
      ),
    );
  }
}

class _PeopleRow extends StatelessWidget {
  const _PeopleRow({
    required this.person,
    required this.columnKeys,
    required this.initials,
    required this.fullName,
    required this.status,
    required this.isUnder18,
    required this.credentials,
    required this.credentialsExpanded,
    required this.onToggleCredentials,
    required this.onEdit,
    required this.showCredentialsColumn,
    this.onViewCompliance,
    this.compliance,
  });

  final Map<String, dynamic> person;
  final List<String> columnKeys;
  final String initials;
  final String fullName;
  final String status;
  final bool isUnder18;
  final List<PersonCredential> credentials;
  final bool credentialsExpanded;
  final VoidCallback onToggleCredentials;
  final VoidCallback? onViewCompliance;
  final VoidCallback? onEdit;
  final bool showCredentialsColumn;
  final CredentialComplianceResult? compliance;

  Color get _statusColor {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF25855A);
      case 'invited':
      case 'pending':
        return const Color(0xFFB7791F);
      case 'inactive':
      case 'ended':
        return const Color(0xFF64748B);
      default:
        return const Color(0xFF64748B);
    }
  }

  String _personTypeLabel() {
    final raw =
        (person['person_type'] ?? person['type'])?.toString().trim() ?? '';
    if (raw.isEmpty) return '—';
    return raw
        .replaceAll('_', ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map(
          (word) =>
              '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  Color _personTypeColor(String type) {
    final value = type.toLowerCase();
    if (value.contains('volunteer')) return const Color(0xFF25855A);
    if (value.contains('staff') || value.contains('employee')) {
      return const Color(0xFF3567B7);
    }
    if (value.contains('participant') || value.contains('homeowner')) {
      return const Color(0xFF9D4EDD);
    }
    if (value.contains('donor') ||
        value.contains('vendor') ||
        value.contains('contractor')) {
      return const Color(0xFFB7791F);
    }
    if (value.contains('board') ||
        value.contains('executive') ||
        value.contains('founder')) {
      return const Color(0xFF5B4BC4);
    }
    return const Color(0xFF64748B);
  }

  List<String> _tags(dynamic value) {
    if (value == null) return const [];
    final text = value.toString().trim();
    if (text.isEmpty || text == '—' || text == '-') return const [];
    return text
        .split(',')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty && part != '—' && part != '-')
        .toList();
  }

  Widget _tagCell(
    BuildContext context,
    dynamic value, {
    required String title,
    Color color = const Color(0xFF5B4BC4),
  }) {
    final tags = _tags(value);
    if (tags.isEmpty) {
      return const Text(
        '—',
        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 124),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            tags.first,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (tags.length > 1) ...[
          const SizedBox(height: 2),
          InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () =>
                _showAllTags(context, title: title, tags: tags, color: color),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              child: Text(
                '+${tags.length - 1} more',
                maxLines: 1,
                style: const TextStyle(
                  color: Color(0xFF5B4BC4),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showAllTags(
    BuildContext context, {
    required String title,
    required List<String> tags,
    required Color color,
  }) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420, maxHeight: 420),
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags
                  .map(
                    (tag) => Container(
                      constraints: const BoxConstraints(maxWidth: 360),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _nameCell() {
    final preferred = person['preferred_name']?.toString().trim() ?? '';
    final first = person['first_name']?.toString().trim() ?? '';
    final last = person['last_name']?.toString().trim() ?? '';
    final displayFirst = preferred.isNotEmpty ? preferred : first;
    final displayName = '$displayFirst $last'.trim().isEmpty
        ? (fullName.isEmpty ? 'Unnamed person' : fullName)
        : '$displayFirst $last'.trim();
    final email = person['email']?.toString().trim() ?? '';

    return SizedBox(
      width: _peopleColumnWidths['name'],
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFEDE9FE),
            child: Text(
              initials,
              style: const TextStyle(
                color: Color(0xFF5B4BC4),
                fontSize: 12,
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
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
                if (isUnder18) ...[
                  const SizedBox(height: 3),
                  const Text(
                    'Under 18',
                    style: TextStyle(
                      color: Color(0xFF92400E),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeCell() {
    final label = _personTypeLabel();
    if (label == '—') {
      return const Text(
        '—',
        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      );
    }
    final color = _personTypeColor(label);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _statusCell() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: _statusColor.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: _statusColor,
      ),
    ),
  );

  Widget _actionsCell() {
    final canShowMenu = onEdit != null || onViewCompliance != null;
    if (!canShowMenu) {
      return const Text(
        '—',
        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          IconButton(
            tooltip: 'Edit person',
            visualDensity: VisualDensity.compact,
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 19),
            color: const Color(0xFF5B4BC4),
          ),
        PopupMenuButton<String>(
          tooltip: 'More actions',
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.more_vert, size: 20, color: Color(0xFF64748B)),
          onSelected: (value) {
            if (value == 'edit') onEdit?.call();
            if (value == 'compliance') onViewCompliance?.call();
          },
          itemBuilder: (context) => [
            if (onEdit != null)
              const PopupMenuItem(value: 'edit', child: Text('Edit person')),
            if (onViewCompliance != null)
              const PopupMenuItem(
                value: 'compliance',
                child: Text('View compliance'),
              ),
          ],
        ),
      ],
    );
  }

  Widget _cell(BuildContext context, String key) {
    switch (key) {
      case 'name':
        return _nameCell();
      case 'type':
        return SizedBox(
          width: _peopleColumnWidths[key],
          child: Align(alignment: Alignment.centerLeft, child: _typeCell()),
        );
      case 'roles':
        return SizedBox(
          width: _peopleColumnWidths[key],
          child: _tagCell(context, person['role'], title: 'Functional Roles'),
        );
      case 'groups':
        return SizedBox(
          width: _peopleColumnWidths[key],
          child: _tagCell(
            context,
            person['groups'],
            title: 'Groups',
            color: const Color(0xFF0891B2),
          ),
        );
      case 'status':
        return SizedBox(
          width: _peopleColumnWidths[key],
          child: Align(alignment: Alignment.centerLeft, child: _statusCell()),
        );
      case 'phone':
        return SizedBox(
          width: _peopleColumnWidths[key],
          child: _CellText(_displayValue(person['phone'])),
        );
      case 'location':
        return SizedBox(
          width: _peopleColumnWidths[key],
          child: _CellText(_displayValue(person['locations'])),
        );
      case 'lastActive':
        return SizedBox(
          width: _peopleColumnWidths[key],
          child: _CellText(_displayValue(person['last_active'])),
        );
      case 'credentials':
        if (!showCredentialsColumn) return const SizedBox.shrink();
        return SizedBox(
          width: _peopleColumnWidths[key],
          child: PersonCredentialsCell(
            credentials: credentials,
            isExpanded: credentialsExpanded,
            onToggle: onToggleCredentials,
            compliance: compliance,
            onViewCompliance: onViewCompliance,
          ),
        );
      case 'actions':
        return SizedBox(width: _peopleColumnWidths[key], child: _actionsCell());
      default:
        return const SizedBox.shrink();
    }
  }

  String _displayValue(dynamic value) {
    if (value == null) return '—';
    final text = value.toString().trim();
    return text.isEmpty ? '—' : text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: columnKeys.map((key) => _cell(context, key)).toList(),
      ),
    );
  }
}

class _CellText extends StatelessWidget {
  const _CellText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 12,
        color: Color(0xFF475569),
        height: 1.3,
      ),
    );
  }
}
