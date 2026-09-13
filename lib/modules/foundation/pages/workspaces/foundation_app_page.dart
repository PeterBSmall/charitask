import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/domain/organization/current_organization_context.dart';
import 'package:charitask/modules/foundation/pages/workspaces/foundation_workspace.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';

class FoundationAppPage extends StatefulWidget {
  final CTJourneyController journeyController;

  const FoundationAppPage({super.key, required this.journeyController});

  @override
  State<FoundationAppPage> createState() => _FoundationAppPageState();
}

class _FoundationAppPageState extends State<FoundationAppPage> {
  late final Future<String?> _organizationIdFuture;

  @override
  void initState() {
    super.initState();

    _organizationIdFuture = CurrentOrganizationContext(
      Supabase.instance.client,
    ).getOrganizationId();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _organizationIdFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Color(0xFFF5F6FA),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final organizationId = snapshot.data;

        if (organizationId == null || organizationId.isEmpty) {
          return const Scaffold(
            backgroundColor: Color(0xFFF5F6FA),
            body: Center(child: Text('Unable to load your organization.')),
          );
        }

        return FoundationWorkspace(
          journeyController: widget.journeyController,
          organizationId: organizationId,
        );
      },
    );
  }
}
