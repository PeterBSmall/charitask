import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/foundation/domain/models/functional_role.dart';
import 'package:charitask/modules/foundation/domain/models/functional_role_assignment.dart';
import 'package:charitask/modules/foundation/domain/models/functional_role_category.dart';

class FunctionalRoleService {
  final SupabaseClient _supabase;

  FunctionalRoleService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  // ---------------------------------------------------------------------------
  // Categories
  // ---------------------------------------------------------------------------

  Future<List<FunctionalRoleCategory>> getCategories({
    required String organizationId,
  }) async {
    final rows = await _supabase
        .from('functional_role_categories')
        .select()
        .eq('organization_id', organizationId)
        .eq('status', 'active')
        .isFilter('archived_at', null)
        .order('sort_order')
        .order('name');

    return rows
        .map(
          (row) =>
              FunctionalRoleCategory.fromMap(Map<String, dynamic>.from(row)),
        )
        .toList();
  }

  Future<FunctionalRoleCategory?> getCategory({
    required String organizationId,
    required String categoryId,
  }) async {
    final row = await _supabase
        .from('functional_role_categories')
        .select()
        .eq('organization_id', organizationId)
        .eq('id', categoryId)
        .maybeSingle();

    if (row == null) return null;

    return FunctionalRoleCategory.fromMap(Map<String, dynamic>.from(row));
  }

  // ---------------------------------------------------------------------------
  // Roles
  // ---------------------------------------------------------------------------

  Future<List<FunctionalRole>> getRoles({
    required String organizationId,
    String? categoryId,
    bool activeOnly = true,
  }) async {
    var query = _supabase
        .from('functional_roles')
        .select('''
          *,
          functional_role_categories(
            id,
            name,
            slug
          )
        ''')
        .eq('organization_id', organizationId);

    if (activeOnly) {
      query = query.eq('status', 'active').isFilter('archived_at', null);
    }

    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }

    final rows = await query.order('name');

    final roles = rows
        .map((row) => FunctionalRole.fromMap(Map<String, dynamic>.from(row)))
        .toList();

    if (roles.isEmpty) {
      return roles;
    }

    final counts = await _getAssignmentCounts(
      organizationId: organizationId,
      roleIds: roles.map((role) => role.id).toList(),
    );

    return roles
        .map((role) => role.copyWith(assignmentCount: counts[role.id] ?? 0))
        .toList();
  }

  Future<FunctionalRole?> getRole({
    required String organizationId,
    required String roleId,
  }) async {
    final row = await _supabase
        .from('functional_roles')
        .select('''
          *,
          functional_role_categories(
            id,
            name,
            slug
          )
        ''')
        .eq('organization_id', organizationId)
        .eq('id', roleId)
        .maybeSingle();

    if (row == null) return null;

    final role = FunctionalRole.fromMap(Map<String, dynamic>.from(row));

    final counts = await _getAssignmentCounts(
      organizationId: organizationId,
      roleIds: [roleId],
    );

    return role.copyWith(assignmentCount: counts[roleId] ?? 0);
  }

  Future<FunctionalRole> createRole({
    required String organizationId,
    required String name,
    required String slug,
    String? description,
    String? categoryId,
  }) async {
    final row = await _supabase
        .from('functional_roles')
        .insert({
          'organization_id': organizationId,
          'name': name,
          'slug': slug,
          'description': description,
          'category_id': categoryId,
        })
        .select('''
          *,
          functional_role_categories(
            id,
            name,
            slug
          )
        ''')
        .single();

    return FunctionalRole.fromMap(Map<String, dynamic>.from(row));
  }

  Future<FunctionalRole> updateRole({
    required String organizationId,
    required String roleId,
    required Map<String, dynamic> changes,
  }) async {
    final row = await _supabase
        .from('functional_roles')
        .update({...changes, 'updated_at': DateTime.now().toIso8601String()})
        .eq('organization_id', organizationId)
        .eq('id', roleId)
        .select('''
          *,
          functional_role_categories(
            id,
            name,
            slug
          )
        ''')
        .single();

    return FunctionalRole.fromMap(Map<String, dynamic>.from(row));
  }

  Future<void> archiveRole({
    required String organizationId,
    required String roleId,
  }) async {
    final now = DateTime.now().toIso8601String();

    await _supabase
        .from('functional_roles')
        .update({'status': 'inactive', 'archived_at': now, 'updated_at': now})
        .eq('organization_id', organizationId)
        .eq('id', roleId);
  }

  // ---------------------------------------------------------------------------
  // Assignments
  // ---------------------------------------------------------------------------

  Future<List<FunctionalRoleAssignment>> getAssignments({
    required String organizationId,
    String? roleId,
    String? personId,
    bool activeOnly = true,
  }) async {
    var query = _supabase
        .from('functional_role_assignments')
        .select()
        .eq('organization_id', organizationId);

    if (roleId != null) {
      query = query.eq('functional_role_id', roleId);
    }

    if (personId != null) {
      query = query.eq('person_id', personId);
    }

    if (activeOnly) {
      query = query.eq('status', 'active');
    }

    final rows = await query.order('assigned_at', ascending: false);

    return rows
        .map(
          (row) =>
              FunctionalRoleAssignment.fromMap(Map<String, dynamic>.from(row)),
        )
        .toList();
  }

  Future<FunctionalRoleAssignment?> getAssignment({
    required String organizationId,
    required String assignmentId,
  }) async {
    final row = await _supabase
        .from('functional_role_assignments')
        .select()
        .eq('organization_id', organizationId)
        .eq('id', assignmentId)
        .maybeSingle();

    if (row == null) return null;

    return FunctionalRoleAssignment.fromMap(Map<String, dynamic>.from(row));
  }

  Future<FunctionalRoleAssignment> createAssignment({
    required String organizationId,
    required String personId,
    required String functionalRoleId,
    String? workspaceId,
    DateTime? assignedAt,
    String? createdByPersonId,
  }) async {
    final row = await _supabase
        .from('functional_role_assignments')
        .insert({
          'organization_id': organizationId,
          'person_id': personId,
          'functional_role_id': functionalRoleId,
          'workspace_id': workspaceId,
          'status': 'active',
          'assigned_at': (assignedAt ?? DateTime.now()).toIso8601String(),
          'created_by_person_id': createdByPersonId,
        })
        .select()
        .single();

    return FunctionalRoleAssignment.fromMap(Map<String, dynamic>.from(row));
  }

  Future<FunctionalRoleAssignment> updateAssignment({
    required String organizationId,
    required String assignmentId,
    required Map<String, dynamic> changes,
  }) async {
    final row = await _supabase
        .from('functional_role_assignments')
        .update({...changes, 'updated_at': DateTime.now().toIso8601String()})
        .eq('organization_id', organizationId)
        .eq('id', assignmentId)
        .select()
        .single();

    return FunctionalRoleAssignment.fromMap(Map<String, dynamic>.from(row));
  }

  Future<void> endAssignment({
    required String organizationId,
    required String assignmentId,
    DateTime? endedAt,
    String? updatedByPersonId,
  }) async {
    final now = endedAt ?? DateTime.now();

    await _supabase
        .from('functional_role_assignments')
        .update({
          'status': 'inactive',
          'ended_at': now.toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'updated_by_person_id': updatedByPersonId,
        })
        .eq('organization_id', organizationId)
        .eq('id', assignmentId);
  }

  // ---------------------------------------------------------------------------
  // Counts
  // ---------------------------------------------------------------------------

  Future<Map<String, int>> _getAssignmentCounts({
    required String organizationId,
    required List<String> roleIds,
  }) async {
    if (roleIds.isEmpty) {
      return {};
    }

    final rows = await _supabase
        .from('functional_role_assignments')
        .select('functional_role_id')
        .eq('organization_id', organizationId)
        .eq('status', 'active')
        .inFilter('functional_role_id', roleIds);

    final counts = <String, int>{};

    for (final row in rows) {
      final roleId = row['functional_role_id'] as String;
      counts[roleId] = (counts[roleId] ?? 0) + 1;
    }

    return counts;
  }
}
