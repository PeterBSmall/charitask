import 'package:flutter/material.dart';

import 'package:charitask/app/app_router.dart';
import 'package:charitask/domain/mission_profile/mission_profile.dart';

import 'ct_workspace_completion_action_card.dart';

class CTWorkspaceCompletionScreen extends StatelessWidget {
  final CTMissionProfile profile;
  final VoidCallback onCompleteProfile;
  final VoidCallback onGoToWorkspace;

  const CTWorkspaceCompletionScreen({
    super.key,
    required this.profile,
    required this.onCompleteProfile,
    required this.onGoToWorkspace,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 760;
        final narrow = constraints.maxWidth < 1050;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            narrow ? 16 : 28,
            compact ? 16 : 24,
            narrow ? 16 : 28,
            14,
          ),
          child: Column(
            children: [
              if (narrow) _buildCardColumn(context) else _buildCardRow(context),

              SizedBox(height: compact ? 10 : 14),

              const _FooterMessage(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _buildPersonalDetailsCard()),
        const SizedBox(width: 16),
        Expanded(child: _buildPersonalHomeCard(context)),
        const SizedBox(width: 16),
        Expanded(child: _buildOrganizationCard()),
      ],
    );
  }

  Widget _buildCardColumn(BuildContext context) {
    return Column(
      children: [
        _buildPersonalDetailsCard(),
        const SizedBox(height: 14),
        _buildPersonalHomeCard(context),
        const SizedBox(height: 14),
        _buildOrganizationCard(),
      ],
    );
  }

  Widget _buildPersonalDetailsCard() {
    return CTWorkspaceCompletionActionCard(
      icon: Icons.person_outline_rounded,
      title: 'Complete Your Personal Details',
      description:
          'Finish your personal profile so ChariTask can personalize your experience.',
      highlights: const [
        'Complete your personal profile',
        'Add your preferred details',
        'Set up your personal workspace',
        'Continue into ChariTask',
      ],
      buttonLabel: 'Complete Personal Details',
      accentColor: const Color(0xFF6547E8),
      iconBackgroundColor: const Color(0xFFF0EBFF),
      onPressed: onCompleteProfile,
    );
  }

  Widget _buildPersonalHomeCard(BuildContext context) {
    return CTWorkspaceCompletionActionCard(
      icon: Icons.home_outlined,
      title: 'Go to Your Personal Home',
      description:
          'Access your personal workspaces, organizations, invitations, tasks, and more.',
      highlights: const [
        'Access your workspaces',
        'View your organizations',
        'Manage invitations',
        'Stay on top of your tasks',
      ],
      buttonLabel: 'Go to Personal Home',
      accentColor: const Color(0xFF0FA3B1),
      iconBackgroundColor: const Color(0xFFE5F8FA),
      onPressed: () => AppRouter.goToPersonalHome(context),
    );
  }

  Widget _buildOrganizationCard() {
    return CTWorkspaceCompletionActionCard(
      icon: Icons.account_balance_outlined,
      title: 'Go to Organizational Workspace',
      description:
          'Access your organization\'s people, groups, tools, and day-to-day operations.',
      highlights: const [
        'Manage your organization',
        'View people and roles',
        'Work with groups and teams',
        'Access organization tools',
      ],
      buttonLabel: 'Go to Organization',
      accentColor: const Color(0xFF5878D9),
      iconBackgroundColor: const Color(0xFFEAF0FF),
      onPressed: onGoToWorkspace,
    );
  }
}

class _FooterMessage extends StatelessWidget {
  const _FooterMessage();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lightbulb_outline_rounded,
          size: 16,
          color: Color(0xFF7A8A7A),
        ),
        SizedBox(width: 8),
        Flexible(
          child: Text(
            'You can always access these options later from your dashboard.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFF667085)),
          ),
        ),
      ],
    );
  }
}
