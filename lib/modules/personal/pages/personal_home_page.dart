import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/personal/widgets/home/personal_home_action_center.dart';
import 'package:charitask/modules/personal/widgets/home/personal_home_activity.dart';
import 'package:charitask/modules/personal/widgets/home/personal_home_header.dart';
import 'package:charitask/modules/personal/widgets/home/personal_home_hero.dart';
import 'package:charitask/modules/personal/widgets/home/personal_home_organizations.dart';
import 'package:charitask/modules/personal/widgets/home/personal_home_right_rail.dart';
import 'package:charitask/modules/personal/widgets/home/personal_home_sidebar.dart';
import 'package:charitask/modules/personal/widgets/home/personal_home_stats.dart';
import 'package:charitask/modules/personal/widgets/home/personal_home_workspaces.dart';
import 'package:charitask/modules/foundation/pages/onboarding/personal_workspace/personal_workspace_setup_page.dart';
import 'package:charitask/shared/workspaces/models/ct_workspace.dart';
import 'package:charitask/modules/workspaces/personal/personal_workspace_shell.dart';
import 'package:charitask/modules/organization/data/services/organization_service.dart';
import 'package:charitask/app/app_router.dart';

class PersonalHomePage extends StatelessWidget {
  PersonalHomePage({super.key});

  Future<void> _openMyOrganizations(BuildContext context) async {
    final user = Supabase.instance.client.auth.currentUser;

    debugPrint('=== PERSONAL HOME AUTH ===');
    debugPrint('AUTH USER ID: ${user?.id}');
    debugPrint('AUTH EMAIL: ${user?.email}');
    debugPrint('AUTH METADATA: ${user?.userMetadata}');
    debugPrint('==========================');

    try {
      final organizations = await _organizationService.getMyOrganizations();

      if (!context.mounted) return;

      if (organizations.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'You are not currently a member of any organizations.',
            ),
          ),
        );
        return;
      }

      if (organizations.length == 1) {
        await AppRouter.goToOrganization(context, organizations.first.id);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Multiple organizations found. Organization selection will be added next.',
          ),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to load your organizations: $error')),
      );
    }
  }

  final OrganizationService _organizationService = OrganizationService();

  void _createPersonalWorkspace(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PersonalWorkspaceSetupPage.fromPersonalHome(),
      ),
    );
  }

  Future<void> _openPersonalWorkspace(
    BuildContext context,
    Map<String, dynamic> workspaceData,
  ) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return;

    final identity = await supabase
        .from('person_auth_identities')
        .select('person_id')
        .eq('auth_user_id', user.id)
        .maybeSingle();

    if (identity == null) return;

    final personId = identity['person_id'] as String;

    final person = await supabase
        .from('persons')
        .select('first_name')
        .eq('id', personId)
        .maybeSingle();

    final firstName = person?['first_name'] as String? ?? '';

    final workspace = CTWorkspace(
      id: workspaceData['id'] as String,
      name: workspaceData['name'] as String,
      type: CTWorkspaceType.personal,
      icon: Icons.grid_view_rounded,
      color: const Color(0xFF7C4DFF),
      templateId: workspaceData['template_id'] as String?,
    );

    if (!context.mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            PersonalWorkspaceShell(workspace: workspace, firstName: firstName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          debugPrint(
            '=== PERSONAL HOME OUTER CONSTRAINT === '
            'width=${constraints.maxWidth} '
            'height=${constraints.maxHeight}',
          );

          final showSidebar = constraints.maxWidth >= 900;

          return Row(
            children: [
              if (showSidebar)
                PersonalHomeSidebar(
                  onMyOrganizations: () => _openMyOrganizations(context),
                ),
              Expanded(
                child: Column(
                  children: [
                    const PersonalHomeHeader(),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, contentConstraints) {
                          debugPrint(
                            '=== PERSONAL HOME CONTENT CONSTRAINT === '
                            'width=${contentConstraints.maxWidth} '
                            'height=${contentConstraints.maxHeight}',
                          );

                          final width = contentConstraints.maxWidth;
                          final showRightRailBesideContent = width >= 1100;

                          return SingleChildScrollView(
                            padding: EdgeInsets.all(width < 700 ? 16 : 24),
                            child: showRightRailBesideContent
                                ? _buildWideLayout(context)
                                : _buildNarrowLayout(context),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // =======================================================================
  // WIDE LAYOUT
  // =======================================================================

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildMainContent(context)),
        const SizedBox(width: 24),
        const SizedBox(width: 300, child: PersonalHomeRightRail()),
      ],
    );
  }

  // =======================================================================
  // NARROW LAYOUT
  // =======================================================================

  Widget _buildNarrowLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMainContent(context),
        const SizedBox(height: 28),
        const PersonalHomeRightRail(),
        const SizedBox(height: 24),
      ],
    );
  }

  // =======================================================================
  // MAIN CONTENT
  // =======================================================================

  Widget _buildMainContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        debugPrint(
          '=== PERSONAL HOME _buildMainContent === '
          'width=${constraints.maxWidth} '
          'height=${constraints.maxHeight}',
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, c) {
                debugPrint(
                  '=== PERSONAL HOME HERO === '
                  'width=${c.maxWidth}',
                );

                return const PersonalHomeHero();
              },
            ),

            const SizedBox(height: 20),

            LayoutBuilder(
              builder: (context, c) {
                debugPrint(
                  '=== PERSONAL HOME STATS === '
                  'width=${c.maxWidth}',
                );

                return const PersonalHomeStats();
              },
            ),

            const SizedBox(height: 28),

            LayoutBuilder(
              builder: (context, c) {
                debugPrint(
                  '=== PERSONAL HOME WORKSPACES === '
                  'width=${c.maxWidth}',
                );

                return PersonalHomeWorkspaces(
                  onCreateWorkspace: () => _createPersonalWorkspace(context),
                  onOpenWorkspace: (workspace) =>
                      _openPersonalWorkspace(context, workspace),
                );
              },
            ),

            const SizedBox(height: 28),

            LayoutBuilder(
              builder: (context, c) {
                debugPrint(
                  '=== PERSONAL HOME ORGANIZATIONS === '
                  'width=${c.maxWidth}',
                );

                return const PersonalHomeOrganizations();
              },
            ),

            const SizedBox(height: 28),

            LayoutBuilder(
              builder: (context, c) {
                debugPrint(
                  '=== PERSONAL HOME ACTION CENTER === '
                  'width=${c.maxWidth}',
                );

                return const PersonalHomeActionCenter();
              },
            ),

            const SizedBox(height: 28),

            LayoutBuilder(
              builder: (context, c) {
                debugPrint(
                  '=== PERSONAL HOME ACTIVITY === '
                  'width=${c.maxWidth}',
                );

                return const PersonalHomeActivity();
              },
            ),

            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
