import 'package:charitask/domain/organization/organization_type.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';

class CTMissionProfile {
  /// Organization type this profile represents.
  final OrganizationType type;

  /// Hero shown throughout the Journey.
  final CTJourneyHeroData hero;

  /// CTA shown on the organization selection screen.
  final String actionButton;

  /// Highlights shown on the hero.
  final List<String> highlights;

  /// Workspace creation screen.
  final String workspaceTitle;
  final String workspaceSubtitle;

  /// Animated checklist shown while creating the workspace.
  final List<String> workspaceTasks;

  /// Final button shown before authentication.
  final String claimWorkspaceButton;

  const CTMissionProfile({
    required this.type,
    required this.hero,
    required this.actionButton,
    required this.highlights,
    this.workspaceTitle = 'Creating Your Workspace',

    this.workspaceSubtitle =
        'We\'re personalizing ChariTask for the way your organization serves its community.',

    this.workspaceTasks = const [
      'Applying Mission Profile',
      'Personalizing Workspace',
      'Configuring Teams',
      'Setting Up Permissions',
      'Installing Starter Templates',
      'Preparing Dashboard',
    ],

    this.claimWorkspaceButton = 'Claim My Workspace',
  });
}
