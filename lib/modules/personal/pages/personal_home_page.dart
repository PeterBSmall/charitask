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

class PersonalHomePage extends StatelessWidget {
  const PersonalHomePage({super.key});

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
      body: Row(
        children: [
          const PersonalHomeSidebar(),

          Expanded(
            child: Column(
              children: [
                const PersonalHomeHeader(),

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;

                      // ===================================================
                      // RESPONSIVE BREAKPOINT
                      // ===================================================
                      //
                      // Wide:
                      //   Main Content | Right Rail
                      //
                      // Narrow:
                      //   Main Content
                      //   Right Rail
                      //
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PersonalHomeHero(),

        const SizedBox(height: 20),

        const PersonalHomeStats(),

        const SizedBox(height: 28),

        PersonalHomeWorkspaces(
          onCreateWorkspace: () => _createPersonalWorkspace(context),
          onOpenWorkspace: (workspace) =>
              _openPersonalWorkspace(context, workspace),
        ),

        const SizedBox(height: 28),

        const PersonalHomeOrganizations(),

        const SizedBox(height: 28),

        const PersonalHomeActionCenter(),

        const SizedBox(height: 28),

        const PersonalHomeActivity(),

        const SizedBox(height: 24),
      ],
    );
  }
}
