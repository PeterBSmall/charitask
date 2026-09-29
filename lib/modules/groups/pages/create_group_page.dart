import 'package:flutter/material.dart';

import 'package:charitask/modules/groups/domain/models/create_group_draft.dart';
import 'package:charitask/modules/groups/widgets/create_group/create_group_footer.dart';
import 'package:charitask/modules/groups/widgets/create_group/create_group_header.dart';
import 'package:charitask/modules/groups/widgets/create_group/create_group_sidebar.dart';
import 'package:charitask/modules/groups/widgets/create_group/create_group_stepper.dart';
import 'package:charitask/modules/groups/widgets/create_group/steps/group_definition_step.dart';
import 'package:charitask/modules/groups/widgets/create_group/steps/group_membership_step.dart';

class CreateGroupPage extends StatefulWidget {
  final String organizationId;

  const CreateGroupPage({super.key, required this.organizationId});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final CreateGroupDraft _draft = CreateGroupDraft();

  int _currentStep = 0;

  static const _steps = [
    'Definition',
    'Membership',
    'Associations',
    'Permissions',
    'Review',
  ];

  bool get _canContinue {
    if (_currentStep == 0) {
      return _draft.isDefinitionComplete;
    }

    return true;
  }

  void _nextStep() {
    if (!_canContinue) return;

    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep == 0) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _currentStep--;
    });
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return GroupDefinitionStep(
          draft: _draft,
          organizationId: widget.organizationId,
          onChanged: () {
            setState(() {});
          },
        );

      case 1:
        return GroupMembershipStep(
          draft: _draft,
          organizationId: widget.organizationId,
        );

      default:
        return _buildComingSoonStep(_steps[_currentStep]);
    }
  }

  Widget _buildComingSoonStep(String title) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.construction_outlined,
              size: 44,
              color: Color(0xFF06B6D4),
            ),
            const SizedBox(height: 16),
            Text(
              '$title step',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'This step will be connected next.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: Column(
          children: [
            const CreateGroupHeader(),
            CreateGroupStepper(currentStep: _currentStep, steps: _steps),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 900;

                  if (compact) {
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: _buildStep(),
                          ),
                        ),
                        CreateGroupFooter(
                          currentStep: _currentStep,
                          totalSteps: _steps.length,
                          canContinue: _canContinue,
                          onBack: _previousStep,
                          onContinue: _nextStep,
                        ),
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CreateGroupSidebar(currentStep: _currentStep),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
                          child: _buildStep(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MediaQuery.sizeOf(context).width >= 900
          ? CreateGroupFooter(
              currentStep: _currentStep,
              totalSteps: _steps.length,
              canContinue: _canContinue,
              onBack: _previousStep,
              onContinue: _nextStep,
            )
          : null,
    );
  }
}
