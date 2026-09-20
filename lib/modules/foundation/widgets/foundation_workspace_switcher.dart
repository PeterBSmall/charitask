import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/data/workspace/services/workspace_service.dart';

class FoundationWorkspaceSwitcher extends StatefulWidget {
  final String organizationId;
  final VoidCallback? onPersonalHome;
  final ValueChanged<Map<String, dynamic>>? onWorkspaceSelected;

  const FoundationWorkspaceSwitcher({
    super.key,
    required this.organizationId,
    this.onPersonalHome,
    this.onWorkspaceSelected,
  });

  @override
  State<FoundationWorkspaceSwitcher> createState() =>
      _FoundationWorkspaceSwitcherState();
}

class _FoundationWorkspaceSwitcherState
    extends State<FoundationWorkspaceSwitcher> {
  late final WorkspaceService _workspaceService;

  List<Map<String, dynamic>> _workspaces = [];
  bool _isLoading = true;
  String? _selectedWorkspaceId;

  @override
  void initState() {
    super.initState();

    _workspaceService = WorkspaceService(Supabase.instance.client);
    _loadWorkspaces();
  }

  Future<void> _loadWorkspaces() async {
    try {
      final workspaces = await _workspaceService.getWorkspaces(
        organizationId: widget.organizationId,
      );

      if (!mounted) return;

      setState(() {
        _workspaces = workspaces;
        _isLoading = false;

        if (workspaces.isNotEmpty) {
          _selectedWorkspaceId = workspaces.first['id'] as String?;
        }
      });
    } catch (error) {
      debugPrint('>>> LOAD ORGANIZATION WORKSPACES FAILED: $error');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Current Workspace',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF667085),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Spacer(),
              const Text(
                'Switch',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5B4BC4),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 15,
                color: Color(0xFF5B4BC4),
              ),
            ],
          ),
          const SizedBox(height: 6),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            ..._workspaces.map(
              (workspace) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _WorkspaceCard(
                  icon: Icons.workspaces_rounded,
                  title: workspace['name'] as String? ?? 'Workspace',
                  subtitle: 'Organization Workspace',
                  accentColor: const Color(0xFF5B4BC4),
                  backgroundColor: const Color(0xFFF0EDFF),
                  selected: _selectedWorkspaceId == workspace['id'],
                  onTap: () {
                    setState(() {
                      _selectedWorkspaceId = workspace['id'] as String?;
                    });

                    widget.onWorkspaceSelected?.call(workspace);
                  },
                ),
              ),
            ),

          _WorkspaceCard(
            icon: Icons.person_rounded,
            title: 'Personal Home',
            subtitle: 'Your personal hub',
            accentColor: const Color(0xFF6FA64A),
            backgroundColor: const Color(0xFFF0F7ED),
            selected: _selectedWorkspaceId == 'personal',
            onTap: () {
              setState(() {
                _selectedWorkspaceId = 'personal';
              });

              widget.onPersonalHome?.call();
            },
          ),
        ],
      ),
    );
  }
}

class _WorkspaceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final Color backgroundColor;
  final bool selected;
  final VoidCallback onTap;

  const _WorkspaceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.backgroundColor,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? accentColor.withValues(alpha: 0.18)
                  : Colors.transparent,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: Colors.white, size: 21),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF283447),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7B8494),
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
