import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PersonalHomeWorkspaces extends StatelessWidget {
  const PersonalHomeWorkspaces({super.key});

  Future<List<Map<String, dynamic>>> _loadWorkspaces() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      return [];
    }

    // ===============================================================
    // FIND THE CHARITASK PERSON
    // ===============================================================
    final identity = await supabase
        .from('person_auth_identities')
        .select('person_id')
        .eq('auth_user_id', user.id)
        .maybeSingle();

    if (identity == null) {
      return [];
    }

    final personId = identity['person_id'] as String;

    // ===============================================================
    // FIND ACTIVE WORKSPACE MEMBERSHIPS
    // ===============================================================
    final memberships = await supabase
        .from('workspace_memberships')
        .select('workspace_id, organization_id')
        .eq('person_id', personId)
        .eq('status', 'active');

    if (memberships.isEmpty) {
      return [];
    }

    final workspaceIds = memberships
        .map((membership) => membership['workspace_id'] as String)
        .toList();

    // ===============================================================
    // LOAD ACTIVE WORKSPACES
    // ===============================================================
    final workspaces = await supabase
        .from('workspaces')
        .select('id, name, description')
        .inFilter('id', workspaceIds)
        .eq('status', 'active')
        .isFilter('archived_at', null);

    return List<Map<String, dynamic>>.from(workspaces);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===============================================================
        // SECTION HEADER
        // ===============================================================
        Row(
          children: [
            const Expanded(
              child: Text(
                'My Workspaces',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF273247),
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View All',
                style: TextStyle(
                  color: Color(0xFF6547E8),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ===============================================================
        // REAL WORKSPACE DATA
        // ===============================================================
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _loadWorkspaces(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 190,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return _WorkspaceMessage(
                message: 'Unable to load your workspaces.',
              );
            }

            final workspaces = snapshot.data ?? [];

            if (workspaces.isEmpty) {
              return const _WorkspaceMessage(
                message: 'You do not have any active workspaces yet.',
              );
            }

            // Personal Home currently displays up to three workspace cards.
            final visibleWorkspaces = workspaces.take(3).toList();

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (
                  int index = 0;
                  index < visibleWorkspaces.length;
                  index++
                ) ...[
                  if (index > 0) const SizedBox(width: 16),
                  Expanded(
                    child: _WorkspaceCard(
                      name: visibleWorkspaces[index]['name'] as String,
                      description:
                          visibleWorkspaces[index]['description'] as String?,
                      accent: _accentForIndex(index),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  static Color _accentForIndex(int index) {
    const accents = [Color(0xFF7C4DFF), Color(0xFF06B6D4), Color(0xFFE07A00)];

    return accents[index % accents.length];
  }
}

class _WorkspaceMessage extends StatelessWidget {
  final String message;

  const _WorkspaceMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7E8EE)),
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 13, color: Color(0xFF718096)),
      ),
    );
  }
}

class _WorkspaceCard extends StatelessWidget {
  final String name;
  final String? description;
  final Color accent;

  const _WorkspaceCard({
    required this.name,
    required this.description,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE7E8EE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(Icons.grid_view_rounded, color: accent, size: 24),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF273247),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description?.trim().isNotEmpty == true
                    ? description!
                    : 'Workspace',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: Color(0xFF718096),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    'Open Workspace',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(Icons.arrow_forward_rounded, size: 15, color: accent),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
