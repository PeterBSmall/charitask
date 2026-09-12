import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/pages/identity/complete_personal_profile_page.dart';
import 'package:charitask/modules/foundation/pages/onboarding/personal_workspace/steps/personal_details_step.dart';
import 'package:charitask/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:charitask/modules/workspaces/templates/pages/workspace_template_selection_page.dart';
import 'package:charitask/shared/workspaces/models/ct_workspace.dart';
import 'package:charitask/shared/workspaces/services/ct_workspace_service.dart';
import 'package:charitask/modules/workspaces/templates/data/workspace_template_data.dart';
import 'package:charitask/modules/workspaces/personal/personal_workspace_shell.dart';

class PersonalWorkspaceSetupPage extends StatefulWidget {
  final OnboardingController onboardingController;

  const PersonalWorkspaceSetupPage({
    super.key,
    required this.onboardingController,
  });

  @override
  State<PersonalWorkspaceSetupPage> createState() =>
      _PersonalWorkspaceSetupPageState();
}

class _PersonalWorkspaceSetupPageState
    extends State<PersonalWorkspaceSetupPage> {
  int _currentStep = 1;
  String? _selectedTemplate;

  OnboardingController get onboardingController => widget.onboardingController;

  @override
  Widget build(BuildContext context) {
    final person = onboardingController.person;

    if (person == null) {
      return const Scaffold(
        body: Center(child: Text('Personal information is not available.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: SafeArea(
        child: _currentStep == 1
            ? PersonalDetailsStep(
                firstName: person.firstName,
                lastName: person.lastName,
                email: person.email ?? '',
                phone: person.phone,
                organizationalRole:
                    onboardingController.organizationRole?.name ?? '',
                onEditDetails: _editDetails,
                onConfirm: _continueToTemplateSelection,
                onUseForFutureWorkspaces: (_) {},
              )
            : _buildTemplateSelectionLayout(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 2 — WORKSPACE TEMPLATE SELECTION
  // ---------------------------------------------------------------------------

  Widget _buildTemplateSelectionLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 1000;

        if (isCompact) {
          return WorkspaceTemplateSelectionPage(
            onBack: _backToPersonalDetails,
            onContinue: _handleTemplateContinue,
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: 360, child: _buildTemplateSidebar()),
            Expanded(
              child: WorkspaceTemplateSelectionPage(
                onBack: _backToPersonalDetails,
                onContinue: _handleTemplateContinue,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTemplateSidebar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(40, 32, 40, 32),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------------------------------------------------------
              // BRAND
              // -------------------------------------------------------------------
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C4DFF),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(
                      Icons.volunteer_activism,
                      color: Colors.white,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'ChariTask',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF182230),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // -------------------------------------------------------------------
              // PROGRESS
              // -------------------------------------------------------------------
              _buildTemplateProgress(),

              const SizedBox(height: 20),

              // -------------------------------------------------------------------
              // ILLUSTRATION
              // -------------------------------------------------------------------
              _buildTemplateIllustration(),

              const SizedBox(height: 18),

              // -------------------------------------------------------------------
              // EXPLANATION
              // -------------------------------------------------------------------
              const Text(
                'Choose a workspace template',
                style: TextStyle(
                  fontSize: 25,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF182230),
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                'Start with a workspace designed around the kind of work you do. '
                'You can customize it after setup.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.55,
                  color: Color(0xFF667085),
                ),
              ),

              const SizedBox(height: 24),

              // -------------------------------------------------------------------
              // BACK
              // -------------------------------------------------------------------
              TextButton.icon(
                onPressed: _backToPersonalDetails,
                icon: const Icon(Icons.arrow_back, size: 17),
                label: const Text(
                  'Back to Personal Details',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF475467),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateProgress() {
    return Row(
      children: [
        _buildProgressCircle(
          number: '1',
          label: 'Personal Details',
          isComplete: true,
          isActive: false,
        ),
        Expanded(
          child: Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            color: const Color(0xFF7C4DFF),
          ),
        ),
        _buildProgressCircle(
          number: '2',
          label: 'Workspace',
          isComplete: false,
          isActive: true,
        ),
      ],
    );
  }

  Widget _buildProgressCircle({
    required String number,
    required String label,
    required bool isComplete,
    required bool isActive,
  }) {
    final backgroundColor = isComplete || isActive
        ? const Color(0xFF7C4DFF)
        : const Color(0xFFE2E8F0);

    final textColor = isComplete || isActive
        ? Colors.white
        : const Color(0xFF64748B);

    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isComplete
                ? const Icon(Icons.check, size: 17, color: Colors.white)
                : Text(
                    number,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? const Color(0xFF182230) : const Color(0xFF98A2B3),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateIllustration() {
    return Center(
      child: Container(
        width: 180,
        height: 140,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F3FF),
          borderRadius: BorderRadius.circular(28),
        ),
        child: const Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 38,
              top: 30,
              child: Icon(
                Icons.dashboard_customize_outlined,
                size: 76,
                color: Color(0xFF7C4DFF),
              ),
            ),
            Positioned(
              right: 34,
              bottom: 27,
              child: Icon(
                Icons.auto_awesome,
                size: 31,
                color: Color(0xFF9B7BFF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTemplateContinue(String templateId) {
    debugPrint('>>> PERSONAL WORKSPACE TEMPLATE SELECTED: $templateId');

    final allTemplates = [
      ...missionCommunityTemplates,
      ...fundraisingProgramsTemplates,
      ...peopleResourcesComplianceTemplates,
      ...creativeFlexibleTemplates,
    ];

    final template = allTemplates.firstWhere((item) => item.id == templateId);

    final workspace = CTWorkspaceService.createWorkspace(
      id: 'personal_${template.id}',
      name: template.title,
      type: CTWorkspaceType.personal,
      icon: template.icon,
      color: template.accentColor,
    );

    debugPrint('>>> CREATED PERSONAL WORKSPACE: ${workspace.name}');

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PersonalWorkspaceShell(
          workspace: workspace,
          firstName: onboardingController.person?.firstName ?? '',
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 1
  // ---------------------------------------------------------------------------

  void _editDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CompletePersonalProfilePage(
          firstName: onboardingController.person?.firstName ?? '',
          lastName: onboardingController.person?.lastName ?? '',
          email: onboardingController.person?.email ?? '',
          phone: onboardingController.person?.phone,
          organizationalRole: onboardingController.organizationRole?.name ?? '',
          onSkip: () {
            Navigator.of(context).pop();
          },
          onComplete:
              ({String? preferredName, String? pronouns, String? phone}) async {
                onboardingController.updatePerson(
                  preferredName: preferredName,
                  pronouns: pronouns,
                  phone: phone,
                );

                Navigator.of(context).pop();
              },
        ),
      ),
    );
  }

  void _continueToTemplateSelection() {
    setState(() {
      _currentStep = 2;
    });
  }

  void _backToPersonalDetails() {
    setState(() {
      _currentStep = 1;
    });
  }
}
