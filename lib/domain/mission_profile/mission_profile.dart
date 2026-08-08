import 'package:charitask/domain/organization/organization_type.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';

class CTMissionProfile {
  final OrganizationType type;

  /// Complete hero used throughout onboarding.
  final CTJourneyHeroData hero;

  /// Primary call-to-action button text.
  final String actionButton;

  /// Key capabilities shown in the hero panel.
  final List<String> highlights;

  const CTMissionProfile({
    required this.type,
    required this.hero,
    required this.actionButton,
    required this.highlights,
  });
}
