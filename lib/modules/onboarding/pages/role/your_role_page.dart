import 'package:flutter/material.dart';

import 'package:charitask/domain/identity/organization_role.dart';
import 'package:charitask/modules/onboarding/controllers/onboarding_controller.dart';
import 'widgets/administrator_notice.dart';
import 'widgets/onboarding_progress.dart';
import 'widgets/role_brand_panel.dart';
import 'widgets/role_option_card.dart';

class YourRolePage extends StatefulWidget {
  final OnboardingController controller;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const YourRolePage({
    super.key,
    required this.controller,
    required this.onContinue,
    required this.onBack,
  });

  @override
  State<YourRolePage> createState() => _YourRolePageState();
}

class _YourRolePageState extends State<YourRolePage> {
  OrganizationRole? _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.controller.organizationRole;
  }

  void _selectRole(OrganizationRole role) {
    setState(() {
      _selectedRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400, maxHeight: 900),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: [
                    // ------------------------------------------------------
                    // LEFT BRAND PANEL
                    // ------------------------------------------------------
                    const RoleBrandPanel(),

                    // ------------------------------------------------------
                    // RIGHT CONTENT
                    // ------------------------------------------------------
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 24, 40, 24),
                        child: Column(
                          children: [
                            const OnboardingProgress(currentStep: 2),

                            const SizedBox(height: 28),

                            Expanded(child: _buildContent()),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --------------------------------------------------------------
        // HEADER
        // --------------------------------------------------------------
        const Text(
          'Tell us about your role',
          style: TextStyle(
            color: Color(0xFF182238),
            fontSize: 34,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'What is your role in the organization you’re setting up?',
          style: TextStyle(color: Color(0xFF596579), fontSize: 16, height: 1.4),
        ),

        const SizedBox(height: 12),

        // --------------------------------------------------------------
        // PERSONALIZATION MESSAGE
        // --------------------------------------------------------------
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F0FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.verified_user_rounded,
                color: Color(0xFF5633D8),
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'This helps ChariTask ',
                style: TextStyle(color: Color(0xFF596579), fontSize: 13),
              ),
              Text(
                'tailor your workspace, permissions, and guidance.',
                style: TextStyle(
                  color: Color(0xFF5633D8),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // --------------------------------------------------------------
        // ROLE OPTIONS
        // --------------------------------------------------------------
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------------------------------------------------
              // ROW 1
              // --------------------------------------------------------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: RoleOptionCard(
                      role: OrganizationRole.founder,
                      title: 'Founder',
                      description:
                          'I started or established this organization.',
                      icon: Icons.spa_outlined,
                      accentColor: const Color(0xFF67B96B),
                      selected: _selectedRole == OrganizationRole.founder,
                      onTap: () => _selectRole(OrganizationRole.founder),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: RoleOptionCard(
                      role: OrganizationRole.president,
                      title: 'President',
                      description:
                          'I serve as the president of the organization.',
                      icon: Icons.person_outline_rounded,
                      accentColor: const Color(0xFFD9B43B),
                      selected: _selectedRole == OrganizationRole.president,
                      onTap: () => _selectRole(OrganizationRole.president),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: RoleOptionCard(
                      role: OrganizationRole.ceo,
                      title: 'CEO',
                      description:
                          'I am the chief executive officer of the organization.',
                      icon: Icons.business_center_outlined,
                      accentColor: const Color(0xFF8E2F4F),
                      selected: _selectedRole == OrganizationRole.ceo,
                      onTap: () => _selectRole(OrganizationRole.ceo),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: RoleOptionCard(
                      role: OrganizationRole.executiveDirector,
                      title: 'Executive Director',
                      description: 'I manage daily operations.',
                      icon: Icons.groups_rounded,
                      accentColor: const Color(0xFFE77A2F),
                      selected:
                          _selectedRole == OrganizationRole.executiveDirector,
                      onTap: () =>
                          _selectRole(OrganizationRole.executiveDirector),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // --------------------------------------------------------------
              // ROW 2
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: RoleOptionCard(
                      role: OrganizationRole.administrator,
                      title: 'Administrator',
                      description:
                          'I manage or oversee the organization’s operations.',
                      icon: Icons.shield_outlined,
                      accentColor: const Color(0xFF4D9C98),
                      selected: _selectedRole == OrganizationRole.administrator,
                      onTap: () => _selectRole(OrganizationRole.administrator),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: RoleOptionCard(
                      role: OrganizationRole.boardMember,
                      title: 'IT',
                      description: 'I manage technology and systems.',
                      icon: Icons.devices_outlined,
                      accentColor: const Color(0xFF5B7FEA),
                      selected: _selectedRole == OrganizationRole.boardMember,
                      onTap: () => _selectRole(OrganizationRole.boardMember),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: RoleOptionCard(
                      role: OrganizationRole.officeManager,
                      title: 'Office Manager',
                      description: 'I manage day-to-day office operations.',
                      icon: Icons.business_center_outlined,
                      accentColor: const Color(0xFF67AFA8),
                      selected: _selectedRole == OrganizationRole.officeManager,
                      onTap: () => _selectRole(OrganizationRole.officeManager),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: RoleOptionCard(
                      role: OrganizationRole.other,
                      title: 'Other',
                      description: 'My role is not listed here.',
                      icon: Icons.more_horiz_rounded,
                      accentColor: const Color(0xFF7C5CE5),
                      selected: _selectedRole == OrganizationRole.other,
                      onTap: () => _selectRole(OrganizationRole.other),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // --------------------------------------------------------------
              // ADMINISTRATOR NOTICE
              // --------------------------------------------------------------
              const AdministratorNotice(),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // --------------------------------------------------------------
        // ACTIONS
        // --------------------------------------------------------------
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: widget.onBack,
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Back'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(130, 52),
                side: const BorderSide(color: Color(0xFFD9D1FF)),
                foregroundColor: const Color(0xFF6546E8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const Spacer(),

            ElevatedButton.icon(
              onPressed: _selectedRole == null
                  ? null
                  : () {
                      widget.controller.setOrganizationRole(_selectedRole!);
                      widget.onContinue();
                    },
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('Continue'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(160, 52),
                backgroundColor: const Color(0xFF6C4CF1),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFE3E0EF),
                disabledForegroundColor: const Color(0xFF9A96A8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
