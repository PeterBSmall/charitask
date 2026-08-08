import 'package:charitask/domain/organization/organization_type.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';

class CTMissionProfile {
  final OrganizationType type;

  /// Complete hero used throughout onboarding.
  final CTJourneyHeroData hero;

  /// Primary call-to-action button text.
  final String actionButton;

  /// Example organizations shown during onboarding.
  final List<String> examples;

  const CTMissionProfile({
    required this.type,
    required this.hero,
    required this.actionButton,
    required this.examples,
  });
}
