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
  final double? latitude;
  final double? longitude;

  const CTGooglePlaceDetails({
    required this.placeId,
    required this.formattedAddress,
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
  /// The session token used for autocomplete is included here,
  /// which completes the autocomplete session.
  Future<CTGooglePlaceDetails> getPlaceDetails(String placeId) async {
    if (_apiKey.isEmpty) {
      throw StateError('Google Places API key is not configured.');
    }

    final response = await http.get(
      Uri.parse('$_placesUrl/$placeId'),
      headers: {
        'X-Goog-Api-Key': _apiKey,
        'X-Goog-FieldMask': 'id,formattedAddress,location',
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

    final details = CTGooglePlaceDetails(
      placeId: data['id'] as String? ?? placeId,
      formattedAddress: data['formattedAddress'] as String? ?? '',
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
