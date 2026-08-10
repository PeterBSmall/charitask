import 'journey_definition.dart';
import 'journey_type.dart';

import 'package:charitask/shared/data/ct_journey_heroes.dart';

class JourneyRegistry {
  JourneyRegistry._();

  static JourneyDefinition get(JourneyType type) {
    switch (type) {
      case JourneyType.nonprofit:
        return JourneyDefinition(
          type: JourneyType.nonprofit,
          hero: CTJourneyHeroes.organizationSetup,
        );

      default:
        throw UnimplementedError(
          'Journey "$type" has not been implemented yet.',
        );
    }
  }
}
