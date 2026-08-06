import 'package:charitask/shared/design_system/forms/ct_place_result_card.dart';
import 'package:charitask/shared/models/ct_place.dart';

class CTPlace {
  final String primary;
  final String secondary;

  final String? placeId;

  final double? latitude;
  final double? longitude;

  const CTPlace({
    required this.primary,
    required this.secondary,
    this.placeId,
    this.latitude,
    this.longitude,
  });
}
