import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

class CTGooglePlacePrediction {
  final String placeId;
  final String description;

  const CTGooglePlacePrediction({
    required this.placeId,
    required this.description,
  });
}

class CTGooglePlaceDetails {
  final String placeId;
  final String formattedAddress;

  final String? streetAddress;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;

  final double? latitude;
  final double? longitude;

  const CTGooglePlaceDetails({
    required this.placeId,
    required this.formattedAddress,
    this.streetAddress,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.latitude,
    this.longitude,
  });
}

class CTGooglePlacesService {
  CTGooglePlacesService({String? apiKey})
    : _apiKey = apiKey ?? const String.fromEnvironment('GOOGLE_PLACES_API_KEY');

  static const String _autocompleteUrl =
      'https://places.googleapis.com/v1/places:autocomplete';

  static const String _placesUrl = 'https://places.googleapis.com/v1/places';

  final String _apiKey;

  String? _sessionToken;

  /// Starts a new autocomplete session.
  ///
  /// Google recommends a fresh session token for each
  /// autocomplete → place selection flow.
  void startSession() {
    final random = Random.secure();

    final bytes = List<int>.generate(18, (_) => random.nextInt(256));

    _sessionToken = base64UrlEncode(bytes).replaceAll('=', '');
  }

  /// Ends the current autocomplete session.
  void endSession() {
    _sessionToken = null;
  }

  /// Returns place predictions for the supplied text.
  Future<List<CTGooglePlacePrediction>> autocomplete(String input) async {
    if (_apiKey.isEmpty) {
      throw StateError(
        'Google Places API key is not configured. '
        'Run Flutter with --dart-define=GOOGLE_PLACES_API_KEY=YOUR_KEY',
      );
    }

    final trimmed = input.trim();

    if (trimmed.length < 3) {
      return const [];
    }

    _sessionToken ??= _createSessionToken();

    final response = await http.post(
      Uri.parse(_autocompleteUrl),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': _apiKey,
        'X-Goog-FieldMask':
            'suggestions.placePrediction.placeId,'
            'suggestions.placePrediction.text.text',
      },
      body: jsonEncode({
        'input': trimmed,
        'regionCode': 'us',
        'sessionToken': _sessionToken,
        'includeQueryPredictions': false,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Google Places Autocomplete failed '
        '(${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body);

    final suggestions = data['suggestions'] as List<dynamic>? ?? const [];

    return suggestions
        .where((item) => item['placePrediction'] != null)
        .map((item) {
          final prediction = item['placePrediction'] as Map<String, dynamic>;

          return CTGooglePlacePrediction(
            placeId: prediction['placeId'] as String,
            description: prediction['text']?['text'] as String? ?? '',
          );
        })
        .where((prediction) => prediction.description.isNotEmpty)
        .toList();
  }

  /// Gets the selected place's details.
  ///
  /// Returns both the formatted address and structured
  /// address components needed by ChariTask Locations.
  ///
  /// The session token used for autocomplete is included
  /// in the request flow and the session is ended after
  /// the details request completes.
  Future<CTGooglePlaceDetails> getPlaceDetails(String placeId) async {
    if (_apiKey.isEmpty) {
      throw StateError('Google Places API key is not configured.');
    }

    final response = await http.get(
      Uri.parse('$_placesUrl/$placeId'),
      headers: {
        'X-Goog-Api-Key': _apiKey,
        'X-Goog-FieldMask':
            'id,formattedAddress,location,'
            'addressComponents',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Google Place Details failed '
        '(${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body);

    final location = data['location'] as Map<String, dynamic>?;

    final addressComponents =
        data['addressComponents'] as List<dynamic>? ?? const [];

    String? streetNumber;
    String? route;
    String? city;
    String? state;
    String? postalCode;
    String? country;

    for (final component in addressComponents) {
      final map = component as Map<String, dynamic>;

      final types = (map['types'] as List<dynamic>? ?? const [])
          .map((type) => type.toString())
          .toSet();

      final longText = map['longText'] as String?;

      if (longText == null || longText.isEmpty) {
        continue;
      }

      if (types.contains('street_number')) {
        streetNumber = longText;
      } else if (types.contains('route')) {
        route = longText;
      } else if (types.contains('locality')) {
        city = longText;
      } else if (types.contains('administrative_area_level_1')) {
        state = longText;
      } else if (types.contains('postal_code')) {
        postalCode = longText;
      } else if (types.contains('country')) {
        country = map['shortText'] as String? ?? longText;
      }
    }

    String? streetAddress;

    final streetParts = [
      streetNumber,
      route,
    ].where((part) => part != null && part.trim().isNotEmpty);

    if (streetParts.isNotEmpty) {
      streetAddress = streetParts.join(' ');
    }

    final details = CTGooglePlaceDetails(
      placeId: data['id'] as String? ?? placeId,
      formattedAddress: data['formattedAddress'] as String? ?? '',
      streetAddress: streetAddress,
      city: city,
      state: state,
      postalCode: postalCode,
      country: country,
      latitude: (location?['latitude'] as num?)?.toDouble(),
      longitude: (location?['longitude'] as num?)?.toDouble(),
    );

    // The Details request completes the session.
    endSession();

    return details;
  }

  String _createSessionToken() {
    final random = Random.secure();

    final bytes = List<int>.generate(18, (_) => random.nextInt(256));

    return base64UrlEncode(bytes).replaceAll('=', '');
  }
}
