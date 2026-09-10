import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/foundations/app_colors.dart';
import 'package:charitask/shared/design_system/foundations/app_spacing.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/widgets/cards/ct_module_card.dart';

class OrganizationWorkspace extends StatelessWidget {
  final CTJourneyController journeyController;

  const OrganizationWorkspace({super.key, required this.journeyController});

  @override
  Widget build(BuildContext context) {
    final organizationName = journeyController.organization.identity.name
        .trim();

    final displayName = organizationName.isEmpty
        ? 'Organization'
        : organizationName;

    return Container(
      color: const Color(0xFFF7F8FC),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          28,
          AppSpacing.lg,
          40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------------------------------------------------
            // PAGE HEADER
            // ------------------------------------------------------------
            Text(
              'Organization',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2F3A4A),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Manage your organization, identity, mission, and resources.',
              style: const TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
            ),

            const SizedBox(height: 24),

            // ------------------------------------------------------------
            // ORGANIZATION PROFILE CARD
            // ------------------------------------------------------------
            _buildOrganizationHeader(displayName),

            const SizedBox(height: 24),

            // ------------------------------------------------------------
            // ORGANIZATION MODULES
            // ------------------------------------------------------------
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                if (width >= 1050) {
                  return _buildWideGrid();
                }

                if (width >= 650) {
                  return _buildMediumGrid();
                }

                return _buildNarrowGrid();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // ORGANIZATION HEADER
  // ==========================================================================

  Widget _buildOrganizationHeader(String organizationName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4338B8), Color(0xFF5B4BC4)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: const Icon(
              Icons.account_balance_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ORGANIZATION PROFILE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  organizationName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Identity, mission, brand, contacts, compliance, and resources.',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // WIDE GRID
  // ==========================================================================

  Widget _buildWideGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _organizationProfileCard()),
            const SizedBox(width: 16),
            Expanded(child: _missionEngineCard()),
            const SizedBox(width: 16),
            Expanded(child: _brandIdentityCard()),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(child: _contactInformationCard()),
            const SizedBox(width: 16),
            Expanded(child: _legalComplianceCard()),
            const SizedBox(width: 16),
            Expanded(child: _resourcesCard()),
          ],
        ),
      ],
    );
  }

  // ==========================================================================
  // MEDIUM GRID
  // ==========================================================================

  Widget _buildMediumGrid() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        SizedBox(width: 300, child: _organizationProfileCard()),
        SizedBox(width: 300, child: _missionEngineCard()),
        SizedBox(width: 300, child: _brandIdentityCard()),
        SizedBox(width: 300, child: _contactInformationCard()),
        SizedBox(width: 300, child: _legalComplianceCard()),
        SizedBox(width: 300, child: _resourcesCard()),
      ],
    );
  }

  // ==========================================================================
  // NARROW GRID
  // ==========================================================================

  Widget _buildNarrowGrid() {
    return Column(
      children: [
        _organizationProfileCard(),
        const SizedBox(height: 16),
        _missionEngineCard(),
        const SizedBox(height: 16),
        _brandIdentityCard(),
        const SizedBox(height: 16),
        _contactInformationCard(),
        const SizedBox(height: 16),
        _legalComplianceCard(),
        const SizedBox(height: 16),
        _resourcesCard(),
      ],
    );
  }

  // ==========================================================================
  // MODULE CARDS
  // ==========================================================================

  Widget _organizationProfileCard() {
    return CTModuleCard(
      icon: Icons.flag_outlined,
      title: 'Organization Profile',
      description: 'Organization name, logo, mission statement and history',
      iconColor: const Color(0xFF67B96B),
      iconBackground: const Color(0xFFEAF6EC),
      onTap: () {},
    );
  }

  Widget _missionEngineCard() {
    return CTModuleCard(
      icon: Icons.favorite_outline,
      title: 'Mission Engine',
      description: 'Vision, values, mission moments and organizational culture',
      iconColor: const Color(0xFF7657D9),
      iconBackground: const Color(0xFFF0ECFF),
      onTap: () {},
    );
  }

  Widget _brandIdentityCard() {
    return CTModuleCard(
      icon: Icons.palette_outlined,
      title: 'Brand Identity',
      description: 'Colors, typography, logos and brand assets',
      iconColor: const Color(0xFFD9B43B),
      iconBackground: const Color(0xFFFBF5DF),
      onTap: () {},
    );
  }

  Widget _contactInformationCard() {
    return CTModuleCard(
      icon: Icons.contact_phone_outlined,
      title: 'Contact Information',
      description: 'Website, email, phone and social media',
      iconColor: const Color(0xFFE77A2F),
      iconBackground: const Color(0xFFFDF0E7),
      onTap: () {},
    );
  }

  Widget _legalComplianceCard() {
    return CTModuleCard(
      icon: Icons.account_balance_outlined,
      title: 'Legal & Compliance',
      description: 'Registration, governance and compliance information',
      iconColor: const Color(0xFF4D9C98),
      iconBackground: const Color(0xFFEAF5F4),
      onTap: () {},
    );
  }

  Widget _resourcesCard() {
    return CTModuleCard(
      icon: Icons.folder_outlined,
      title: 'Resources',
      description: 'Policies, handbooks, templates and organization resources',
      iconColor: const Color(0xFF5B7FEA),
      iconBackground: const Color(0xFFEDF1FF),
      onTap: () {},
    );
  }
}
