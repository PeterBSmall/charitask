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
