import 'package:flutter/material.dart';

import 'package:charitask/modules/people/widgets/add_person/access_step.dart';
import 'package:charitask/modules/people/widgets/add_person/add_person_header.dart';
import 'package:charitask/modules/people/widgets/add_person/add_person_stepper.dart';
import 'package:charitask/modules/people/widgets/add_person/add_person_validation.dart';
import 'package:charitask/modules/people/widgets/add_person/assignments_step.dart';
import 'package:charitask/modules/people/widgets/add_person/basic_information_step.dart';
import 'package:charitask/modules/people/widgets/add_person/connection_step.dart';
import 'package:charitask/modules/people/widgets/add_person/membership_step.dart';
import 'package:charitask/modules/people/widgets/add_person/review_create_step.dart';
import 'package:charitask/modules/people/widgets/add_person/add_person_navigation.dart';

import 'package:charitask/shared/widgets/workspace_canvas.dart';
import 'package:charitask/shared/custom_types/custom_type.dart';

class AddPersonPage extends StatefulWidget {
  const AddPersonPage({super.key});

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
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
  final List<CustomType> _customDonorTypes = [];

  String _membershipStatus = 'Active';
  String _roleCategory = '';
  String? _donorType;
  String? _preferredContactMethod;

  static const List<String> _steps = [
    'Connection',
    'Basic Information',
    'Primary Relationship',
    'Assignments',
    'Access',
    'Review & Create',
  ];

  @override
  void initState() {
    super.initState();

    _firstNameController.addListener(_onFormChanged);
    _lastNameController.addListener(_onFormChanged);
    _preferredNameController.addListener(_onFormChanged);
    _emailController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    setState(() {});
  }

  bool get _isCurrentStepValid {
    switch (_currentStep) {
      case 0:
        return _connectionType != null;

      case 1:
        return AddPersonValidation.isBasicInformationValid(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
        );

      case 2:
        // A primary relationship must be selected.
        if (_roleCategory.isEmpty) {
          return false;
        }

        // If Donor is selected, a donor type is also required.
        if (_roleCategory == 'Donor' && _donorType == null) {
          return false;
        }

        return true;

      default:
        return true;
    }
  }

  bool _validateCurrentStep() {
    String? errorMessage;

    switch (_currentStep) {
      case 0:
        errorMessage = AddPersonValidation.validateConnectionType(
          _connectionType,
        );
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
        return ConnectionStep(
          selectedType: _connectionType,
          onSelected: (value) {
            setState(() {
              _connectionType = value;
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
        return MembershipStep(
          connectionType: _connectionType ?? 'internal',
          membershipStatus: _membershipStatus,
          roleCategory: _roleCategory,
          donorType: _donorType,
          joinDateController: _joinDateController,

          onMembershipStatusChanged: (value) {
            setState(() {
              _membershipStatus = value;
            });
          },

          onRoleCategoryChanged: (value) {
            setState(() {
              _roleCategory = value;
            });
          },

          onDonorTypeChanged: (value) {
            setState(() {
              _donorType = value;
            });
          },

          customTypes: _customDonorTypes,

          onCustomTypeAdded: (customType) {
            setState(() {
              _customDonorTypes.add(customType);
              _donorType = customType.id;
            });
          },
        );

      case 3:
        return const AssignmentsStep();

      case 4:
        return AccessStep(
          hasSystemAccess: _hasSystemAccess,
          onAccessChanged: (value) {
            setState(() {
              _hasSystemAccess = value;
            });
          },
        );

      case 5:
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
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _preferredNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    _dateOfBirthController.dispose();
    _joinDateController.dispose();
    _notesController.dispose();

    super.dispose();
  }
}
