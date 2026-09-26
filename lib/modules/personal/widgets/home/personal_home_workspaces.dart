import 'package:flutter/material.dart';
import 'package:charitask/modules/personal/data/services/personal_workspace_service.dart';

class PersonalHomeWorkspaces extends StatelessWidget {
  final VoidCallback onCreateWorkspace;
  final void Function(Map<String, dynamic> workspace) onOpenWorkspace;

  final PersonalWorkspaceService _workspaceService = PersonalWorkspaceService();

  PersonalHomeWorkspaces({
    super.key,
    required this.onCreateWorkspace,
    required this.onOpenWorkspace,
  });

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
              onPressed: () {
                // TODO: Open the full Personal Workspaces page.
              },
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
          future: _workspaceService.getMyPersonalWorkspaces(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 190,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              debugPrint('PersonalHomeWorkspaces error: ${snapshot.error}');

              return _WorkspaceMessage(
                message: 'Workspace error: ${snapshot.error}',
              );
            }

            final workspaces = snapshot.data ?? [];

            // ===========================================================
            // NO PERSONAL WORKSPACES YET
            // ===========================================================
            if (workspaces.isEmpty) {
              return _CreateWorkspaceCard(onCreateWorkspace: onCreateWorkspace);
            }

            // ===========================================================
            // DISPLAY UP TO THREE PERSONAL WORKSPACES
            // ===========================================================
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
                      onTap: () => onOpenWorkspace(visibleWorkspaces[index]),
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

// ===========================================================================
// CREATE PERSONAL WORKSPACE EMPTY STATE
// ===========================================================================

class _CreateWorkspaceCard extends StatefulWidget {
  final VoidCallback onCreateWorkspace;

  const _CreateWorkspaceCard({required this.onCreateWorkspace});

  @override
  State<_CreateWorkspaceCard> createState() => _CreateWorkspaceCardState();
}

class _CreateWorkspaceCardState extends State<_CreateWorkspaceCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F7FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7E0FA)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE9FE),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.folder_open_rounded,
                      size: 23,
                      color: Color(0xFF6547E8),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Your First Workspace',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF273247),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Set up a personal workspace for tasks, notes, '
                          'projects, and files.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    icon: Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 20,
                    ),
                    label: Text(
                      _isExpanded ? 'Hide Setup Guide' : 'Show Details',
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF6547E8),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFE7E0FA)),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Choose a workspace template during setup, or create '
                      'a custom workspace that fits the way you work.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: Color(0xFF59677D),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  FilledButton.icon(
                    onPressed: widget.onCreateWorkspace,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Create Workspace'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF6547E8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ===========================================================================
// EMPTY / ERROR MESSAGE
// ===========================================================================

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

// ===========================================================================
// PERSONAL WORKSPACE CARD
// ===========================================================================

class _WorkspaceCard extends StatelessWidget {
  final String name;
  final String? description;
  final Color accent;
  final VoidCallback onTap;

  const _WorkspaceCard({
    required this.name,
    required this.description,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
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
                    : 'Personal workspace',
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
