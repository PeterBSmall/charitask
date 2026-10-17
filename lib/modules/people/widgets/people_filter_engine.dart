import 'package:charitask/modules/people/widgets/people_filters_dialog.dart';

class PeopleFilterEngine {
  const PeopleFilterEngine._();

  static List<String> options(
    List<Map<String, dynamic>> people,
    String key, {
    bool commaSeparated = false,
  }) {
    final values = <String>{};

    for (final person in people) {
      final raw = person[key]?.toString().trim();

      if (raw == null || raw.isEmpty || raw == '—') {
        continue;
      }

      if (commaSeparated) {
        values.addAll(_splitValues(raw));
      } else {
        values.add(raw);
      }
    }

    return values.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  }

  static List<Map<String, dynamic>> apply({
    required List<Map<String, dynamic>> people,
    required String searchQuery,
    required PeopleFilterSelection filters,
  }) {
    final query = searchQuery.trim().toLowerCase();

    final filtered = people.where((person) {
      if (filters.personType != null &&
          person['person_type']?.toString() != filters.personType) {
        return false;
      }

      if (filters.status != null &&
          person['status']?.toString() != filters.status) {
        return false;
      }

      if (!_matchesValue(person['role'], filters.role)) {
        return false;
      }

      if (!_matchesValue(person['groups'], filters.group)) {
        return false;
      }

      if (!_matchesValue(person['locations'], filters.location)) {
        return false;
      }

      if (query.isEmpty) {
        return true;
      }

      final searchableValues = [
        person['first_name'],
        person['last_name'],
        person['preferred_name'],
        person['email'],
        person['phone'],
        person['person_type'],
        person['role'],
        person['groups'],
        person['locations'],
      ];

      return searchableValues.any(
        (value) =>
            value != null && value.toString().toLowerCase().contains(query),
      );
    }).toList();

    filtered.sort((a, b) {
      String firstName(Map<String, dynamic> person) {
        final preferred = person['preferred_name']?.toString().trim();
        final first = person['first_name']?.toString().trim() ?? '';
        final last = person['last_name']?.toString().trim() ?? '';

        final givenName = preferred != null && preferred.isNotEmpty
            ? preferred
            : first;

        return '$givenName $last'.trim().toLowerCase();
      }

      return firstName(a).compareTo(firstName(b));
    });

    return filtered;
  }

  static bool _matchesValue(Object? raw, String? selected) {
    if (selected == null) {
      return true;
    }

    return _splitValues(raw).contains(selected);
  }

  static List<String> _splitValues(Object? raw) {
    final value = raw?.toString().trim() ?? '';

    if (value.isEmpty || value == '—') {
      return const [];
    }

    return value
        .split(', ')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty && item != '—')
        .toList();
  }
}
