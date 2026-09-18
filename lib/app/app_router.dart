import 'package:flutter/material.dart';

import 'package:charitask/modules/people/pages/people_page.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:charitask/domain/organization/current_organization_context.dart';
import 'package:charitask/modules/personal/pages/personal_home_page.dart';
import 'package:charitask/modules/foundation/pages/workspaces/foundation_workspace.dart';
import 'package:charitask/modules/organization/data/services/organization_service.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';

class AppRouter {
  AppRouter._();

  static Future<void> goToOrganization(
    BuildContext context,
    String organizationId,
  ) async {
    final organizationService = OrganizationService();

    try {
      final firstName = await organizationService.getMyFirstName();

      if (!context.mounted) return;

      final journeyController = CTJourneyController()
        ..updateFirstName(firstName);

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FoundationWorkspace(
            journeyController: journeyController,
            organizationId: organizationId,
          ),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to open your organization: $error')),
      );
    }
  }

  static Future<void> goToPersonalHome(BuildContext context) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => PersonalHomePage()));
  }

  static Future<void> goToPeople(BuildContext context) async {
    final organizationId = await CurrentOrganizationContext(
      Supabase.instance.client,
    ).getOrganizationId();

    if (!context.mounted) return;

    if (organizationId == null || organizationId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to load your organization.')),
      );
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PeoplePage(organizationId: organizationId),
      ),
    );
  }
}
