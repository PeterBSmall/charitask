import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/domain/identity/organization_role.dart';
import 'package:charitask/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';

class OnboardingProvisioningService {
  OnboardingProvisioningService._();

  static Future<Map<String, dynamic>> provision({
    required OnboardingController onboardingController,
    required CTJourneyController journeyController,
  }) async {
    final person = onboardingController.person;
    final organizationRole = onboardingController.organizationRole;

    if (person == null) {
      throw Exception(
        'Unable to provision organization: person information is missing.',
      );
    }

    if (organizationRole == null) {
      throw Exception(
        'Unable to provision organization: organizational role is missing.',
      );
    }

    final organizationName = journeyController.organization.identity.name
        .trim();

    if (organizationName.isEmpty) {
      throw Exception(
        'Unable to provision organization: organization name is missing.',
      );
    }

    final organizationSlug = _slugify(organizationName);

    final role = _roleData(organizationRole);

    final response = await Supabase.instance.client.rpc(
      'provision_initial_organization',
      params: {
        'p_organization_name': organizationName,
        'p_organization_slug': organizationSlug,
        'p_first_name': person.firstName.trim(),
        'p_last_name': person.lastName.trim(),
        'p_email': person.email?.trim() ?? '',
        'p_phone': person.phone?.trim() ?? '',
        'p_organization_role_slug': role.slug,
        'p_organization_role_name': role.name,
        'p_location_name': journeyController.organizationLocation.trim(),
      },
    );

    if (response == null) {
      throw Exception('Organization provisioning returned no data.');
    }

    return Map<String, dynamic>.from(response);
  }

  static String _slugify(String value) {
    return value
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r"[^a-z0-9]+"), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }

  static _RoleData _roleData(OrganizationRole role) {
    switch (role) {
      case OrganizationRole.founder:
        return const _RoleData(slug: 'founder', name: 'Founder');

      case OrganizationRole.president:
        return const _RoleData(slug: 'president', name: 'President');

      case OrganizationRole.ceo:
        return const _RoleData(slug: 'ceo', name: 'CEO');

      case OrganizationRole.executiveDirector:
        return const _RoleData(
          slug: 'executive-director',
          name: 'Executive Director',
        );

      case OrganizationRole.administrator:
        return const _RoleData(slug: 'administrator', name: 'Administrator');

      case OrganizationRole.it:
        return const _RoleData(slug: 'it', name: 'IT');

      case OrganizationRole.boardMember:
        return const _RoleData(slug: 'board-member', name: 'Board Member');

      case OrganizationRole.officeManager:
        return const _RoleData(slug: 'office-manager', name: 'Office Manager');

      case OrganizationRole.other:
        return const _RoleData(slug: 'other', name: 'Other');
    }
  }
}

class _RoleData {
  final String slug;
  final String name;

  const _RoleData({required this.slug, required this.name});
}
