import 'package:flutter/material.dart';
import 'package:charitask/modules/people/widgets/edit_person/edit_person_organizational_assignments.dart';
import 'package:charitask/modules/people/widgets/edit_person/edit_person_app_bar_title.dart';

import 'package:intl/intl.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/foundation/data/services/functional_role_service.dart';

import 'package:charitask/modules/foundation/domain/models/functional_role.dart';

import 'package:charitask/modules/foundation/domain/models/functional_role_assignment.dart';

import 'package:charitask/modules/people/data/repositories/people_repository_impl.dart';

import 'package:charitask/modules/people/data/services/people_service.dart';

import 'package:charitask/modules/people/data/services/person_private_details_service.dart';

import 'package:charitask/modules/people/domain/repositories/people_repository.dart';

import 'package:charitask/modules/people/widgets/edit_person/edit_person_basic_information.dart';

import 'package:charitask/modules/people/widgets/edit_person/edit_person_private_details.dart';

import 'package:charitask/modules/people/widgets/edit_person/edit_person_section_navigation.dart';

import 'package:charitask/platform/authorization/authorization_service.dart';

import 'package:charitask/modules/people/widgets/edit_person/edit_person_credentials.dart';

class EditPersonPage extends StatefulWidget {
  const EditPersonPage({
    super.key,

    required this.organizationId,

    required this.personId,
  });

  final String organizationId;

  final String personId;

  @override
  State<EditPersonPage> createState() => _EditPersonPageState();
}

class _EditPersonPageState extends State<EditPersonPage> {
  late final PeopleRepository _repository;

  late final AuthorizationService _authorization;

  late final PersonPrivateDetailsService _privateDetailsService;

  late final FunctionalRoleService _functionalRoleService;

  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _preferredNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _phoneController = TextEditingController();

  final _notesController = TextEditingController();

  final _dateOfBirthController = TextEditingController();

  final _providerNameController = TextEditingController();

  final _providerRelationshipController = TextEditingController();

  static const List<String> _personTypeChoices = [
    'Founder / Owner',

    'Executive Leadership',

    'Staff Member',

    'Volunteer',

    'Board Member',

    'Donor',

    'Contractor',

    'Partner Contact',

    'Vendor Contact',

    'Community Member',
  ];

  static const List<String> _statusChoices = ['active', 'inactive'];

  bool _isLoading = true;

  bool _isSaving = false;

  String? _errorMessage;

  String _selectedSection = 'basic';

  String _personType = '';

  String _engagementType = '';

  String _status = 'active';

  String _informationProviderType = 'organization_staff';

  bool _canEditPerson = false;

  bool _canViewPrivateDetails = false;

  bool _canManagePrivateDetails = false;

  bool _canViewFunctionalRoles = false;

  bool _canManageFunctionalRoles = false;

  bool _canViewGroups = false;

  bool _canViewCredentials = false;

  bool _canManageCredentials = false;

  bool _canViewBackgroundChecks = false;

  bool _canManageBackgroundChecks = false;

  bool _privateDetailsLoadFailed = false;

  List<FunctionalRole> _functionalRoles = [];

  List<FunctionalRoleAssignment> _roleAssignments = [];

  @override
  void initState() {
    super.initState();

    final supabase = Supabase.instance.client;

    _repository = PeopleRepositoryImpl(PeopleService(supabase));

    _authorization = AuthorizationService(supabase);

    _privateDetailsService = PersonPrivateDetailsService(supabase: supabase);

    _functionalRoleService = FunctionalRoleService(supabase: supabase);

    _loadPerson();
  }

  @override
  void dispose() {
    _firstNameController.dispose();

    _lastNameController.dispose();

    _preferredNameController.dispose();

    _emailController.dispose();

    _phoneController.dispose();

    _notesController.dispose();

    _dateOfBirthController.dispose();

    _providerNameController.dispose();

    _providerRelationshipController.dispose();

    super.dispose();
  }

  Future<bool> _hasPermission(String key) {
    return _authorization.hasPermission(
      organizationId: widget.organizationId,

      permissionKey: key,
    );
  }

  Future<void> _loadPerson() async {
    try {
      _canEditPerson = await _hasPermission('people.edit');

      if (!_canEditPerson) {
        _errorMessage =
            'You do not have permission to edit people in this organization.';

        return;
      }

      final person = await _repository.getPerson(
        organizationId: widget.organizationId,

        personId: widget.personId,
      );

      if (person == null) {
        _errorMessage = 'This person could not be found.';

        return;
      }

      _firstNameController.text = person['first_name']?.toString() ?? '';

      _lastNameController.text = person['last_name']?.toString() ?? '';

      _preferredNameController.text =
          person['preferred_name']?.toString() ?? '';

      _emailController.text = person['email']?.toString() ?? '';

      _phoneController.text = person['phone']?.toString() ?? '';

      _notesController.text = person['notes']?.toString() ?? '';

      _personType = person['person_type']?.toString() ?? '';

      _engagementType = person['employment_type']?.toString() ?? '';

      _status = person['status']?.toString() ?? 'active';

      final permissions = await Future.wait([
        _hasPermission('people.personal_details.view'),

        _hasPermission('people.personal_details.manage'),

        _hasPermission('functionalrole.view'),

        _hasPermission('functionalrole.manage'),

        _hasPermission('credentials.view'),

        _hasPermission('credentials.manage'),

        _hasPermission('credentials.background_checks.view'),

        _hasPermission('credentials.background_checks.manage'),
        _hasPermission('groups.view'),
      ]);

      _canManagePrivateDetails = permissions[1];

      _canViewPrivateDetails = permissions[0] || permissions[1];

      _canViewFunctionalRoles = permissions[2];

      _canManageFunctionalRoles = permissions[3];

      _canViewCredentials = permissions[4];

      _canManageCredentials = permissions[5];

      _canViewBackgroundChecks = permissions[6];

      _canManageBackgroundChecks = permissions[7];

      _canViewGroups = permissions[8];

      if (_canViewPrivateDetails) {
        try {
          final details = await _privateDetailsService.getPersonPrivateDetails(
            organizationId: widget.organizationId,

            personId: widget.personId,
          );

          if (details != null) {
            final rawDate = details['date_of_birth']?.toString();

            if (rawDate != null && rawDate.isNotEmpty) {
              final date = DateTime.tryParse(rawDate);

              if (date != null) {
                _dateOfBirthController.text = DateFormat(
                  'MM/dd/yyyy',
                ).format(date);
              }
            }

            _informationProviderType =
                details['information_provider_type']?.toString() ??
                'organization_staff';

            _providerNameController.text =
                details['provider_name']?.toString() ?? '';

            _providerRelationshipController.text =
                details['provider_relationship']?.toString() ?? '';
          }
        } catch (_) {
          _privateDetailsLoadFailed = true;
        }
      }

      if (_canViewGroups ||
          _canViewFunctionalRoles ||
          _canManageFunctionalRoles) {
        try {
          await _loadFunctionalRoleData();
        } catch (error) {
          debugPrint('Functional roles could not be loaded: $error');
        }
      }
    } catch (error) {
      _errorMessage = 'Unable to load this person. Please try again.';

      debugPrint('EditPersonPage load failed: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadFunctionalRoleData() async {
    final roles = await _functionalRoleService.getRoles(
      organizationId: widget.organizationId,

      activeOnly: false,
    );

    final assignments = await _functionalRoleService.getAssignments(
      organizationId: widget.organizationId,

      personId: widget.personId,

      activeOnly: true,
    );

    _functionalRoles = roles;

    _roleAssignments = assignments;
  }

  List<String> get _personTypeOptions {
    final values = [..._personTypeChoices];

    // Preserve an existing type if it is no longer in the standard choices.

    if (_personType.isNotEmpty && !values.contains(_personType)) {
      values.add(_personType);
    }

    return values;
  }

  Map<String, FunctionalRole> get _rolesById => {
    for (final role in _functionalRoles) role.id: role,
  };

  List<String> get _assignedRoleNames {
    final roles = _rolesById;

    return _roleAssignments
        .where((assignment) => assignment.isActive)
        .map(
          (assignment) =>
              roles[assignment.functionalRoleId]?.name ?? 'Unavailable role',
        )
        .toList();
  }

  List<EditPersonSection> get _sections {
    return [
      const EditPersonSection(
        id: 'basic',

        title: 'Basic Information',

        icon: Icons.person_outline,
      ),

      if (_canViewPrivateDetails)
        const EditPersonSection(
          id: 'private',

          title: 'Private Details',

          icon: Icons.shield_outlined,
        ),

      if (_canViewFunctionalRoles || _canManageFunctionalRoles)
        const EditPersonSection(
          id: 'assignments',

          title: 'Assignments',

          icon: Icons.assignment_ind_outlined,
        ),

      if (_canViewCredentials ||
          _canManageCredentials ||
          _canViewBackgroundChecks ||
          _canManageBackgroundChecks)
        const EditPersonSection(
          id: 'credentials',

          title: 'Credentials',

          icon: Icons.workspace_premium_outlined,
        ),
    ];
  }

  void _selectSection(String sectionId) {
    setState(() {
      _selectedSection = sectionId;
    });
  }

  DateTime? _parseDateOfBirth() {
    final text = _dateOfBirthController.text.trim();

    if (text.isEmpty) {
      return null;
    }

    return DateFormat('MM/dd/yyyy').parseStrict(text);
  }

  Future<void> _selectDateOfBirth() async {
    final today = DateTime.now();

    DateTime initialDate;

    try {
      initialDate = _parseDateOfBirth() ?? DateTime(2000, 1, 1);
    } catch (_) {
      initialDate = DateTime(2000, 1, 1);
    }

    if (initialDate.isAfter(today)) {
      initialDate = today;
    }

    final selectedDate = await showDatePicker(
      context: context,

      initialDate: initialDate,

      firstDate: DateTime(1900),

      lastDate: DateTime(today.year, today.month, today.day),

      helpText: 'Select date of birth',
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    setState(() {
      _dateOfBirthController.text = DateFormat(
        'MM/dd/yyyy',
      ).format(selectedDate);
    });
  }

  String? _nullableText(String value) {
    final text = value.trim();

    return text.isEmpty ? null : text;
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _save() async {
    if (_isSaving) return;

    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty) {
      _showMessage('First Name and Last Name are required.');

      _selectSection('basic');

      return;
    }

    DateTime? dateOfBirth;

    if (_canManagePrivateDetails && !_privateDetailsLoadFailed) {
      try {
        dateOfBirth = _parseDateOfBirth();
      } on FormatException {
        _showMessage('Please enter a valid date of birth.');

        _selectSection('private');

        return;
      }
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _repository.updatePerson(
        organizationId: widget.organizationId,

        personId: widget.personId,

        firstName: _firstNameController.text.trim(),

        lastName: _lastNameController.text.trim(),

        preferredName: _nullableText(_preferredNameController.text),

        email: _nullableText(_emailController.text),

        phone: _nullableText(_phoneController.text),

        employmentType: _nullableText(_engagementType),

        personType: _nullableText(_personType),

        notes: _nullableText(_notesController.text),

        status: _status,
      );

      if (_canManagePrivateDetails && !_privateDetailsLoadFailed) {
        try {
          await _privateDetailsService.savePrivateDetails(
            organizationId: widget.organizationId,

            personId: widget.personId,

            dateOfBirth: dateOfBirth,

            informationProviderType: _informationProviderType,

            providerName: _providerNameController.text,

            providerRelationship: _providerRelationshipController.text,
          );
        } catch (error) {
          debugPrint('Protected details save failed: $error');

          _showMessage(
            'Person information was saved, but private details could not '
            'be saved. Please check your access and try again.',
          );

          return;
        }
      }

      _showMessage('Changes saved successfully.');
    } catch (error) {
      debugPrint('EditPersonPage save failed: $error');

      _showMessage('Unable to save changes. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildSelectedSection() {
    switch (_selectedSection) {
      case 'private':
        if (_privateDetailsLoadFailed) {
          return const Text(
            'Private details could not be loaded. They have not been '
            'changed. Please try again before editing them.',
          );
        }

        return EditPersonPrivateDetails(
          dateOfBirthController: _dateOfBirthController,

          informationProviderNameController: _providerNameController,

          informationProviderRelationshipController:
              _providerRelationshipController,

          informationProviderType: _informationProviderType,

          canManage: _canManagePrivateDetails,

          onSelectDate: _selectDateOfBirth,

          onInformationProviderTypeChanged: (value) {
            setState(() {
              _informationProviderType = value ?? 'organization_staff';
            });
          },
        );

      case 'credentials':
        return EditPersonCredentials(
          organizationId: widget.organizationId,

          personId: widget.personId,
        );

      case 'assignments':
        return EditPersonOrganizationalAssignments(
          organizationId: widget.organizationId,
          personId: widget.personId,
          canViewGroups: _canViewGroups,
          functionalRolesAvailable:
              _canViewFunctionalRoles || _canManageFunctionalRoles,
          canManageFunctionalRoles: _canManageFunctionalRoles,
          canViewFunctionalRoles: _canViewFunctionalRoles,
        );

      case 'basic':
      default:
        return EditPersonBasicInformation(
          firstNameController: _firstNameController,

          lastNameController: _lastNameController,

          preferredNameController: _preferredNameController,

          emailController: _emailController,

          phoneController: _phoneController,

          notesController: _notesController,

          engagementType: _engagementType,

          personType: _personType,

          status: _status,

          personTypeOptions: _personTypeOptions,

          statusOptions: _statusChoices,

          onEngagementTypeChanged: (value) {
            setState(() {
              _engagementType = value ?? '';
            });
          },

          onPersonTypeChanged: (value) {
            setState(() {
              _personType = value ?? '';
            });
          },

          onStatusChanged: (value) {
            setState(() {
              _status = value ?? 'active';
            });
          },

          roleNames: _canViewFunctionalRoles || _canManageFunctionalRoles
              ? _assignedRoleNames
              : const [],

          canManageRoles: _canManageFunctionalRoles,

          onManageRoles: () => _selectSection('assignments'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      appBar: AppBar(
        title: EditPersonAppBarTitle(
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          preferredNameController: _preferredNameController,
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          FilledButton.icon(
            onPressed: _isLoading || _isSaving || _errorMessage != null
                ? null
                : _save,
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save_outlined, size: 18),
            label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF5B4BC4),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    const Icon(
                      Icons.info_outline,

                      size: 36,

                      color: Color(0xFF7B8494),
                    ),

                    const SizedBox(height: 12),

                    Text(_errorMessage!, textAlign: TextAlign.center),

                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),

                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),

                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 900;

                    final navigation = EditPersonSectionNavigation(
                      sections: _sections,

                      selectedSectionId: _selectedSection,

                      onSectionSelected: _selectSection,

                      compact: compact,
                    );

                    final sectionContent = _buildSelectedSection();

                    if (compact) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,

                        children: [
                          navigation,

                          const SizedBox(height: 24),

                          sectionContent,
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        SizedBox(width: 210, child: navigation),

                        const SizedBox(width: 24),

                        Expanded(child: sectionContent),
                      ],
                    );
                  },
                ),
              ),
            ),
    );
  }
}
