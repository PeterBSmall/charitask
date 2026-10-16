import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/foundation/data/services/functional_role_service.dart';
import 'package:charitask/modules/foundation/domain/models/functional_role.dart';
import 'package:charitask/modules/people/data/repositories/people_repository_impl.dart';
import 'package:charitask/modules/people/data/services/functional_role_credential_requirement_service.dart';
import 'package:charitask/modules/people/data/services/people_service.dart';
import 'package:charitask/modules/people/domain/models/functional_role_credential_requirement.dart';
import 'package:charitask/modules/people/domain/models/person_credential.dart';
import 'package:charitask/modules/people/domain/repositories/people_repository.dart';
import 'package:charitask/modules/people/domain/services/credential_compliance_evaluator.dart';
import 'package:charitask/modules/people/widgets/edit_person/edit_person_credentials.dart';
import 'package:charitask/platform/authorization/authorization_service.dart';

class CompliancePage extends StatefulWidget {
  const CompliancePage({
    super.key,
    required this.organizationId,
    this.initialPersonId,
    this.initialPersonName,
    this.initialRequirementAssessment,
  });

  final String organizationId;
  final String? initialPersonId;
  final String? initialPersonName;
  final CredentialRequirementAssessment? initialRequirementAssessment;

  @override
  State<CompliancePage> createState() => _CompliancePageState();
}

class _CompliancePageState extends State<CompliancePage>
    with SingleTickerProviderStateMixin {
  static const _purple = Color(0xFF5B4BC4);
  static const _cyan = Color(0xFF0891B2);
  static const _navy = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  late final TabController _tabController;
  late final AuthorizationService _authorization;
  late final FunctionalRoleService _roleService;
  late final FunctionalRoleCredentialRequirementService _requirementService;
  late final PeopleRepository _peopleRepository;

  List<FunctionalRole> _roles = [];
  List<FunctionalRoleCredentialRequirement> _requirements = [];
  List<Map<String, dynamic>> _people = [];
  String? _selectedPersonId;
  String? _selectedPersonName;
  bool _canViewRequirements = false;
  bool _canEditRequirements = false;
  bool _canViewPeople = false;
  bool _isLoading = true;
  bool _isSavingRequirement = false;
  String? _errorMessage;
  String _peopleSearch = '';

  @override
  void initState() {
    super.initState();
    final hasInitialRecord = widget.initialPersonId != null;
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: hasInitialRecord ? 2 : 0,
    );
    _selectedPersonId = widget.initialPersonId;
    _selectedPersonName = widget.initialPersonName;

    final supabase = Supabase.instance.client;
    _authorization = AuthorizationService(supabase);
    _roleService = FunctionalRoleService(supabase: supabase);
    _requirementService = FunctionalRoleCredentialRequirementService(
      supabase: supabase,
    );
    _peopleRepository = PeopleRepositoryImpl(PeopleService(supabase));
    _loadModule();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<bool> _hasPermission(String key) => _authorization.hasPermission(
    organizationId: widget.organizationId,
    permissionKey: key,
  );

  Future<void> _loadModule() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final permissions = await Future.wait<bool>([
        _hasPermission('functionalrole.view'),
        _hasPermission('functionalrole.edit'),
        _hasPermission('people.view'),
      ]);
      _canViewRequirements = permissions[0];
      _canEditRequirements = permissions[1];
      _canViewPeople = permissions[2];

      List<FunctionalRole> roles = [];
      List<FunctionalRoleCredentialRequirement> requirements = [];
      List<Map<String, dynamic>> people = [];

      if (_canViewRequirements) {
        roles = await _roleService.getRoles(
          organizationId: widget.organizationId,
          activeOnly: false,
        );
        requirements = await _requirementService.getForRoles(
          organizationId: widget.organizationId,
          roleIds: roles.map((role) => role.id).toList(),
        );
      }

      if (_canViewPeople) {
        people = await _peopleRepository.getPeople(
          organizationId: widget.organizationId,
        );
      }

      if (!mounted) return;
      setState(() {
        _roles = roles;
        _requirements = requirements;
        _people = people;
        _isLoading = false;
        _errorMessage = null;

        if (_selectedPersonId != null && _selectedPersonName == null) {
          final person = people.where(
            (item) => item['id']?.toString() == _selectedPersonId,
          );
          if (person.isNotEmpty) {
            _selectedPersonName = _personName(person.first);
          }
        }
      });
    } catch (error) {
      debugPrint('Compliance module failed to load: $error');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Compliance could not be loaded. Please try again.';
      });
    }
  }

  String _personName(Map<String, dynamic> person) {
    final preferred = person['preferred_name']?.toString().trim() ?? '';
    final first = preferred.isNotEmpty
        ? preferred
        : person['first_name']?.toString().trim() ?? '';
    final last = person['last_name']?.toString().trim() ?? '';
    return '$first $last'.trim().isEmpty
        ? 'Unnamed person'
        : '$first $last'.trim();
  }

  Map<String, FunctionalRole> get _rolesById => {
    for (final role in _roles) role.id: role,
  };

  Future<void> _openRequirementEditor({
    FunctionalRoleCredentialRequirement? requirement,
  }) async {
    if (!_canEditRequirements || _isSavingRequirement) return;
    if (_roles.isEmpty) {
      _showMessage('Create a functional role before adding requirements.');
      return;
    }

    final draft = await showDialog<_RequirementDraft>(
      context: context,
      builder: (_) =>
          _RequirementEditorDialog(roles: _roles, initial: requirement),
    );
    if (draft == null || !mounted) return;

    setState(() => _isSavingRequirement = true);
    try {
      if (requirement == null) {
        await _requirementService.create(
          organizationId: widget.organizationId,
          functionalRoleId: draft.role.id,
          category: draft.category,
          credentialName: draft.name,
          description: draft.description,
        );
      } else {
        await _requirementService.update(
          organizationId: widget.organizationId,
          functionalRoleId: draft.role.id,
          requirementId: requirement.id,
          category: draft.category,
          credentialName: draft.name,
          description: draft.description,
        );
      }
      await _loadModule();
      if (mounted) {
        _showMessage(
          requirement == null ? 'Requirement added.' : 'Requirement updated.',
        );
      }
    } catch (error) {
      debugPrint('Saving compliance requirement failed: $error');
      if (mounted) _showMessage('Unable to save this requirement.');
    } finally {
      if (mounted) setState(() => _isSavingRequirement = false);
    }
  }

  Future<void> _deleteRequirement(
    FunctionalRoleCredentialRequirement requirement,
  ) async {
    if (!_canEditRequirements || _isSavingRequirement) return;
    final roleName = _rolesById[requirement.functionalRoleId]?.name ?? 'role';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove requirement?'),
        content: Text(
          'Remove "${requirement.credentialName?.trim().isNotEmpty == true ? requirement.credentialName : requirement.category.label}" from $roleName? Existing credential records will not be deleted.',
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
    if (confirmed != true || !mounted) return;

    setState(() => _isSavingRequirement = true);
    try {
      await _requirementService.delete(
        organizationId: widget.organizationId,
        functionalRoleId: requirement.functionalRoleId,
        requirementId: requirement.id,
      );
      await _loadModule();
      if (mounted) _showMessage('Requirement removed.');
    } catch (error) {
      debugPrint('Deleting compliance requirement failed: $error');
      if (mounted) _showMessage('Unable to remove this requirement.');
    } finally {
      if (mounted) setState(() => _isSavingRequirement = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _pageHeader() => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 680;
      final showBack = widget.initialPersonId != null;
      final addRequirementButton = FilledButton.icon(
        onPressed: !_canEditRequirements || _isSavingRequirement
            ? null
            : () => _openRequirementEditor(),
        icon: const Icon(Icons.add, size: 19),
        label: const Text('Add Requirement'),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: _purple,
          disabledBackgroundColor: Colors.white70,
          disabledForegroundColor: _purple.withValues(alpha: 0.55),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      );

      final titleBlock = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Compliance',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Requirements, qualifications, and compliance records.',
            style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.4),
          ),
        ],
      );

      final titleRow = Row(
        children: [
          if (showBack) ...[
            IconButton(
              tooltip: 'Back to People',
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const SizedBox(width: 4),
          ],
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.fact_check_outlined,
              color: Colors.white,
              size: 29,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: titleBlock),
        ],
      );

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4338B8), Color(0xFF5B4BC4)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: compact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  titleRow,
                  if (_canEditRequirements) ...[
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: addRequirementButton,
                    ),
                  ],
                ],
              )
            : Row(
                children: [
                  Expanded(child: titleRow),
                  if (_canEditRequirements) ...[
                    const SizedBox(width: 18),
                    addRequirementButton,
                  ],
                ],
              ),
      );
    },
  );

  Widget _buildOverview() {
    final rolesCovered = _requirements
        .map((item) => item.functionalRoleId)
        .toSet()
        .length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final count = constraints.maxWidth >= 900
                ? 3
                : constraints.maxWidth >= 560
                ? 2
                : 1;
            final gap = 14.0;
            final width = (constraints.maxWidth - gap * (count - 1)) / count;
            final metrics = <Widget>[
              _metricCard(
                'Configured Requirements',
                '${_requirements.length}',
                Icons.list_alt_outlined,
                _purple,
              ),
              _metricCard(
                'Roles Covered',
                '$rolesCovered',
                Icons.badge_outlined,
                _cyan,
              ),
              _metricCard(
                'People Available',
                _canViewPeople ? '${_people.length}' : 'Restricted',
                Icons.people_outline,
                const Color(0xFF047857),
              ),
            ];
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: metrics
                  .map((metric) => SizedBox(width: width, child: metric))
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 20),
        _sectionCard(
          icon: Icons.checklist_outlined,
          title: 'Set clear role requirements',
          description:
              'Define which credentials are required for each functional role. Requirements configured here are used by the People dashboard to calculate credential compliance.',
          actionLabel: 'Manage Requirements',
          onAction: () => _tabController.animateTo(1),
        ),
        const SizedBox(height: 14),
        _sectionCard(
          icon: Icons.folder_shared_outlined,
          title: 'Manage individual records',
          description:
              'Open a person’s credential records, update dates and verification status, and manage supporting documents without editing their general profile.',
          actionLabel: 'Open Records',
          onAction: () => _tabController.animateTo(2),
        ),
      ],
    );
  }

  Widget _metricCard(String label, String value, IconData icon, Color color) =>
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: _navy,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 12, color: _muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required String description,
    required String actionLabel,
    required VoidCallback onAction,
  }) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: _border),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _purple, size: 28),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: _muted,
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton(
                  onPressed: onAction,
                  child: Text(actionLabel),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildRequirements() {
    if (!_canViewRequirements) {
      return _emptyState(
        Icons.lock_outline,
        'Requirements restricted',
        'You need functional-role view permission to view and configure role requirements.',
      );
    }
    final roles = _rolesById;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Requirements by Role',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: _navy,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Define the credentials people need for each assigned role.',
                    style: TextStyle(fontSize: 13, color: _muted),
                  ),
                ],
              ),
            ),
            if (_canEditRequirements)
              FilledButton.icon(
                onPressed: _isSavingRequirement
                    ? null
                    : () => _openRequirementEditor(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Requirement'),
                style: FilledButton.styleFrom(backgroundColor: _purple),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (_requirements.isEmpty)
          _emptyState(
            Icons.rule_folder_outlined,
            'No requirements configured',
            _canEditRequirements
                ? 'Add a requirement to define what credentials are needed for a functional role.'
                : 'An authorized administrator can configure requirements for functional roles.',
          )
        else
          ..._requirements.map((requirement) {
            final roleName =
                roles[requirement.functionalRoleId]?.name ?? 'Unavailable role';
            final name = requirement.credentialName?.trim();
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: _border),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.verified_user_outlined,
                      color: _cyan,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name?.isNotEmpty == true
                              ? name!
                              : requirement.category.label,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _navy,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _chip(roleName, _purple),
                            _chip(requirement.category.label, _cyan),
                          ],
                        ),
                        if (requirement.description?.trim().isNotEmpty ==
                            true) ...[
                          const SizedBox(height: 8),
                          Text(
                            requirement.description!.trim(),
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: _muted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (_canEditRequirements)
                    PopupMenuButton<String>(
                      tooltip: 'Requirement actions',
                      onSelected: (action) {
                        if (action == 'edit')
                          _openRequirementEditor(requirement: requirement);
                        if (action == 'delete') _deleteRequirement(requirement);
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit requirement'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Remove requirement'),
                        ),
                      ],
                    ),
                ],
              ),
            );
          }),
        if (_isSavingRequirement) const LinearProgressIndicator(color: _purple),
      ],
    );
  }

  Widget _buildRecords() {
    final selectedId = _selectedPersonId;
    if (selectedId != null) {
      final selectedPerson = _people.where(
        (person) => person['id']?.toString() == selectedId,
      );
      final displayName =
          _selectedPersonName ??
          (selectedPerson.isNotEmpty
              ? _personName(selectedPerson.first)
              : 'Selected person');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Back to people',
                onPressed: () => setState(() {
                  _selectedPersonId = null;
                  _selectedPersonName = null;
                }),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: _navy,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Credential records and supporting documentation',
                      style: TextStyle(fontSize: 13, color: _muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          EditPersonCredentials(
            key: ValueKey(
              'credentials-$selectedId-${widget.initialRequirementAssessment?.requirement.id ?? 'all'}',
            ),
            organizationId: widget.organizationId,
            personId: selectedId,
            initialRequirementAssessment: widget.initialRequirementAssessment,
          ),
        ],
      );
    }

    if (!_canViewPeople) {
      return _emptyState(
        Icons.lock_outline,
        'People list restricted',
        'You need people view permission to choose a person. Use a compliance link from a person record if your access permits credential management.',
      );
    }

    final query = _peopleSearch.trim().toLowerCase();
    final filtered =
        _people.where((person) {
          if (query.isEmpty) return true;
          final values = [
            person['first_name'],
            person['last_name'],
            person['preferred_name'],
            person['email'],
          ];
          return values.any(
            (value) => value?.toString().toLowerCase().contains(query) == true,
          );
        }).toList()..sort(
          (a, b) => _personName(
            a,
          ).toLowerCase().compareTo(_personName(b).toLowerCase()),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Compliance Records',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: _navy,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Choose a person to view or manage their credentials. This does not open their general profile editor.',
          style: TextStyle(fontSize: 13, height: 1.45, color: _muted),
        ),
        const SizedBox(height: 14),
        TextField(
          onChanged: (value) => setState(() => _peopleSearch = value),
          decoration: InputDecoration(
            hintText: 'Search people',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _border),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          _emptyState(
            Icons.person_search_outlined,
            'No people found',
            'Try another name or email address.',
          )
        else
          ...filtered.map((person) {
            final id = person['id']?.toString() ?? '';
            final name = _personName(person);
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: _border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFEDE9FE),
                  child: Text(
                    name.isEmpty ? '?' : name[0].toUpperCase(),
                    style: const TextStyle(
                      color: _purple,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                title: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: _navy,
                  ),
                ),
                subtitle: Text(
                  person['email']?.toString() ?? 'No email address',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: id.isEmpty
                    ? null
                    : () => setState(() {
                        _selectedPersonId = id;
                        _selectedPersonName = name;
                      }),
              ),
            );
          }),
      ],
    );
  }

  Widget _chip(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .10),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
    ),
  );

  Widget _emptyState(IconData icon, String title, String description) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, size: 34, color: const Color(0xFF94A3B8)),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700, color: _navy),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, height: 1.45, color: _muted),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F8FC),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pageHeader(),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE9FE),
                borderRadius: BorderRadius.circular(13),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: _purple,
                unselectedLabelColor: _muted,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.dashboard_outlined, size: 18),
                    text: 'Overview',
                  ),
                  Tab(
                    icon: Icon(Icons.rule_outlined, size: 18),
                    text: 'Requirements',
                  ),
                  Tab(
                    icon: Icon(Icons.folder_shared_outlined, size: 18),
                    text: 'Records',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const SizedBox(
                height: 280,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_errorMessage != null)
              _emptyState(
                Icons.error_outline,
                'Unable to load Compliance',
                _errorMessage!,
              )
            else
              AnimatedBuilder(
                animation: _tabController,
                builder: (context, _) {
                  switch (_tabController.index) {
                    case 1:
                      return _buildRequirements();
                    case 2:
                      return _buildRecords();
                    case 0:
                    default:
                      return _buildOverview();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _RequirementDraft {
  const _RequirementDraft({
    required this.role,
    required this.category,
    required this.name,
    required this.description,
  });

  final FunctionalRole role;
  final CredentialCategory category;
  final String? name;
  final String? description;
}

class _RequirementEditorDialog extends StatefulWidget {
  const _RequirementEditorDialog({required this.roles, this.initial});

  final List<FunctionalRole> roles;
  final FunctionalRoleCredentialRequirement? initial;

  @override
  State<_RequirementEditorDialog> createState() =>
      _RequirementEditorDialogState();
}

class _RequirementEditorDialogState extends State<_RequirementEditorDialog> {
  static const _purple = Color(0xFF5B4BC4);
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late String _roleId;
  late CredentialCategory _category;

  @override
  void initState() {
    super.initState();
    _roleId = widget.initial?.functionalRoleId ?? widget.roles.first.id;
    _category = widget.initial?.category ?? CredentialCategory.values.first;
    _nameController = TextEditingController(
      text: widget.initial?.credentialName ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initial?.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initial == null
            ? 'Add Compliance Requirement'
            : 'Edit Compliance Requirement',
      ),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Functional Role',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 7),
                DropdownButtonFormField<String>(
                  value: _roleId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: widget.roles
                      .map(
                        (role) => DropdownMenuItem(
                          value: role.id,
                          child: Text(
                            role.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: widget.initial == null
                      ? (value) => setState(() => _roleId = value ?? _roleId)
                      : null,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Credential Category',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 7),
                DropdownButtonFormField<CredentialCategory>(
                  value: _category,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: CredentialCategory.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _category = value ?? _category),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Required Credential Name (optional)',
                    hintText: 'e.g. Driver’s License',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  maxLength: 120,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    hintText: 'What needs to be verified?',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  minLines: 2,
                  maxLines: 4,
                  maxLength: 500,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.of(context).pop(
              _RequirementDraft(
                role: widget.roles.firstWhere((role) => role.id == _roleId),
                category: _category,
                name: _nullable(_nameController.text),
                description: _nullable(_descriptionController.text),
              ),
            );
          },
          style: FilledButton.styleFrom(backgroundColor: _purple),
          child: Text(
            widget.initial == null ? 'Add Requirement' : 'Save Changes',
          ),
        ),
      ],
    );
  }

  String? _nullable(String value) {
    final text = value.trim();
    return text.isEmpty ? null : text;
  }
}
