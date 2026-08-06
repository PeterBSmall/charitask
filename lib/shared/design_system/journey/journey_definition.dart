import 'journey_type.dart';

import 'package:charitask/shared/models/ct_journey_hero_data.dart';

class JourneyDefinition {
  final JourneyType type;
  final CTJourneyHeroData hero;

  const JourneyDefinition({required this.type, required this.hero});
}
