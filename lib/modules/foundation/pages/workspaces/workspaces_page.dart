import 'package:flutter/material.dart';

class WorkspacesPage extends StatelessWidget {
  const WorkspacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 64,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 28),
                    _buildWorkspaceSection(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Workspaces',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Color(0xFF263247),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Manage all your organizations and personal projects from one place.',
          style: TextStyle(fontSize: 15, color: Color(0xFF667085)),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _buildSortButton(),
            const Spacer(),
            _buildNewWorkspaceButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildSortButton() {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.sort_rounded, size: 18),
      label: const Text('Recently Active'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF475467),
        side: const BorderSide(color: Color(0xFFD0D5DD)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildNewWorkspaceButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add_rounded, size: 20),
      label: const Text('New Workspace'),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: const Color(0xFF5B4BC4),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildWorkspaceSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final crossAxisCount = width >= 1100
            ? 3
            : width >= 700
            ? 2
            : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.65,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return _WorkspaceCard(
              name: _workspaceNames[index],
              type: _workspaceTypes[index],
              initials: _workspaceInitials[index],
              description: _workspaceDescriptions[index],
              isOrganization: index == 0,
            );
          },
        );
      },
    );
  }

  static const _workspaceNames = [
    'Organization Workspace',
    'Personal Workspace',
    'Community Projects',
    'Marketing Workspace',
  ];

  static const _workspaceTypes = [
    'Organization',
    'Personal',
    'Project',
    'Project',
  ];

  static const _workspaceInitials = ['OW', 'PW', 'CP', 'MW'];

  static const _workspaceDescriptions = [
    'Manage your organization, people, groups, and foundation.',
    'Your personal workspace for tasks, projects, and notes.',
    'Collaborate on community-focused projects and initiatives.',
    'Plan campaigns, outreach, and creative work.',
  ];
}

class _WorkspaceCard extends StatefulWidget {
  final String name;
  final String type;
  final String initials;
  final String description;
  final bool isOrganization;

  const _WorkspaceCard({
    required this.name,
    required this.type,
    required this.initials,
    required this.description,
    required this.isOrganization,
  });

  @override
  State<_WorkspaceCard> createState() => _WorkspaceCardState();
}

class _WorkspaceCardState extends State<_WorkspaceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFFB8ACFF)
                : const Color(0xFFE4E7EC),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.08 : 0.035),
              blurRadius: _isHovered ? 16 : 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.isOrganization
                        ? const Color(0xFFEDE9FE)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Center(
                    child: Text(
                      widget.initials,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: widget.isOrganization
                            ? const Color(0xFF5B4BC4)
                            : const Color(0xFF475467),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF263247),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.type,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF667085),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Workspace actions',
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_horiz_rounded,
                    color: Color(0xFF667085),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Text(
                widget.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: Color(0xFF667085),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 15,
                  color: Color(0xFF98A2B3),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Active recently',
                  style: TextStyle(fontSize: 12, color: Color(0xFF667085)),
                ),
                const Spacer(),
                Text(
                  _isHovered ? 'Open →' : 'View',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5B4BC4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
