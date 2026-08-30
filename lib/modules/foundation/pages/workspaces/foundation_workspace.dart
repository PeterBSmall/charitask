import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/pages/workspaces/foundation_workspace_page.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/widgets/ct_workspace_welcome_dialog.dart';

class FoundationWorkspace extends StatefulWidget {
  final CTJourneyController journeyController;

  const FoundationWorkspace({super.key, required this.journeyController});

  @override
  State<FoundationWorkspace> createState() => _FoundationWorkspaceState();
}

class _FoundationWorkspaceState extends State<FoundationWorkspace> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcome();
    });
  }

  Future<void> _showWelcome() async {
    if (!mounted) return;

    await CTWorkspaceWelcomeDialog.show(
      context: context,

      title: "Welcome to your organization's workspace!",
      subtitle: "Let's build something great together.",

      preferenceKey: 'organization_workspace_welcome_seen',

      features: const [
        CTWorkspaceWelcomeFeature(
          icon: Icons.business_outlined,
          title: 'Build your organization',
          description:
              'Manage your organization, locations, people, and groups.',
        ),
        CTWorkspaceWelcomeFeature(
          icon: Icons.dashboard_customize_outlined,
          title: 'Stay organized',
          description:
              'Keep important information, tasks, and activity together.',
        ),
        CTWorkspaceWelcomeFeature(
          icon: Icons.shield_outlined,
          title: 'Manage access',
          description:
              'Control roles, permissions, and access to your workspace.',
        ),
      ],

      primaryActionLabel: "Let's get started",

      onPrimaryAction: () {
        // The welcome dialog closes first.
        // The user remains in the Organization Workspace.
      },

      secondaryActionLabel: 'Learn more',

      onSecondaryAction: () {
        // We will connect the Learn More experience next.
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FoundationWorkspacePage(journeyController: widget.journeyController);
  }
}
