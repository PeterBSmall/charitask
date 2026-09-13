import 'package:flutter/material.dart';

import 'package:charitask/modules/people/widgets/add_person/access_step.dart';
import 'package:charitask/modules/people/widgets/add_person/steps/organizational_role_step.dart';
import 'package:charitask/modules/people/widgets/add_person/add_person_header.dart';
import 'package:charitask/modules/people/widgets/add_person/add_person_stepper.dart';
import 'package:charitask/modules/people/widgets/add_person/add_person_validation.dart';
import 'package:charitask/modules/people/widgets/add_person/assignments_step.dart';
import 'package:charitask/modules/people/widgets/add_person/basic_information_step.dart';

import 'package:charitask/modules/people/widgets/add_person/review_create_step.dart';
import 'package:charitask/modules/people/widgets/add_person/add_person_navigation.dart';

import 'package:charitask/shared/widgets/workspace_canvas.dart';

import 'package:charitask/modules/people/data/repositories/people_repository_impl.dart';
import 'package:charitask/modules/people/data/services/people_service.dart';
import 'package:charitask/modules/people/domain/repositories/people_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPersonPage extends StatefulWidget {
  final String organizationId;

  const AddPersonPage({super.key, required this.organizationId});

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  late final PeopleRepository _repository;

  int _currentStep = 0;

  bool _hasSystemAccess = false;
  String? _connectionType;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _preferredNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _dateOfBirthController = TextEditingController();
  final _joinDateController = TextEditingController();
  final _notesController = TextEditingController();

  String _membershipStatus = 'Active';
  String _organizationalRole = '';
  String _primaryDepartment = '';
  final _jobTitleController = TextEditingController();
  String? _preferredContactMethod;

  static const List<String> _steps = [
    'Organizational Role',
    'Personal Details',
    'Assignments',
    'Access',
    'Review & Create',
  ];

  @override
  void initState() {
    super.initState();

    _repository = PeopleRepositoryImpl(PeopleService(Supabase.instance.client));

    _firstNameController.addListener(_onFormChanged);
    _lastNameController.addListener(_onFormChanged);
    _preferredNameController.addListener(_onFormChanged);
    _emailController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
  }

  static const List<String> _organizationalRoleOptions = [
    'Founder / Owner',
    'Executive Leadership',
    'Director',
    'Manager',
    'Team Lead',
    'Staff Member',
    'Volunteer',
    'Board Member',
  ];

  final List<String> _departmentOptions = [
    'Administration',
    'Finance',
    'Fundraising',
    'Human Resources',
    'Information Technology',
    'Marketing & Communications',
    'Operations',
    'Other',
    'Programs',
    'ReStore / Retail',
    'Volunteer Services',
  ];

  void _onFormChanged() {
    setState(() {});
  }

  bool get _isCurrentStepValid {
    switch (_currentStep) {
      case 0:
        return _organizationalRole.isNotEmpty;

      case 1:
        return AddPersonValidation.isBasicInformationValid(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
        );

      case 2:
        return true;

      default:
        return true;
    }
  }

  bool _validateCurrentStep() {
    String? errorMessage;

    switch (_currentStep) {
      case 0:
        if (_organizationalRole.isEmpty) {
          errorMessage = 'Please select an organizational role.';
        }
        break;

      case 1:
        errorMessage = AddPersonValidation.validateBasicInformation(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
        );
        break;
    }

    if (errorMessage != null) {
      _showValidationMessage(errorMessage);
      return false;
    }

    return true;
  }

  void _showValidationMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _nextStep() {
    if (!_validateCurrentStep()) return;

    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3D2466),
      body: SafeArea(
        child: WorkspaceCanvas(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFC),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                AddPersonHeader(
                  onCancel: () {
                    Navigator.of(context).maybePop();
                  },
                  onSaveDraft: () {
                    // Save draft functionality will be added later.
                  },
                ),

                const Divider(height: 1),

                AddPersonStepper(currentStep: _currentStep, steps: _steps),

                Expanded(child: _buildStepContent()),

                const Divider(height: 1),

                _buildNavigation(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return OrganizationalRoleStep(
          organizationalRole: _organizationalRole,
          primaryDepartment: _primaryDepartment,
          jobTitleController: _jobTitleController,
          organizationalRoleOptions: _organizationalRoleOptions,
          departmentOptions: _departmentOptions,
          onOrganizationalRoleChanged: (value) {
            setState(() {
              _organizationalRole = value;
            });
          },
          onPrimaryDepartmentChanged: (value) {
            setState(() {
              _primaryDepartment = value;
            });
          },
        );

      case 1:
        return BasicInformationStep(
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          preferredNameController: _preferredNameController,
          emailController: _emailController,
          phoneController: _phoneController,
          dateOfBirthController: _dateOfBirthController,
          notesController: _notesController,
          connectionType: _connectionType ?? '',
          preferredContactMethod: _preferredContactMethod,
          onPreferredContactMethodChanged: (value) {
            setState(() {
              _preferredContactMethod = value;
            });
          },
        );

      case 2:
        return const AssignmentsStep();

      case 3:
        return AccessStep(
          hasSystemAccess: _hasSystemAccess,
          onAccessChanged: (value) {
            setState(() {
              _hasSystemAccess = value;
            });
          },
        );

      case 4:
        return ReviewCreateStep(
          connectionType: _connectionType ?? '',
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          preferredName: _preferredNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          hasSystemAccess: _hasSystemAccess,
        );

      default:
        return const SizedBox();
    }
  }

  Widget _buildNavigation() {
    return AddPersonNavigation(
      currentStep: _currentStep,
      totalSteps: _steps.length,
      isCurrentStepValid: _isCurrentStepValid,
      onBack: _previousStep,
      onNext: _nextStep,
      onCreate: _createPerson,
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _preferredNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _jobTitleController.dispose();

    _dateOfBirthController.dispose();
    _joinDateController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  Future<void> _createPerson() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final preferredName = _preferredNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    try {
      final person = await _repository.createPerson(
        organizationId: widget.organizationId,
        firstName: firstName,
        lastName: lastName,
        preferredName: preferredName.isEmpty ? null : preferredName,
        email: email.isEmpty ? null : email,
        phone: phone.isEmpty ? null : phone,
        employmentType: null,
      );

      final personId = person['id'] as String?;

      if (personId == null || personId.isEmpty) {
        throw Exception('Person was created without an ID.');
      }

      final membershipStatus = _membershipStatus.toLowerCase() == 'inactive'
          ? 'inactive'
          : 'active';

      await _repository.createOrganizationMembership(
        organizationId: widget.organizationId,
        personId: personId,
        status: membershipStatus,
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to create person: $error'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
