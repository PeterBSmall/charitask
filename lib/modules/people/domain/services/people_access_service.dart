import 'package:charitask/modules/people/data/services/people_service.dart';
import 'package:charitask/modules/people/domain/models/people_access_person.dart';

enum PeopleAccessAction { assign, invite }

class PeopleAccessResult {
  final PeopleAccessAction action;
  final PeopleAccessPerson person;

  const PeopleAccessResult({required this.action, required this.person});

  bool get shouldAssign => action == PeopleAccessAction.assign;

  bool get shouldInvite => action == PeopleAccessAction.invite;
}

class PeopleAccessService {
  PeopleAccessService(this._peopleService);

  final PeopleService _peopleService;

  Future<List<PeopleAccessPerson>> searchPeople({
    required String organizationId,
    String query = '',
  }) async {
    final people = await _peopleService.getPeople(
      organizationId: organizationId,
    );

    final normalizedQuery = query.trim().toLowerCase();

    final results = people.map(PeopleAccessPerson.fromMap).where((person) {
      if (normalizedQuery.isEmpty) {
        return true;
      }

      return person.displayName.toLowerCase().contains(normalizedQuery) ||
          (person.email?.toLowerCase().contains(normalizedQuery) ?? false) ||
          person.firstName.toLowerCase().contains(normalizedQuery) ||
          person.lastName.toLowerCase().contains(normalizedQuery);
    }).toList();

    results.sort(
      (a, b) =>
          a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()),
    );

    return results;
  }

  Future<PeopleAccessResult> resolveExistingPerson(
    PeopleAccessPerson person,
  ) async {
    return PeopleAccessResult(
      action: PeopleAccessAction.assign,
      person: person,
    );
  }
}
