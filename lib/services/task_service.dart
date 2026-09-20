import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/services/current_person_service.dart';
import 'package:charitask/shared/models/ct_task.dart';

class TaskService {
  TaskService(this._client);

  final SupabaseClient _client;

  Future<List<CTTask>> getTasksForWorkspace({
    required String workspaceId,
  }) async {
    final response = await _client
        .from('tasks')
        .select()
        .eq('workspace_id', workspaceId)
        .isFilter('archived_at', null)
        .order('due_at', ascending: true);

    return (response as List)
        .map((row) => CTTask.fromMap(row))
        .toList();
  }

  Future<List<CTTask>> getTasksAssignedToPerson({
    required String personId,
  }) async {
    final response = await _client
        .from('tasks')
        .select()
        .eq('assigned_to_person_id', personId)
        .isFilter('archived_at', null)
        .inFilter('status', ['open', 'in_progress'])
        .order('due_at', ascending: true);

    return (response as List)
        .map((row) => CTTask.fromMap(row))
        .toList();
  }

  Future<List<CTTask>> getTodayAndOverdueTasks({
    required String personId,
  }) async {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfTomorrow = startOfToday.add(const Duration(days: 1));

    final response = await _client
        .from('tasks')
        .select()
        .eq('assigned_to_person_id', personId)
        .isFilter('archived_at', null)
        .inFilter('status', ['open', 'in_progress'])
        .lt('due_at', startOfTomorrow.toIso8601String())
        .order('due_at', ascending: true);

    return (response as List)
        .map((row) => CTTask.fromMap(row))
        .toList();
  }

  Future<List<CTTask>> getCurrentPersonTodayAndOverdueTasks() async {
    final personId = await CurrentPersonService(_client).getPersonId();

    if (personId == null || personId.isEmpty) {
      return [];
    }

    return getTodayAndOverdueTasks(personId: personId);
  }
}
