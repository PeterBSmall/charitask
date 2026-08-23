import '../../domain/repositories/people_repository.dart';
import '../services/people_service.dart';

class PeopleRepositoryImpl implements PeopleRepository {
  PeopleRepositoryImpl(this._service);

  final PeopleService _service;

  @override
  Future<List<Map<String, dynamic>>> getPeople() {
    return _service.getPeople();
  }
}
