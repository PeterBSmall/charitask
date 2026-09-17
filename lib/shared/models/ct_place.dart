class CTPlace {
  final String primary;
  final String secondary;
  final String? placeId;
  final double? latitude;
  final double? longitude;

  // Structured address fields returned by Google Places.
  final String? streetAddress;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;

  const CTPlace({
    required this.primary,
    required this.secondary,
    this.placeId,
    this.latitude,
    this.longitude,
    this.streetAddress,
    this.city,
    this.state,
    this.postalCode,
    this.country,
  });
}
