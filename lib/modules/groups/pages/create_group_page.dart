import 'package:flutter/material.dart';

import 'package:charitask/modules/groups/domain/models/create_group_draft.dart';
import 'package:charitask/modules/groups/widgets/create_group/create_group_footer.dart';
import 'package:charitask/modules/groups/widgets/create_group/create_group_header.dart';
import 'package:charitask/modules/groups/widgets/create_group/create_group_sidebar.dart';
import 'package:charitask/modules/groups/widgets/create_group/create_group_stepper.dart';
import 'package:charitask/modules/groups/widgets/create_group/steps/group_definition_step.dart';
import 'package:charitask/modules/groups/widgets/create_group/steps/group_membership_step.dart';
import 'package:charitask/modules/groups/data/services/group_service.dart';

class CreateGroupPage extends StatefulWidget {
  final String organizationId;

  const CreateGroupPage({super.key, required this.organizationId});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final CreateGroupDraft _draft = CreateGroupDraft();

  final GroupService _groupService = GroupService();

  bool _saving = false;

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

  Future<void> _nextStep() async {
    if (!_canContinue || _saving) return;

    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      return;
    }

    await _createGroup();
  }

  Future<void> _createGroup() async {
    if (!_draft.isDefinitionComplete) return;

    final groupType = _draft.groupType;
    final ownerType = _draft.ownerType;
    final ownerId = _draft.ownerId;

    if (groupType == null || ownerType == null || ownerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please complete the group definition before creating the group.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final slug = _buildSlug(_draft.name);

      await _groupService.createGroup(
        organizationId: widget.organizationId,
        name: _draft.name.trim(),
        slug: slug,
        groupType: groupType,
        visibility: _draft.visibility,
        ownerType: ownerType,
        ownerId: ownerId,
        membershipComposition: const [],
        description: _draft.description.trim().isEmpty
            ? null
            : _draft.description.trim(),
        locationId: _draft.locationIds.isEmpty
            ? null
            : _draft.locationIds.first,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Group created successfully.')),
      );

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to create group: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  String _buildSlug(String value) {
    final slug = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');

    return slug.isEmpty ? 'group' : slug;
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
