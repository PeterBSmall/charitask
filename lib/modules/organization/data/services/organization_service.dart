import 'package:supabase_flutter/supabase_flutter.dart';

class OrganizationSummary {
  final String id;
  final String name;
  final String role;
  final String status;

  const OrganizationSummary({
    required this.id,
    required this.name,
    required this.role,
    required this.status,
  });

  bool get isActive => status == 'active';
}

class OrganizationService {
  final SupabaseClient _supabase;

  OrganizationService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  Future<List<OrganizationSummary>> getMyOrganizations() async {
    final authUser = _supabase.auth.currentUser;

    if (authUser == null) {
      throw Exception('No authenticated user found.');
    }

    // ------------------------------------------------------------
    // 1. Find the Person connected to the authenticated user.
    // ------------------------------------------------------------

    final identity = await _supabase
        .from('person_auth_identities')
        .select('person_id')
        .eq('auth_user_id', authUser.id)
        .maybeSingle();

    if (identity == null) {
      throw Exception('No person profile is linked to this account.');
    }

    final personId = identity['person_id'] as String;

    // ------------------------------------------------------------
    // 2. Get active organization memberships.
    // ------------------------------------------------------------

    final memberships = await _supabase
        .from('organization_memberships')
        .select('organization_id')
        .eq('person_id', personId)
        .eq('status', 'active');

    if (memberships.isEmpty) {
      return [];
    }

    final organizationIds = memberships
        .map((row) => row['organization_id'] as String)
        .toList();

    // ------------------------------------------------------------
    // 3. Get the organizations.
    // ------------------------------------------------------------

    final organizations = await _supabase
        .from('organizations')
        .select('id, name')
        .inFilter('id', organizationIds)
        .order('name');

    // ------------------------------------------------------------
    // 4. Get active organizational role assignments.
    // ------------------------------------------------------------

    final roleAssignments = await _supabase
        .from('organizational_role_assignments')
        .select('organization_id, organizational_role_id, is_primary')
        .eq('person_id', personId)
        .eq('status', 'active');

    final roleIds = roleAssignments
        .map((row) => row['organizational_role_id'] as String)
        .toSet()
        .toList();

    // ------------------------------------------------------------
    // 5. Get the role names.
    // ------------------------------------------------------------

    final rolesById = <String, String>{};

    if (roleIds.isNotEmpty) {
      final roles = await _supabase
          .from('organizational_roles')
          .select('id, name')
          .inFilter('id', roleIds);

      for (final role in roles) {
        final roleId = role['id'] as String;
        final roleName = role['name'] as String?;

        if (roleName != null && roleName.trim().isNotEmpty) {
          rolesById[roleId] = roleName;
        }
      }
    }

    // ------------------------------------------------------------
    // 6. Build organization summaries.
    // ------------------------------------------------------------

    final summaries = <OrganizationSummary>[];

    for (final organization in organizations) {
      final organizationId = organization['id'] as String;

      String? primaryRole;
      String? fallbackRole;

      for (final assignment in roleAssignments) {
        if (assignment['organization_id'] != organizationId) {
          continue;
        }

        final roleId = assignment['organizational_role_id'] as String;
        final roleName = rolesById[roleId];

        if (roleName == null) {
          continue;
        }

        fallbackRole ??= roleName;

        if (assignment['is_primary'] == true) {
          primaryRole = roleName;
          break;
        }
      }

      summaries.add(
        OrganizationSummary(
          id: organizationId,
          name: organization['name'] as String? ?? 'Organization',
          role: primaryRole ?? fallbackRole ?? 'Member',
          status: 'active',
        ),
      );
    }

    return summaries;
  }

  Future<String> getMyFirstName() async {
    final authUser = _supabase.auth.currentUser;

    if (authUser == null) {
      throw Exception('No authenticated user found.');
    }

    final identity = await _supabase
        .from('person_auth_identities')
        .select('person_id')
        .eq('auth_user_id', authUser.id)
        .maybeSingle();

    if (identity == null) {
      throw Exception('No person profile is linked to this account.');
    }

    final personId = identity['person_id'] as String;

    final person = await _supabase
        .from('persons')
        .select('first_name')
        .eq('id', personId)
        .maybeSingle();

    return person?['first_name'] as String? ?? '';
  }
}
