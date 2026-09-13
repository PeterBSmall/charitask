import 'package:supabase_flutter/supabase_flutter.dart';

class PeopleService {
  PeopleService(this._supabase);

  final SupabaseClient _supabase;

  /// Returns all people the current user is allowed to view
  /// within the specified organization.
  ///
  /// Person identity/contact information comes from `persons`.
  /// Organizational relationships are loaded from their respective
  /// relationship tables.
  Future<List<Map<String, dynamic>>> getPeople({
    required String organizationId,
  }) async {
    final response = await _supabase
        .from('persons')
        .select('''
          id,
          first_name,
          last_name,
          preferred_name,
          email,
          phone,
          employment_type,
          status,
          organizational_role_assignments(
            id,
            organizational_role_id,
            status,
            is_primary,
            organizational_roles(
              id,
              name
            )
          ),
          group_memberships(
            id,
            group_id,
            status,
            groups(
              id,
              name
            )
          ),
          person_locations(
            id,
            location_id,
            status,
            is_primary,
            locations(
              id,
              name
            )
          )
        ''')
        .eq('organization_id', organizationId)
        .order('last_name', ascending: true);

    final rows = List<Map<String, dynamic>>.from(response);

    return rows.map((person) {
      final roleAssignments = List<Map<String, dynamic>>.from(
        person['organizational_role_assignments'] ?? const [],
      );

      final groupMemberships = List<Map<String, dynamic>>.from(
        person['group_memberships'] ?? const [],
      );

      final personLocations = List<Map<String, dynamic>>.from(
        person['person_locations'] ?? const [],
      );

      final activeRoleAssignments = roleAssignments.where((assignment) {
        return assignment['status'] == 'active';
      }).toList();

      final activeGroupMemberships = groupMemberships.where((membership) {
        return membership['status'] == 'active';
      }).toList();

      final activeLocations = personLocations.where((location) {
        return location['status'] == 'active';
      }).toList();

      String role = '—';

      if (activeRoleAssignments.isNotEmpty) {
        final primaryRoles = activeRoleAssignments.where((assignment) {
          return assignment['is_primary'] == true;
        }).toList();

        final selectedAssignment = primaryRoles.isNotEmpty
            ? primaryRoles.first
            : activeRoleAssignments.first;

        final roleData = selectedAssignment['organizational_roles'];

        if (roleData is Map<String, dynamic>) {
          final roleName = roleData['name']?.toString().trim();

          if (roleName != null && roleName.isNotEmpty) {
            role = roleName;
          }
        }
      }

      final groups = activeGroupMemberships
          .map((membership) {
            final groupData = membership['groups'];

            if (groupData is Map<String, dynamic>) {
              return groupData['name']?.toString().trim() ?? '';
            }

            return '';
          })
          .where((name) => name.isNotEmpty)
          .join(', ');

      final locations = activeLocations
          .map((location) {
            final locationData = location['locations'];

            if (locationData is Map<String, dynamic>) {
              return locationData['name']?.toString().trim() ?? '';
            }

            return '';
          })
          .where((name) => name.isNotEmpty)
          .join(', ');

      return {
        ...person,
        'role': role,
        'groups': groups.isEmpty ? '—' : groups,
        'locations': locations.isEmpty ? '—' : locations,
      };
    }).toList();
  }

  /// Creates a new person within an organization.
  Future<Map<String, dynamic>> createPerson({
    required String organizationId,
    required String firstName,
    required String lastName,
    String? preferredName,
    String? email,
    String? phone,
    String? employmentType,
  }) async {
    final response = await _supabase
        .from('persons')
        .insert({
          'organization_id': organizationId,
          'first_name': firstName,
          'last_name': lastName,
          'preferred_name': preferredName,
          'email': email,
          'phone': phone,
          'employment_type': employmentType,
        })
        .select()
        .single();

    return Map<String, dynamic>.from(response);
  }

  Future<void> createOrganizationMembership({
    required String organizationId,
    required String personId,
    required String status,
  }) async {
    await _supabase.from('organization_memberships').insert({
      'organization_id': organizationId,
      'person_id': personId,
      'status': status,
    });
  }

  /// Returns the active organizational roles available
  /// within the specified organization and category.
  Future<List<Map<String, dynamic>>> getOrganizationalRoles({
    required String organizationId,
    required String roleCategory,
  }) async {
    final response = await _supabase
        .from('organizational_roles')
        .select('id, name, role_category')
        .eq('organization_id', organizationId)
        .eq('status', 'active')
        .eq('role_category', roleCategory)
        .order('name', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Assigns an organizational role to a person.
  Future<void> createOrganizationalRoleAssignment({
    required String organizationId,
    required String personId,
    required String organizationalRoleId,
    bool isPrimary = true,
  }) async {
    await _supabase.from('organizational_role_assignments').insert({
      'organization_id': organizationId,
      'person_id': personId,
      'organizational_role_id': organizationalRoleId,
      'status': 'active',
      'is_primary': isPrimary,
    });
  }
}
