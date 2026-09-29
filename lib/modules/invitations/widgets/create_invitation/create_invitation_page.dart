import 'package:flutter/material.dart';

import 'package:charitask/modules/people/domain/models/people_access_person.dart';
import 'package:charitask/modules/people/pages/add_person_page.dart';

import '../../domain/models/create_invitation_draft.dart';
import '../../domain/models/invitation_delivery_method.dart';
import '../../domain/models/invitation_recipient_type.dart';
import '../../domain/models/invitation_type.dart';
import 'configure_invitation_step.dart';

class CreateInvitationPage extends StatefulWidget {
  const CreateInvitationPage({super.key, required this.organizationId});

  final String organizationId;

  @override
  State<CreateInvitationPage> createState() => _CreateInvitationPageState();
}

class _CreateInvitationPageState extends State<CreateInvitationPage> {
  final CreateInvitationDraft _draft = CreateInvitationDraft();

  final List<PeopleAccessPerson> _selectedPeople = [];

  int _currentStep = 0;

  static const _steps = [
    'Configure Invitation',
    'Select a Template',
    'Customize Message',
    'Permissions',
    'Review & Send',
  ];

  bool get _canContinue {
    switch (_currentStep) {
      case 0:
        return _draft.isComplete;
      default:
        return true;
    }
  }

  void _setInvitationType(InvitationType type) {
    setState(() {
      _draft.invitationType = type;
      _draft.targetId = null;
    });
  }

  void _setRecipientType(InvitationRecipientType type) {
    setState(() {
      _draft.recipientType = type;
      _selectedPeople.clear();
      _draft.recipientIds.clear();
    });
  }

  void _setDeliveryMethod(InvitationDeliveryMethod method) {
    setState(() {
      _draft.deliveryMethod = method;
    });
  }

  void _setExistingPeople(List<PeopleAccessPerson> people) {
    setState(() {
      _selectedPeople
        ..clear()
        ..addAll(people);

      _draft.recipientIds
        ..clear()
        ..addAll(people.map((person) => person.id));
    });
  }

  Future<void> _addNewPerson() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddPersonPage(organizationId: widget.organizationId),
      ),
    );

    if (!mounted || result != true) {
      return;
    }

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Person created. Search for them above to select them.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _continue() {
    if (!_canContinue) {
      return;
    }

    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      return;
    }

    Navigator.of(context).maybePop();
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return ConfigureInvitationStep(
          organizationId: widget.organizationId,
          draft: _draft,
          onInvitationTypeChanged: _setInvitationType,
          onRecipientTypeChanged: _setRecipientType,
          onExistingPeopleChanged: _setExistingPeople,
          onAddNewPerson: _addNewPerson,
          onDeliveryMethodChanged: _setDeliveryMethod,
        );

      case 1:
        return const _ComingSoonStep(
          title: 'Select a Template',
          message: 'Invitation templates will be configured here.',
        );

      case 2:
        return const _ComingSoonStep(
          title: 'Customize Message',
          message: 'Invitation message customization will be configured here.',
        );

      case 3:
        return const _ComingSoonStep(
          title: 'Permissions',
          message:
              'Invitation permissions and assignments will be configured here.',
        );

      case 4:
        return const _ComingSoonStep(
          title: 'Review & Send',
          message:
              'The final invitation review and send options will appear here.',
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _InvitationStepper(currentStep: _currentStep, steps: _steps),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1280),
                    child: _buildStepContent(),
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            _buildNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.mail_outline, color: Color(0xFF7C3AED)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Invitation',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Invite people and configure their access.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Close',
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      color: Colors.white,
      child: Row(
        children: [
          OutlinedButton(
            onPressed: _back,
            child: Text(_currentStep == 0 ? 'Cancel' : 'Back'),
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: _canContinue ? _continue : null,
            icon: Icon(
              _currentStep == _steps.length - 1
                  ? Icons.send_outlined
                  : Icons.arrow_forward,
            ),
            label: Text(
              _currentStep == _steps.length - 1 ? 'Review & Send' : 'Continue',
            ),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _InvitationStepper extends StatelessWidget {
  const _InvitationStepper({required this.currentStep, required this.steps});

  final int currentStep;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 700;

          if (compact) {
            return Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7C3AED),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${currentStep + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    steps[currentStep],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                Text(
                  '${currentStep + 1} of ${steps.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            );
          }

          return Row(
            children: List.generate(steps.length, (index) {
              final isCurrent = index == currentStep;
              final isComplete = index < currentStep;

              return Expanded(
                child: Row(
                  children: [
                    if (index > 0)
                      Expanded(
                        child: Container(
                          height: 1,
                          color: index <= currentStep
                              ? const Color(0xFF7C3AED)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isCurrent || isComplete
                            ? const Color(0xFF7C3AED)
                            : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: isComplete
                          ? const Icon(
                              Icons.check,
                              size: 17,
                              color: Colors.white,
                            )
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isCurrent
                                    ? Colors.white
                                    : const Color(0xFF64748B),
                              ),
                            ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        steps[index],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isCurrent
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isCurrent
                              ? const Color(0xFF1E293B)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class _ComingSoonStep extends StatelessWidget {
  const _ComingSoonStep({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.construction_outlined,
            size: 40,
            color: Color(0xFF7C3AED),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}
