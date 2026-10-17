import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/foundation/data/services/functional_role_service.dart';
import 'package:charitask/modules/foundation/domain/models/functional_role.dart';
import 'package:charitask/modules/people/data/repositories/people_repository_impl.dart';
import 'package:charitask/modules/people/data/services/compliance_requirement_service.dart';
import 'package:charitask/modules/people/data/services/people_service.dart';
import 'package:charitask/modules/people/data/services/person_compliance_agreement_service.dart';
import 'package:charitask/modules/people/data/services/person_medical_clearance_service.dart';
import 'package:charitask/modules/people/domain/models/compliance_requirement.dart';
import 'package:charitask/modules/people/domain/models/compliance_requirement_template.dart';
import 'package:charitask/modules/people/domain/models/compliance_requirement_type.dart';
import 'package:charitask/modules/people/domain/models/compliance_rule_settings.dart';
import 'package:charitask/modules/people/domain/models/person_credential.dart';
import 'package:charitask/modules/people/domain/models/person_compliance_agreement_acknowledgement.dart';
import 'package:charitask/modules/people/domain/models/person_medical_clearance_record.dart';
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
  late final ComplianceRequirementService _requirementService;
  late final PersonComplianceAgreementService _agreementService;
  late final PersonMedicalClearanceService _medicalClearanceService;
  late final PeopleRepository _peopleRepository;

  List<FunctionalRole> _roles = [];
  List<ComplianceRequirement> _requirements = [];
  List<ComplianceRequirementTemplate> _templates = [];
  List<Map<String, dynamic>> _groups = [];
  List<Map<String, dynamic>> _people = [];
  List<PersonComplianceAgreementAcknowledgement> _agreementAcknowledgements =
      [];
  List<PersonMedicalClearanceRecord> _medicalClearanceRecords = [];
  String? _selectedPersonId;
  String? _selectedPersonName;
  bool _canViewRequirements = false;
  bool _canEditRequirements = false;
  bool _canViewPeople = false;
  bool _canViewGroups = false;
  bool _groupLoadFailed = false;
  bool _canViewAgreements = false;
  bool _canManageAgreements = false;
  bool _canViewMedicalClearance = false;
  bool _canManageMedicalClearance = false;
  bool _isLoadingPersonRecords = false;
  bool _isLoading = true;
  bool _isSavingRequirement = false;
  String? _errorMessage;
  String _peopleSearch = '';
  String _requirementSearch = '';

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
    _requirementService = ComplianceRequirementService(supabase: supabase);
    _agreementService = PersonComplianceAgreementService(supabase: supabase);
    _medicalClearanceService = PersonMedicalClearanceService(
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
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final permissions = await Future.wait<bool>([
        _hasPermission('functionalrole.view'),
        _hasPermission('functionalrole.edit'),
        _hasPermission('people.view'),
        _hasPermission('compliance.agreements.view'),
        _hasPermission('compliance.agreements.manage'),
        _hasPermission('compliance.medical_clearance.view'),
        _hasPermission('compliance.medical_clearance.manage'),
        _hasPermission('groups.view'),
      ]);
      final canViewRequirements = permissions[0];
      final canEditRequirements = permissions[1];
      final canViewPeople = permissions[2];
      final canViewAgreements = permissions[3];
      final canManageAgreements = permissions[4];
      final canViewMedicalClearance = permissions[5];
      final canManageMedicalClearance = permissions[6];
      final canViewGroups = permissions[7];

      List<FunctionalRole> roles = [];
      List<ComplianceRequirement> requirements = [];
      List<ComplianceRequirementTemplate> templates = [];
      List<Map<String, dynamic>> groups = [];
      List<Map<String, dynamic>> people = [];
      var groupLoadFailed = false;

      if (canViewRequirements) {
        roles = await _roleService.getRoles(
          organizationId: widget.organizationId,
          activeOnly: false,
        );
        requirements = await _requirementService.getRequirements(
          organizationId: widget.organizationId,
          activeOnly: true,
        );
        templates = await _requirementService.getTemplates(
          organizationId: widget.organizationId,
          activeOnly: true,
        );
      }

      if (canViewRequirements && canViewGroups) {
        try {
          groups = await _requirementService.getGroups(
            organizationId: widget.organizationId,
          );
        } catch (error) {
          groupLoadFailed = true;
          debugPrint('Compliance group targets failed to load: $error');
        }
      }

      if (canViewPeople) {
        people = await _peopleRepository.getPeople(
          organizationId: widget.organizationId,
        );
      }

      if (!mounted) {
        return;
      }
      setState(() {
        _roles = roles;
        _requirements = requirements;
        _templates = templates;
        _groups = groups;
        _people = people;
        _canViewRequirements = canViewRequirements;
        _canEditRequirements = canEditRequirements;
        _canViewPeople = canViewPeople;
        _canViewGroups = canViewGroups;
        _groupLoadFailed = groupLoadFailed;
        _canViewAgreements = canViewAgreements;
        _canManageAgreements = canManageAgreements;
        _canViewMedicalClearance = canViewMedicalClearance;
        _canManageMedicalClearance = canManageMedicalClearance;
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
      if (_selectedPersonId != null) {
        await _loadPersonComplianceRecords();
      }
    } catch (error) {
      debugPrint('Compliance module failed to load: $error');
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = 'Compliance could not be loaded. Please try again.';
      });
    }
  }

  Future<void> _loadPersonComplianceRecords() async {
    final personId = _selectedPersonId;
    if (personId == null) {
      return;
    }
    final canReadAgreements = _canViewAgreements || _canManageAgreements;
    final canReadMedical =
        _canViewMedicalClearance || _canManageMedicalClearance;
    if (!canReadAgreements && !canReadMedical) {
      if (mounted) {
        setState(() {
          _agreementAcknowledgements = [];
          _medicalClearanceRecords = [];
          _isLoadingPersonRecords = false;
        });
      }
      return;
    }

    if (mounted) setState(() => _isLoadingPersonRecords = true);
    try {
      final results = await Future.wait<dynamic>([
        canReadAgreements
            ? _agreementService.getForPerson(
                organizationId: widget.organizationId,
                personId: personId,
              )
            : Future.value(<PersonComplianceAgreementAcknowledgement>[]),
        canReadMedical
            ? _medicalClearanceService.getForPerson(
                organizationId: widget.organizationId,
                personId: personId,
              )
            : Future.value(<PersonMedicalClearanceRecord>[]),
      ]);
      if (!mounted || _selectedPersonId != personId) return;
      setState(() {
        _agreementAcknowledgements =
            results[0] as List<PersonComplianceAgreementAcknowledgement>;
        _medicalClearanceRecords =
            results[1] as List<PersonMedicalClearanceRecord>;
        _isLoadingPersonRecords = false;
      });
    } catch (error) {
      debugPrint('Loading person compliance records failed: $error');
      if (!mounted || _selectedPersonId != personId) return;
      setState(() => _isLoadingPersonRecords = false);
      _showMessage(
        'Some compliance records could not be loaded. Check access permissions.',
      );
    }
  }

  List<ComplianceRequirement> _requirementsOfType(
    ComplianceRequirementType type,
  ) => _requirements
      .where((item) => item.isActive && item.requirementType == type)
      .toList(growable: false);

  Future<String?> _pickRequirementId(ComplianceRequirementType type) async {
    final requirements = _requirementsOfType(type);
    if (requirements.isEmpty) {
      _showMessage(
        'Create an active ${type.label.toLowerCase()} requirement first.',
      );
      return null;
    }
    return showDialog<String>(
      context: context,
      builder: (_) => _ComplianceRecordRequirementPicker(
        type: type,
        requirements: requirements,
      ),
    );
  }

  Future<void> _createAgreementAcknowledgement() async {
    if (!_canManageAgreements || _selectedPersonId == null) {
      return;
    }
    final requirementId = await _pickRequirementId(
      ComplianceRequirementType.agreementAcknowledgement,
    );
    if (requirementId == null || !mounted) {
      return;
    }
    try {
      await _agreementService.createPending(
        organizationId: widget.organizationId,
        personId: _selectedPersonId!,
        complianceRequirementId: requirementId,
      );
      await _loadPersonComplianceRecords();
      if (mounted) {
        _showMessage('Pending agreement acknowledgement created.');
      }
    } catch (error) {
      debugPrint('Creating agreement acknowledgement failed: $error');
      if (mounted) {
        _showMessage(
          'Unable to create this acknowledgement. A record for this requirement version may already exist.',
        );
      }
    }
  }

  Future<void> _changeAgreementStatus(
    PersonComplianceAgreementAcknowledgement record,
    String action,
  ) async {
    if (!_canManageAgreements) return;
    if (action == 'accepted') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Confirm agreement acceptance'),
          content: Text(
            'Confirm that ${_selectedPersonName ?? 'this person'} has accepted version ${record.agreementVersion} of this agreement. This records the acknowledgment and timestamp.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Confirm acceptance'),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }
    try {
      if (action == 'accepted') {
        await _agreementService.accept(
          organizationId: widget.organizationId,
          acknowledgementId: record.id,
        );
      } else {
        await _agreementService.updateStatus(
          organizationId: widget.organizationId,
          acknowledgementId: record.id,
          status: PersonComplianceAgreementStatus.values.firstWhere(
            (status) => status.value == action,
          ),
        );
      }
      await _loadPersonComplianceRecords();
      if (mounted) {
        _showMessage('Agreement status updated.');
      }
    } catch (error) {
      debugPrint('Updating agreement acknowledgement failed: $error');
      if (mounted) {
        _showMessage('Unable to update this agreement record.');
      }
    }
  }

  Future<void> _createMedicalClearanceRecord() async {
    if (!_canManageMedicalClearance || _selectedPersonId == null) {
      return;
    }
    final requirementId = await _pickRequirementId(
      ComplianceRequirementType.medicalClearance,
    );
    if (requirementId == null || !mounted) {
      return;
    }
    final draft = await showDialog<_MedicalClearanceDraft>(
      context: context,
      builder: (_) => const _MedicalClearanceEditorDialog(),
    );
    if (draft == null || !mounted) {
      return;
    }
    try {
      await _medicalClearanceService.createRecord(
        organizationId: widget.organizationId,
        personId: _selectedPersonId!,
        complianceRequirementId: requirementId,
        status: draft.status,
        clearanceDate: draft.clearanceDate,
        expirationDate: draft.expirationDate,
      );
      await _loadPersonComplianceRecords();
      if (mounted) {
        _showMessage('Medical-clearance record created.');
      }
    } catch (error) {
      debugPrint('Creating medical clearance record failed: $error');
      if (mounted) {
        _showMessage('Unable to create this medical-clearance record.');
      }
    }
  }

  Future<void> _editMedicalClearanceRecord(
    PersonMedicalClearanceRecord record,
  ) async {
    if (!_canManageMedicalClearance) {
      return;
    }
    final draft = await showDialog<_MedicalClearanceDraft>(
      context: context,
      builder: (_) => _MedicalClearanceEditorDialog(initial: record),
    );
    if (draft == null || !mounted) {
      return;
    }
    try {
      await _medicalClearanceService.updateRecord(
        organizationId: widget.organizationId,
        recordId: record.id,
        status: draft.status,
        clearanceDate: draft.clearanceDate,
        expirationDate: draft.expirationDate,
      );
      await _loadPersonComplianceRecords();
      if (mounted) {
        _showMessage('Medical-clearance record updated.');
      }
    } catch (error) {
      debugPrint('Updating medical clearance record failed: $error');
      if (mounted) {
        _showMessage('Unable to update this medical-clearance record.');
      }
    }
  }

  String _displayDate(DateTime? date) {
    if (date == null) {
      return 'Not recorded';
    }
    return '${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.year.toString().padLeft(4, '0')}';
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

  Map<String, Map<String, dynamic>> get _groupsById => {
    for (final group in _groups)
      if (group['id']?.toString().isNotEmpty == true)
        group['id'].toString(): group,
  };

  Future<void> _openRequirementEditor({
    ComplianceRequirement? requirement,
  }) async {
    if (!_canEditRequirements || _isSavingRequirement) {
      return;
    }

    ComplianceRequirementTemplate? selectedTemplate;
    if (requirement == null) {
      final choice = await showDialog<_RequirementCreationChoice>(
        context: context,
        builder: (_) => const _RequirementCreationDialog(),
      );
      if (choice == null || !mounted) return;
      if (choice == _RequirementCreationChoice.useTemplate) {
        if (_templates.isEmpty) {
          _showMessage('No active compliance templates are available.');
          return;
        }
        selectedTemplate = await showDialog<ComplianceRequirementTemplate>(
          context: context,
          builder: (_) => _TemplatePickerDialog(templates: _templates),
        );
        if (selectedTemplate == null || !mounted) return;
      }
    }

    final draft = await showDialog<_ComplianceRequirementDraft>(
      context: context,
      builder: (_) => _ComplianceRequirementEditorDialog(
        roles: _roles.where((role) {
          return role.isActive ||
              (requirement?.functionalRoleIds.contains(role.id) ?? false);
        }).toList(),
        groups: _groups,
        canViewGroups: _canViewGroups,
        groupLoadFailed: _groupLoadFailed,
        initial: requirement,
        template: selectedTemplate,
      ),
    );
    if (draft == null || !mounted) {
      return;
    }

    setState(() => _isSavingRequirement = true);
    try {
      if (requirement == null) {
        await _requirementService.createRequirement(
          organizationId: widget.organizationId,
          name: draft.name,
          requirementType: draft.requirementType,
          credentialCategory: draft.credentialCategory,
          description: draft.description,
          rules: draft.rules,
          sourceTemplateId: draft.sourceTemplateId,
          functionalRoleIds: draft.functionalRoleIds,
          personTypes: draft.personTypes,
          groupIds: draft.groupIds,
        );
      } else {
        await _requirementService.updateRequirement(
          organizationId: widget.organizationId,
          requirementId: requirement.id,
          name: draft.name,
          requirementType: draft.requirementType,
          credentialCategory: draft.credentialCategory,
          description: draft.description,
          rules: draft.rules,
          sourceTemplateId: draft.sourceTemplateId,
          functionalRoleIds: draft.functionalRoleIds,
          personTypes: draft.personTypes,
          groupIds: draft.groupIds,
        );
      }
      await _loadModule();
      if (mounted) {
        _showMessage(
          requirement == null ? 'Requirement added.' : 'Requirement updated.',
        );
      }
    } catch (error) {
      debugPrint('Saving reusable compliance requirement failed: $error');
      if (mounted) {
        _showMessage(
          'Unable to save this requirement. Check your permissions and try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSavingRequirement = false);
      }
    }
  }

  Future<void> _deleteRequirement(ComplianceRequirement requirement) async {
    if (!_canEditRequirements || _isSavingRequirement) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Archive requirement?'),
        content: Text(
          'Archive "${requirement.name}"? It will no longer apply to compliance calculations. Existing person records and history will be retained.',
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
            child: const Text('Archive'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isSavingRequirement = true);
    try {
      await _requirementService.archiveRequirement(
        organizationId: widget.organizationId,
        requirementId: requirement.id,
      );
      await _loadModule();
      if (mounted) {
        _showMessage('Requirement archived.');
      }
    } catch (error) {
      debugPrint('Archiving compliance requirement failed: $error');
      if (mounted) {
        _showMessage('Unable to archive this requirement.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSavingRequirement = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
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
    final targetAssignments = _requirements.fold<int>(
      0,
      (total, item) =>
          total +
          item.functionalRoleIds.length +
          item.personTypes.length +
          item.groupIds.length,
    );
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
                'Active Requirements',
                '${_requirements.length}',
                Icons.list_alt_outlined,
                _purple,
              ),
              _metricCard(
                'Target Assignments',
                '$targetAssignments',
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
          title: 'Manage compliance requirements',
          description:
              'Create a requirement once and assign it to every functional role it applies to. Use a template for common nonprofit qualifications or create a custom requirement.',
          actionLabel: 'Manage Requirements',
          onAction: () => _tabController.animateTo(0),
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
        'You need functional-role view permission to view and configure Compliance Requirements.',
      );
    }

    final roles = _rolesById;
    final query = _requirementSearch.trim().toLowerCase();
    final visibleRequirements = _requirements.where((requirement) {
      if (query.isEmpty) return true;
      final roleNames = requirement.functionalRoleIds
          .map((id) => roles[id]?.name ?? '')
          .join(' ');
      final groupNames = requirement.groupIds
          .map((id) => _groupsById[id]?['name']?.toString() ?? '')
          .join(' ');
      final searchable = [
        requirement.name,
        requirement.requirementType.label,
        requirement.credentialCategory?.label ?? '',
        requirement.description ?? '',
        roleNames,
        groupNames,
        requirement.personTypes.join(' '),
      ].join(' ').toLowerCase();
      return searchable.contains(query);
    }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Compliance Requirements',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: _navy,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Create each requirement once, then target the applicable person types, functional roles, and groups.',
                    style: TextStyle(fontSize: 13, color: _muted),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: (value) => setState(() => _requirementSearch = value),
          decoration: InputDecoration(
            hintText: 'Search requirements, person types, roles, or groups',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _requirementSearch.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear search',
                    onPressed: () => setState(() => _requirementSearch = ''),
                    icon: const Icon(Icons.close),
                  ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _border),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_requirements.isEmpty)
          _emptyState(
            Icons.rule_folder_outlined,
            'No requirements configured',
            _canEditRequirements
                ? 'Create a requirement from scratch or start with a template. Target the people, responsibilities, and groups it applies to.'
                : 'An authorized administrator can configure reusable requirements for the applicable people, functional roles, and groups.',
          )
        else if (visibleRequirements.isEmpty)
          _emptyState(
            Icons.search_off_outlined,
            'No matching requirements',
            'Try another search term.',
          )
        else
          ...visibleRequirements.map((requirement) {
            final assignedRoles =
                requirement.functionalRoleIds
                    .map((id) => roles[id]?.name ?? 'Unavailable role')
                    .toList()
                  ..sort();
            final assignedPersonTypes = [...requirement.personTypes]..sort();
            final assignedGroups =
                requirement.groupIds
                    .map((id) => _groupsById[id]?['name']?.toString())
                    .whereType<String>()
                    .toList()
                  ..sort();
            final rules = requirement.rules;
            final ruleLabels = <String>[
              if (rules.requireDocumentUpload) 'Document required',
              if (rules.requireApproval) 'Approval required',
              if (rules.expirationMode == ComplianceExpirationMode.expires)
                'Expires',
              if (rules.expirationMode == ComplianceExpirationMode.neverExpires)
                'Never expires',
              if (rules.expirationMode == ComplianceExpirationMode.optional)
                'Expiration optional',
              if (rules.trackExpirationDate) 'Expiration tracked',
              if (rules.renewalPeriodValue != null)
                'Renew every ${rules.renewalPeriodValue} ${rules.renewalPeriodUnit.label.toLowerCase()}',
            ];

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
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE9FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _iconForRequirementType(requirement.requirementType),
                      color: _purple,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          requirement.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _navy,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Wrap(
                          spacing: 7,
                          runSpacing: 6,
                          children: [
                            _chip(requirement.requirementType.label, _cyan),
                            if (assignedPersonTypes.isNotEmpty)
                              _chip(
                                '${assignedPersonTypes.length} person ${assignedPersonTypes.length == 1 ? 'type' : 'types'}',
                                const Color(0xFF047857),
                              ),
                            if (assignedRoles.isNotEmpty)
                              _chip(
                                '${assignedRoles.length} ${assignedRoles.length == 1 ? 'role' : 'roles'}',
                                _purple,
                              ),
                            if (requirement.groupIds.isNotEmpty)
                              _chip(
                                '${requirement.groupIds.length} ${requirement.groupIds.length == 1 ? 'group' : 'groups'}',
                                _cyan,
                              ),
                            if (requirement.credentialCategory != null)
                              _chip(
                                requirement.credentialCategory!.label,
                                _muted,
                              ),
                            if (requirement.sourceTemplateId != null)
                              _chip('From template', const Color(0xFF047857)),
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
                        if (assignedPersonTypes.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: assignedPersonTypes
                                .map(
                                  (name) =>
                                      _chip(name, const Color(0xFF047857)),
                                )
                                .toList(),
                          ),
                        ],
                        if (assignedRoles.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: assignedRoles
                                .map((name) => _chip(name, _purple))
                                .toList(),
                          ),
                        ],
                        if (assignedGroups.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: assignedGroups
                                .map((name) => _chip(name, _cyan))
                                .toList(),
                          ),
                        ],
                        if (ruleLabels.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 7,
                            runSpacing: 6,
                            children: ruleLabels
                                .map((label) => _chip(label, _muted))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (_canEditRequirements)
                    PopupMenuButton<String>(
                      tooltip: 'Requirement actions',
                      onSelected: (action) {
                        if (action == 'edit') {
                          _openRequirementEditor(requirement: requirement);
                        } else if (action == 'archive') {
                          _deleteRequirement(requirement);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit requirement'),
                        ),
                        PopupMenuItem(
                          value: 'archive',
                          child: Text('Archive requirement'),
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

  IconData _iconForRequirementType(ComplianceRequirementType type) {
    switch (type) {
      case ComplianceRequirementType.certificationLicense:
        return Icons.workspace_premium_outlined;
      case ComplianceRequirementType.backgroundCheck:
        return Icons.shield_outlined;
      case ComplianceRequirementType.agreementAcknowledgement:
        return Icons.fact_check_outlined;
      case ComplianceRequirementType.training:
        return Icons.school_outlined;
      case ComplianceRequirementType.medicalClearance:
        return Icons.medical_services_outlined;
      case ComplianceRequirementType.otherLegacy:
        return Icons.rule_outlined;
    }
  }

  void _selectPerson(String personId, String personName) {
    setState(() {
      _selectedPersonId = personId;
      _selectedPersonName = personName;
      _agreementAcknowledgements = [];
      _medicalClearanceRecords = [];
    });
    _loadPersonComplianceRecords();
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
          const SizedBox(height: 18),
          _buildSpecializedComplianceRecords(),
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
                onTap: id.isEmpty ? null : () => _selectPerson(id, name),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildSpecializedComplianceRecords() {
    final agreementAccess = _canViewAgreements || _canManageAgreements;
    final medicalAccess =
        _canViewMedicalClearance || _canManageMedicalClearance;
    if (!agreementAccess && !medicalAccess) {
      return _emptyState(
        Icons.lock_outline,
        'Specialized compliance records restricted',
        'Your permissions do not include agreement acknowledgments or medical-clearance status.',
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_isLoadingPersonRecords)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: LinearProgressIndicator(),
          ),
        if (agreementAccess) _buildAgreementRecordsCard(),
        if (agreementAccess && medicalAccess) const SizedBox(height: 14),
        if (medicalAccess) _buildMedicalClearanceRecordsCard(),
      ],
    );
  }

  Widget _buildAgreementRecordsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.fact_check_outlined, color: _purple),
              const SizedBox(width: 9),
              const Expanded(
                child: Text(
                  'Agreement Acknowledgments',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _navy,
                  ),
                ),
              ),
              if (_canManageAgreements)
                OutlinedButton.icon(
                  onPressed: _createAgreementAcknowledgement,
                  icon: const Icon(Icons.add, size: 17),
                  label: const Text('Add'),
                ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Track accepted agreement versions and acknowledgment history.',
            style: TextStyle(fontSize: 12, color: _muted, height: 1.4),
          ),
          const SizedBox(height: 12),
          if (_agreementAcknowledgements.isEmpty)
            const Text(
              'No agreement acknowledgments recorded.',
              style: TextStyle(color: _muted, fontSize: 13),
            )
          else
            ..._agreementAcknowledgements.map((record) {
              final requirement = _requirements.where(
                (item) => item.id == record.complianceRequirementId,
              );
              final requirementName = requirement.isEmpty
                  ? 'Agreement requirement'
                  : requirement.first.name;
              final statusColor = switch (record.status) {
                PersonComplianceAgreementStatus.accepted => const Color(
                  0xFF047857,
                ),
                PersonComplianceAgreementStatus.pending => const Color(
                  0xFFB45309,
                ),
                PersonComplianceAgreementStatus.declined => const Color(
                  0xFFB91C1C,
                ),
                PersonComplianceAgreementStatus.revoked => _muted,
              };
              return Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: _border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            requirementName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: _navy,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Version ${record.agreementVersion} · ${record.acceptedAt == null ? 'No acceptance date' : 'Accepted ${_displayDate(record.acceptedAt)}'}',
                            style: const TextStyle(fontSize: 12, color: _muted),
                          ),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _chip(record.status.label, statusColor),
                          ),
                        ],
                      ),
                    ),
                    if (_canManageAgreements)
                      PopupMenuButton<String>(
                        tooltip: 'Acknowledgment actions',
                        onSelected: (value) =>
                            _changeAgreementStatus(record, value),
                        itemBuilder: (_) => [
                          if (record.status ==
                              PersonComplianceAgreementStatus.pending)
                            const PopupMenuItem(
                              value: 'accepted',
                              child: Text('Confirm accepted'),
                            ),
                          if (record.status ==
                              PersonComplianceAgreementStatus.pending)
                            const PopupMenuItem(
                              value: 'declined',
                              child: Text('Mark declined'),
                            ),
                          if (record.status ==
                              PersonComplianceAgreementStatus.accepted)
                            const PopupMenuItem(
                              value: 'revoked',
                              child: Text('Revoke acknowledgment'),
                            ),
                        ],
                      ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildMedicalClearanceRecordsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.medical_services_outlined, color: _cyan),
              const SizedBox(width: 9),
              const Expanded(
                child: Text(
                  'Medical Clearance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _navy,
                  ),
                ),
              ),
              if (_canManageMedicalClearance)
                OutlinedButton.icon(
                  onPressed: _createMedicalClearanceRecord,
                  icon: const Icon(Icons.add, size: 17),
                  label: const Text('Add'),
                ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Administrative clearance status and dates only. Do not store diagnoses or clinical notes.',
            style: TextStyle(fontSize: 12, color: _muted, height: 1.4),
          ),
          const SizedBox(height: 12),
          if (_medicalClearanceRecords.isEmpty)
            const Text(
              'No medical-clearance records recorded.',
              style: TextStyle(color: _muted, fontSize: 13),
            )
          else
            ..._medicalClearanceRecords.map((record) {
              final requirement = _requirements.where(
                (item) => item.id == record.complianceRequirementId,
              );
              final requirementName = requirement.isEmpty
                  ? 'Medical-clearance requirement'
                  : requirement.first.name;
              final isExpired = record.isExpired;
              final statusColor =
                  isExpired ||
                      record.status == PersonMedicalClearanceStatus.notCleared
                  ? const Color(0xFFB91C1C)
                  : record.status == PersonMedicalClearanceStatus.cleared
                  ? const Color(0xFF047857)
                  : record.status == PersonMedicalClearanceStatus.reviewRequired
                  ? const Color(0xFFB45309)
                  : _muted;
              return Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: _border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            requirementName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: _navy,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Cleared: ${_displayDate(record.clearanceDate)} · Expires: ${_displayDate(record.expirationDate)}',
                            style: const TextStyle(fontSize: 12, color: _muted),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              _chip(record.status.label, statusColor),
                              if (isExpired)
                                _chip('Expired', const Color(0xFFB91C1C)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (_canManageMedicalClearance)
                      IconButton(
                        tooltip: 'Edit clearance status and dates',
                        onPressed: () => _editMedicalClearanceRecord(record),
                        icon: const Icon(Icons.edit_outlined, color: _purple),
                      ),
                  ],
                ),
              );
            }),
        ],
      ),
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
                    icon: Icon(Icons.rule_outlined, size: 18),
                    text: 'Requirements',
                  ),
                  Tab(
                    icon: Icon(Icons.dashboard_outlined, size: 18),
                    text: 'Overview',
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
                    case 0:
                      return _buildRequirements();
                    case 1:
                      return _buildOverview();
                    case 2:
                      return _buildRecords();
                    default:
                      return _buildRequirements();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _ComplianceRecordRequirementPicker extends StatefulWidget {
  const _ComplianceRecordRequirementPicker({
    required this.type,
    required this.requirements,
  });

  final ComplianceRequirementType type;
  final List<ComplianceRequirement> requirements;

  @override
  State<_ComplianceRecordRequirementPicker> createState() =>
      _ComplianceRecordRequirementPickerState();
}

class _ComplianceRecordRequirementPickerState
    extends State<_ComplianceRecordRequirementPicker> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.requirements.first.id;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select ${widget.type.label} Requirement'),
      content: SizedBox(
        width: 440,
        child: DropdownButtonFormField<String>(
          initialValue: _selectedId,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Requirement'),
          items: widget.requirements
              .map(
                (item) => DropdownMenuItem(
                  value: item.id,
                  child: Text(item.name, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _selectedId = value),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _selectedId == null
              ? null
              : () => Navigator.of(context).pop(_selectedId),
          child: const Text('Continue'),
        ),
      ],
    );
  }
}

class _MedicalClearanceDraft {
  const _MedicalClearanceDraft({
    required this.status,
    this.clearanceDate,
    this.expirationDate,
  });

  final PersonMedicalClearanceStatus status;
  final DateTime? clearanceDate;
  final DateTime? expirationDate;
}

class _MedicalClearanceEditorDialog extends StatefulWidget {
  const _MedicalClearanceEditorDialog({this.initial});

  final PersonMedicalClearanceRecord? initial;

  @override
  State<_MedicalClearanceEditorDialog> createState() =>
      _MedicalClearanceEditorDialogState();
}

class _MedicalClearanceEditorDialogState
    extends State<_MedicalClearanceEditorDialog> {
  late PersonMedicalClearanceStatus _status;
  DateTime? _clearanceDate;
  DateTime? _expirationDate;
  String? _error;

  @override
  void initState() {
    super.initState();
    _status = widget.initial?.status ?? PersonMedicalClearanceStatus.pending;
    _clearanceDate = widget.initial?.clearanceDate;
    _expirationDate = widget.initial?.expirationDate;
  }

  String _dateLabel(DateTime? date) {
    if (date == null) return 'Not set';
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<DateTime?> _pickDate(DateTime? current) => showDatePicker(
    context: context,
    initialDate: current ?? DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2200),
  );

  void _save() {
    if (_status == PersonMedicalClearanceStatus.cleared &&
        _clearanceDate == null) {
      setState(
        () => _error = 'A clearance date is required when status is Cleared.',
      );
      return;
    }
    if (_clearanceDate != null &&
        _expirationDate != null &&
        _expirationDate!.isBefore(_clearanceDate!)) {
      setState(
        () => _error = 'Expiration date cannot be before the clearance date.',
      );
      return;
    }
    Navigator.of(context).pop(
      _MedicalClearanceDraft(
        status: _status,
        clearanceDate: _clearanceDate,
        expirationDate: _expirationDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initial == null
            ? 'Add Medical Clearance'
            : 'Edit Medical Clearance',
      ),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<PersonMedicalClearanceStatus>(
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: 'Administrative status',
                ),
                items: PersonMedicalClearanceStatus.values
                    .map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() {
                  if (value != null) _status = value;
                  _error = null;
                }),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  final date = await _pickDate(_clearanceDate);
                  if (date != null && mounted)
                    setState(() {
                      _clearanceDate = date;
                      _error = null;
                    });
                },
                icon: const Icon(Icons.event_available_outlined),
                label: Text('Clearance date: ${_dateLabel(_clearanceDate)}'),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _clearanceDate == null
                      ? null
                      : () => setState(() {
                          _clearanceDate = null;
                          _error = null;
                        }),
                  child: const Text('Clear date'),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  final date = await _pickDate(_expirationDate);
                  if (date != null && mounted)
                    setState(() {
                      _expirationDate = date;
                      _error = null;
                    });
                },
                icon: const Icon(Icons.event_busy_outlined),
                label: Text('Expiration date: ${_dateLabel(_expirationDate)}'),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _expirationDate == null
                      ? null
                      : () => setState(() {
                          _expirationDate = null;
                          _error = null;
                        }),
                  child: const Text('Clear date'),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: const TextStyle(
                    color: Color(0xFFB91C1C),
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              const Text(
                'Record status and dates only. Do not enter diagnoses, clinical notes, or treatment details.',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save Record')),
      ],
    );
  }
}

enum _RequirementCreationChoice { createNew, useTemplate }

class _RequirementCreationDialog extends StatelessWidget {
  const _RequirementCreationDialog();

  static const _purple = Color(0xFF5B4BC4);
  static const _navy = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Requirement'),
      content: SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _choiceCard(
              context,
              icon: Icons.library_books_outlined,
              title: 'Use Template',
              description:
                  'Start with a recommended requirement, then customize it for your organization.',
              onTap: () => Navigator.of(
                context,
              ).pop(_RequirementCreationChoice.useTemplate),
            ),
            const SizedBox(height: 12),
            _choiceCard(
              context,
              icon: Icons.add_circle_outline,
              title: 'Create New',
              description: 'Define a custom requirement from scratch.',
              onTap: () => Navigator.of(
                context,
              ).pop(_RequirementCreationChoice.createNew),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _choiceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: _purple),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _navy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: _muted),
            ],
          ),
        ),
      ),
    );
  }
}

class _TemplatePickerDialog extends StatelessWidget {
  const _TemplatePickerDialog({required this.templates});

  final List<ComplianceRequirementTemplate> templates;

  static const _navy = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _purple = Color(0xFF5B4BC4);

  IconData _iconFor(ComplianceRequirementType type) {
    switch (type) {
      case ComplianceRequirementType.certificationLicense:
        return Icons.workspace_premium_outlined;
      case ComplianceRequirementType.backgroundCheck:
        return Icons.shield_outlined;
      case ComplianceRequirementType.agreementAcknowledgement:
        return Icons.fact_check_outlined;
      case ComplianceRequirementType.training:
        return Icons.school_outlined;
      case ComplianceRequirementType.medicalClearance:
        return Icons.medical_services_outlined;
      case ComplianceRequirementType.otherLegacy:
        return Icons.rule_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [...templates]..sort((a, b) => a.name.compareTo(b.name));
    return AlertDialog(
      title: const Text('Choose a Template'),
      content: SizedBox(
        width: 560,
        height: MediaQuery.sizeOf(context).height * 0.55,
        child: sorted.isEmpty
            ? const Center(child: Text('No active templates are available.'))
            : ListView.separated(
                itemCount: sorted.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final template = sorted[index];
                  return Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.of(context).pop(template),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE9FE),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Icon(
                                _iconFor(template.requirementType),
                                color: _purple,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    template.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: _navy,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    template.description ??
                                        template.requirementType.label,
                                    style: const TextStyle(
                                      color: _muted,
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    template.requirementType.label,
                                    style: const TextStyle(
                                      color: _purple,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: _muted),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class _TargetInfoMessage extends StatelessWidget {
  const _TargetInfoMessage({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFF8FAFC),
      border: Border.all(color: const Color(0xFFE2E8F0)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Color(0xFF64748B),
            ),
          ),
        ),
      ],
    ),
  );
}

class _ComplianceRequirementDraft {
  const _ComplianceRequirementDraft({
    required this.name,
    required this.requirementType,
    required this.credentialCategory,
    required this.description,
    required this.rules,
    required this.sourceTemplateId,
    required this.functionalRoleIds,
    required this.personTypes,
    required this.groupIds,
  });

  final String name;
  final ComplianceRequirementType requirementType;
  final CredentialCategory? credentialCategory;
  final String? description;
  final ComplianceRuleSettings rules;
  final String? sourceTemplateId;
  final List<String> functionalRoleIds;
  final List<String> personTypes;
  final List<String> groupIds;
}

class _ComplianceRequirementEditorDialog extends StatefulWidget {
  const _ComplianceRequirementEditorDialog({
    required this.roles,
    required this.groups,
    required this.canViewGroups,
    required this.groupLoadFailed,
    this.initial,
    this.template,
  });

  final List<FunctionalRole> roles;
  final List<Map<String, dynamic>> groups;
  final bool canViewGroups;
  final bool groupLoadFailed;
  final ComplianceRequirement? initial;
  final ComplianceRequirementTemplate? template;

  @override
  State<_ComplianceRequirementEditorDialog> createState() =>
      _ComplianceRequirementEditorDialogState();
}

class _ComplianceRequirementEditorDialogState
    extends State<_ComplianceRequirementEditorDialog> {
  static const _purple = Color(0xFF5B4BC4);
  static const _cyan = Color(0xFF0891B2);
  static const _navy = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);
  static const _personTypeOptions = <String>[
    'Board Member',
    'Community Member',
    'Contractor',
    'Donor',
    'Executive Leadership',
    'Founder / Owner',
    'Partner Contact',
    'Staff Member',
    'Vendor Contact',
    'Volunteer',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _roleSearchController = TextEditingController();
  final _renewalController = TextEditingController();
  late ComplianceRequirementType _type;
  late CredentialCategory? _category;
  late ComplianceRuleSettings _rules;
  late Set<String> _selectedRoleIds;
  late Set<String> _selectedPersonTypes;
  late Set<String> _selectedGroupIds;
  late String? _sourceTemplateId;
  late bool _notifyPerson;
  late bool _notifySupervisor;
  int _step = 0;
  String _roleQuery = '';
  String? _stepError;

  @override
  void initState() {
    super.initState();
    final template = widget.template;
    final initial = widget.initial;
    _type =
        initial?.requirementType ??
        template?.requirementType ??
        ComplianceRequirementType.certificationLicense;
    _category =
        initial?.credentialCategory ??
        template?.credentialCategory ??
        CredentialCategory.certification;
    _nameController.text = initial?.name ?? template?.name ?? '';
    _descriptionController.text =
        initial?.description ?? template?.description ?? '';
    _rules =
        initial?.rules ??
        template?.defaultRules ??
        const ComplianceRuleSettings();
    _selectedRoleIds = initial?.functionalRoleIds.toSet() ?? <String>{};
    _selectedPersonTypes = initial?.personTypes.toSet() ?? <String>{};
    _selectedGroupIds = initial?.groupIds.toSet() ?? <String>{};
    _sourceTemplateId = initial?.sourceTemplateId ?? template?.id;
    _notifyPerson = _rules.notifications.any(
      (rule) => rule.recipient == ComplianceNotificationRecipient.person,
    );
    _notifySupervisor = _rules.notifications.any(
      (rule) => rule.recipient == ComplianceNotificationRecipient.supervisor,
    );
    _renewalController.text = _rules.renewalPeriodValue?.toString() ?? '';
    _normalizeTypeFields();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _roleSearchController.dispose();
    _renewalController.dispose();
    super.dispose();
  }

  void _normalizeTypeFields() {
    switch (_type) {
      case ComplianceRequirementType.certificationLicense:
        if (_category != CredentialCategory.certification &&
            _category != CredentialCategory.license) {
          _category = CredentialCategory.certification;
        }
        break;
      case ComplianceRequirementType.backgroundCheck:
        _category = CredentialCategory.backgroundCheck;
        break;
      case ComplianceRequirementType.training:
        _category = CredentialCategory.training;
        break;
      case ComplianceRequirementType.agreementAcknowledgement:
      case ComplianceRequirementType.medicalClearance:
        _category = null;
        break;
      case ComplianceRequirementType.otherLegacy:
        _category = CredentialCategory.other;
        break;
    }
  }

  void _updateType(ComplianceRequirementType? type) {
    if (type == null) return;
    setState(() {
      _type = type;
      _normalizeTypeFields();
      _stepError = null;
    });
  }

  void _setRule({
    ComplianceExpirationMode? expirationMode,
    int? renewalPeriodValue,
    ComplianceRenewalPeriodUnit? renewalPeriodUnit,
    bool? requireDocumentUpload,
    bool? requireApproval,
    bool? trackExpirationDate,
  }) {
    final nextExpirationMode = expirationMode ?? _rules.expirationMode;
    final renewalApplies =
        nextExpirationMode == ComplianceExpirationMode.expires;
    if (!renewalApplies) {
      _renewalController.clear();
    }
    _rules = ComplianceRuleSettings(
      expirationMode: nextExpirationMode,
      renewalPeriodValue: !renewalApplies
          ? null
          : renewalPeriodValue == -1
          ? null
          : renewalPeriodValue ?? _rules.renewalPeriodValue,
      renewalPeriodUnit: renewalPeriodUnit ?? _rules.renewalPeriodUnit,
      requireDocumentUpload:
          requireDocumentUpload ?? _rules.requireDocumentUpload,
      requireApproval: requireApproval ?? _rules.requireApproval,
      trackExpirationDate:
          nextExpirationMode == ComplianceExpirationMode.neverExpires
          ? false
          : trackExpirationDate ?? _rules.trackExpirationDate,
      notifications: _rules.notifications,
    );
  }

  ComplianceRuleSettings _buildRules() {
    final notifications = <ComplianceNotificationRule>[
      if (_notifyPerson)
        ComplianceNotificationRule(
          daysBefore: 90,
          recipient: ComplianceNotificationRecipient.person,
        ),
      if (_notifySupervisor)
        ComplianceNotificationRule(
          daysBefore: 30,
          recipient: ComplianceNotificationRecipient.supervisor,
        ),
    ];
    return ComplianceRuleSettings(
      expirationMode: _rules.expirationMode,
      renewalPeriodValue: _rules.renewalPeriodValue,
      renewalPeriodUnit: _rules.renewalPeriodUnit,
      requireDocumentUpload: _rules.requireDocumentUpload,
      requireApproval: _rules.requireApproval,
      trackExpirationDate: _rules.trackExpirationDate,
      notifications: notifications,
    );
  }

  void _next() {
    setState(() => _stepError = null);
    if (_step == 0) {
      if (!_formKey.currentState!.validate()) return;
      setState(() => _step = 1);
      return;
    }
    if (_step == 1) {
      if (_selectedRoleIds.isEmpty &&
          _selectedPersonTypes.isEmpty &&
          _selectedGroupIds.isEmpty) {
        setState(
          () => _stepError =
              'Choose at least one person type, functional role, or group.',
        );
        return;
      }
      setState(() => _step = 2);
      return;
    }
    Navigator.of(context).pop(
      _ComplianceRequirementDraft(
        name: _nameController.text.trim(),
        requirementType: _type,
        credentialCategory: _category,
        description: _nullable(_descriptionController.text),
        rules: _buildRules(),
        sourceTemplateId: _sourceTemplateId,
        functionalRoleIds: _selectedRoleIds.toList(),
        personTypes: _selectedPersonTypes.toList(),
        groupIds: _selectedGroupIds.toList(),
      ),
    );
  }

  String? _nullable(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 760,
          maxHeight: size.height * 0.88,
        ),
        child: SizedBox(
          width: 760,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 22, 18, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.initial == null
                                ? 'Add Requirement'
                                : 'Edit Requirement',
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              color: _navy,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.template == null
                                ? 'Configure the requirement, applicable roles, and rules.'
                                : 'Started from ${widget.template!.name}. Review and customize before saving.',
                            style: const TextStyle(color: _muted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildStepProgress(),
              ),
              const Divider(height: 22),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 4, 24, 18),
                    child: CheckboxTheme(
                      data: CheckboxThemeData(
                        side: WidgetStateBorderSide.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return const BorderSide(color: _purple, width: 1.6);
                          }
                          // Keep unchecked and disabled boxes clearly visible
                          // against the white dialog background.
                          return const BorderSide(
                            color: Color(0xFF64748B),
                            width: 1.6,
                          );
                        }),
                      ),
                      child: _buildStepContent(),
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
                child: Row(
                  children: [
                    if (_step > 0)
                      OutlinedButton.icon(
                        onPressed: () => setState(() {
                          _step--;
                          _stepError = null;
                        }),
                        icon: const Icon(Icons.arrow_back, size: 17),
                        label: const Text('Back'),
                      )
                    else
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    const Spacer(),
                    if (_stepError != null)
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Text(
                            _stepError!,
                            style: const TextStyle(
                              color: Color(0xFFB91C1C),
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                    FilledButton.icon(
                      onPressed: _next,
                      style: FilledButton.styleFrom(backgroundColor: _purple),
                      icon: Icon(
                        _step == 2 ? Icons.check : Icons.arrow_forward,
                        size: 17,
                      ),
                      label: Text(
                        _step == 2
                            ? (widget.initial == null
                                  ? 'Create Requirement'
                                  : 'Save Changes')
                            : 'Continue',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepProgress() {
    const labels = ['Details', 'Applies To', 'Rules'];
    return Row(
      children: List.generate(labels.length, (index) {
        final active = _step == index;
        final complete = _step > index;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == labels.length - 1 ? 0 : 10,
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active || complete
                        ? _purple
                        : const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: complete
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: active ? Colors.white : _muted,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    labels[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: active ? _purple : _muted,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return _buildDetailsStep();
      case 1:
        return _buildRolesStep();
      default:
        return _buildRulesStep();
    }
  }

  Widget _buildDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Requirement Details',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: _navy,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Choose a type. The fields below adapt to the kind of requirement.',
          style: TextStyle(color: _muted, fontSize: 13),
        ),
        const SizedBox(height: 18),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Requirement Name *',
            hintText: 'e.g. CPR Certification',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
          maxLength: 120,
          validator: (value) => value == null || value.trim().isEmpty
              ? 'Enter a requirement name.'
              : null,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<ComplianceRequirementType>(
          initialValue: _type == ComplianceRequirementType.otherLegacy
              ? ComplianceRequirementType.certificationLicense
              : _type,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Requirement Type *',
            border: OutlineInputBorder(),
          ),
          items: ComplianceRequirementType.selectable
              .map(
                (type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.label, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: _updateType,
        ),
        if (_type == ComplianceRequirementType.certificationLicense) ...[
          const SizedBox(height: 16),
          DropdownButtonFormField<CredentialCategory>(
            initialValue: _category,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Credential Category *',
              helperText: 'Choose Certification or License.',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: CredentialCategory.certification,
                child: Text('Certification'),
              ),
              DropdownMenuItem(
                value: CredentialCategory.license,
                child: Text('License'),
              ),
            ],
            onChanged: (value) => setState(() => _category = value),
          ),
        ] else if (_type == ComplianceRequirementType.backgroundCheck) ...[
          const SizedBox(height: 12),
          _fixedCategory('Background Check'),
        ] else if (_type == ComplianceRequirementType.training) ...[
          const SizedBox(height: 12),
          _fixedCategory('Training'),
        ] else if (_type ==
            ComplianceRequirementType.agreementAcknowledgement) ...[
          const SizedBox(height: 12),
          _infoBanner(
            Icons.fact_check_outlined,
            'Agreement requirement',
            'Person-level records will track acknowledgment and version separately from credential records.',
          ),
        ] else if (_type == ComplianceRequirementType.medicalClearance) ...[
          const SizedBox(height: 12),
          _infoBanner(
            Icons.medical_services_outlined,
            'Medical clearance',
            'Use rules below to require documents, approval, and applicable review or expiration dates.',
          ),
        ],
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description (optional)',
            hintText: 'Explain what needs to be completed or verified.',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          minLines: 2,
          maxLines: 4,
          maxLength: 500,
        ),
      ],
    );
  }

  Widget _fixedCategory(String label) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFF8FAFC),
      border: Border.all(color: _border),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        const Icon(Icons.lock_outline, size: 17, color: _muted),
        const SizedBox(width: 8),
        Text(
          '$label category is set automatically',
          style: const TextStyle(color: _muted, fontSize: 13),
        ),
      ],
    ),
  );

  Widget _infoBanner(IconData icon, String title, String description) =>
      Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          border: Border.all(color: _border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: _purple, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _navy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildRolesStep() {
    final query = _roleQuery.trim().toLowerCase();
    final visiblePersonTypes = _personTypeOptions
        .where((type) => query.isEmpty || type.toLowerCase().contains(query))
        .toList();
    final visibleRoles =
        widget.roles
            .where(
              (role) =>
                  query.isEmpty || role.name.toLowerCase().contains(query),
            )
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));
    final visibleGroups =
        widget.groups.where((group) {
          final name = group['name']?.toString() ?? '';
          final type =
              group['group_type']?.toString().replaceAll('_', ' ') ?? '';
          return query.isEmpty ||
              name.toLowerCase().contains(query) ||
              type.toLowerCase().contains(query);
        }).toList()..sort(
          (a, b) => (a['name']?.toString() ?? '').compareTo(
            b['name']?.toString() ?? '',
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Applies To',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: _navy,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Choose who this requirement applies to. A person matches when they meet at least one selected target: person type, functional role, or group.',
          style: TextStyle(color: _muted, fontSize: 13, height: 1.45),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _roleSearchController,
          onChanged: (value) => setState(() => _roleQuery = value),
          decoration: InputDecoration(
            hintText: 'Search person types, functional roles, or groups',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _roleQuery.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear search',
                    onPressed: () {
                      _roleSearchController.clear();
                      setState(() => _roleQuery = '');
                    },
                    icon: const Icon(Icons.close),
                  ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Person Types',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: _navy,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Applies to people of the selected type even when they have no functional role or group assignment.',
          style: TextStyle(color: _muted, fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 9),
        if (visiblePersonTypes.isEmpty)
          const Text(
            'No person types match that search.',
            style: TextStyle(color: _muted, fontSize: 12),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: visiblePersonTypes.map((personType) {
              return FilterChip(
                label: Text(personType),
                selected: _selectedPersonTypes.contains(personType),
                onSelected: (selected) => setState(() {
                  if (selected) {
                    _selectedPersonTypes.add(personType);
                  } else {
                    _selectedPersonTypes.remove(personType);
                  }
                  _stepError = null;
                }),
              );
            }).toList(),
          ),
        const SizedBox(height: 20),
        const Divider(height: 1),
        const SizedBox(height: 16),
        const Text(
          'Functional Roles',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: _navy,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Target specific responsibilities when a qualification is required only for certain roles.',
          style: TextStyle(color: _muted, fontSize: 12, height: 1.4),
        ),
        Row(
          children: [
            TextButton(
              onPressed: widget.roles.isEmpty
                  ? null
                  : () => setState(() {
                      _selectedRoleIds.addAll(
                        widget.roles.map((role) => role.id),
                      );
                      _stepError = null;
                    }),
              child: const Text('Select All'),
            ),
            TextButton(
              onPressed: _selectedRoleIds.isEmpty
                  ? null
                  : () => setState(() {
                      _selectedRoleIds.clear();
                      _stepError = null;
                    }),
              child: const Text('Clear All'),
            ),
            const Spacer(),
            Text(
              '${_selectedRoleIds.length} of ${widget.roles.length} selected',
              style: const TextStyle(
                color: _purple,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const Divider(height: 1),
        if (visibleRoles.isEmpty)
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'No functional roles match that search.',
              style: TextStyle(color: _muted, fontSize: 12),
            ),
          )
        else
          ...visibleRoles.map(
            (role) => CheckboxListTile(
              value: _selectedRoleIds.contains(role.id),
              onChanged: (checked) => setState(() {
                if (checked == true) {
                  _selectedRoleIds.add(role.id);
                } else {
                  _selectedRoleIds.remove(role.id);
                }
                _stepError = null;
              }),
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                role.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _navy,
                ),
              ),
              secondary: role.isActive
                  ? null
                  : const Tooltip(
                      message: 'Inactive role',
                      child: Icon(
                        Icons.pause_circle_outline,
                        color: _muted,
                        size: 19,
                      ),
                    ),
            ),
          ),
        const SizedBox(height: 20),
        const Divider(height: 1),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Groups (Optional)',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: _navy,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Apply the requirement to members of selected groups, such as a volunteer cohort or ReStore team.',
                    style: TextStyle(color: _muted, fontSize: 12, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${_selectedGroupIds.length} selected',
              style: const TextStyle(
                color: _cyan,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (!widget.canViewGroups)
          const _TargetInfoMessage(
            icon: Icons.lock_outline,
            text:
                'Groups are optional. You need Groups view permission to browse and select groups.',
          )
        else if (widget.groupLoadFailed)
          const _TargetInfoMessage(
            icon: Icons.error_outline,
            text:
                'Groups could not be loaded. You can still target person types or functional roles.',
          )
        else if (widget.groups.isEmpty)
          const _TargetInfoMessage(
            icon: Icons.groups_outlined,
            text:
                'No active groups are available. Create or activate a group to use group targeting.',
          )
        else ...[
          Row(
            children: [
              TextButton(
                onPressed: visibleGroups.isEmpty
                    ? null
                    : () => setState(() {
                        _selectedGroupIds.addAll(
                          visibleGroups.map((group) => group['id'].toString()),
                        );
                        _stepError = null;
                      }),
                child: const Text('Select Visible'),
              ),
              TextButton(
                onPressed: _selectedGroupIds.isEmpty
                    ? null
                    : () => setState(() {
                        _selectedGroupIds.clear();
                        _stepError = null;
                      }),
                child: const Text('Clear Groups'),
              ),
              const Spacer(),
              Text(
                '${_selectedGroupIds.length} of ${widget.groups.length} selected',
                style: const TextStyle(
                  color: _cyan,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Divider(height: 1),
          if (visibleGroups.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'No groups match that search.',
                style: TextStyle(color: _muted, fontSize: 12),
              ),
            )
          else
            ...visibleGroups.map((group) {
              final id = group['id']?.toString() ?? '';
              final name = group['name']?.toString() ?? 'Unnamed group';
              final rawType = group['group_type']?.toString() ?? '';
              final typeLabel = rawType.isEmpty
                  ? 'Group'
                  : rawType
                        .split('_')
                        .map(
                          (part) => part.isEmpty
                              ? part
                              : '${part[0].toUpperCase()}${part.substring(1)}',
                        )
                        .join(' ');
              return CheckboxListTile(
                value: id.isNotEmpty && _selectedGroupIds.contains(id),
                onChanged: id.isEmpty
                    ? null
                    : (checked) => setState(() {
                        if (checked == true) {
                          _selectedGroupIds.add(id);
                        } else {
                          _selectedGroupIds.remove(id);
                        }
                        _stepError = null;
                      }),
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _navy,
                  ),
                ),
                subtitle: Text(
                  typeLabel,
                  style: const TextStyle(fontSize: 11, color: _muted),
                ),
              );
            }),
        ],
        if (_stepError != null) ...[
          const SizedBox(height: 8),
          Text(
            _stepError!,
            style: const TextStyle(color: Color(0xFFB91C1C), fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _buildRulesStep() {
    final agreement =
        _type == ComplianceRequirementType.agreementAcknowledgement;
    final showExpiration = !agreement;
    final showRenewal =
        showExpiration &&
        _rules.expirationMode == ComplianceExpirationMode.expires;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Compliance Rules',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: _navy,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Define the evidence, review, and renewal expectations for this requirement.',
          style: TextStyle(color: _muted, fontSize: 13),
        ),
        if (showExpiration) ...[
          const SizedBox(height: 18),
          const Text(
            'Expiration',
            style: TextStyle(color: _navy, fontWeight: FontWeight.w700),
          ),
          RadioGroup<ComplianceExpirationMode>(
            groupValue: _rules.expirationMode,
            onChanged: (value) =>
                setState(() => _setRule(expirationMode: value)),
            child: const Column(
              children: [
                RadioListTile<ComplianceExpirationMode>(
                  value: ComplianceExpirationMode.expires,
                  title: Text('Expires'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<ComplianceExpirationMode>(
                  value: ComplianceExpirationMode.neverExpires,
                  title: Text('Never Expires'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<ComplianceExpirationMode>(
                  value: ComplianceExpirationMode.optional,
                  title: Text('Expiration Date Optional'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
        if (showRenewal) ...[
          const SizedBox(height: 10),
          const Text(
            'Renewal Period',
            style: TextStyle(color: _navy, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 120,
                child: TextFormField(
                  controller: _renewalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: '2',
                    labelText: 'Every',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    final parsed = int.tryParse(value.trim());
                    setState(() => _setRule(renewalPeriodValue: parsed ?? -1));
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<ComplianceRenewalPeriodUnit>(
                  initialValue: _rules.renewalPeriodUnit,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: ComplianceRenewalPeriodUnit.values
                      .map(
                        (unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(unit.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _setRule(renewalPeriodUnit: value)),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 18),
        const Text(
          'Verification',
          style: TextStyle(color: _navy, fontWeight: FontWeight.w700),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          value: _rules.requireDocumentUpload,
          activeThumbColor: Colors.white,
          activeTrackColor: _purple,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFFCBD5E1),
          onChanged: (value) =>
              setState(() => _setRule(requireDocumentUpload: value)),
          title: Text(
            agreement
                ? 'Require signed document upload'
                : 'Require document upload',
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          value: _rules.requireApproval,
          activeThumbColor: Colors.white,
          activeTrackColor: _purple,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFFCBD5E1),
          onChanged: (value) =>
              setState(() => _setRule(requireApproval: value)),
          title: const Text('Require approval or verification'),
        ),
        if (showExpiration)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            value: _rules.trackExpirationDate,
            activeThumbColor: Colors.white,
            activeTrackColor: _purple,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFCBD5E1),
            onChanged: (value) =>
                setState(() => _setRule(trackExpirationDate: value)),
            title: const Text('Track expiration date'),
          ),
        const SizedBox(height: 12),
        const Text(
          'Notifications',
          style: TextStyle(color: _navy, fontWeight: FontWeight.w700),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          value: _notifyPerson,
          activeThumbColor: Colors.white,
          activeTrackColor: _purple,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFFCBD5E1),
          onChanged: showExpiration
              ? (value) => setState(() => _notifyPerson = value)
              : null,
          title: const Text('Notify person 90 days before expiration'),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          value: _notifySupervisor,
          activeThumbColor: Colors.white,
          activeTrackColor: _purple,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFFCBD5E1),
          onChanged: showExpiration
              ? (value) => setState(() => _notifySupervisor = value)
              : null,
          title: const Text('Notify supervisor 30 days before expiration'),
        ),
        if (_type == ComplianceRequirementType.backgroundCheck) ...[
          const SizedBox(height: 10),
          _infoBanner(
            Icons.lock_outline,
            'Background-check privacy',
            'Keep report details outside this record. Use completion and review status, with background-check access controlled separately.',
          ),
        ],
      ],
    );
  }
}
