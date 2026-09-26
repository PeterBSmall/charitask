import 'package:flutter/material.dart';

import 'package:charitask/modules/groups/data/services/group_service.dart';
import 'package:charitask/modules/groups/domain/models/group.dart';
import 'package:charitask/modules/groups/widgets/group_card.dart';
import 'package:charitask/modules/groups/widgets/group_list_card.dart';
import 'package:charitask/modules/groups/widgets/groups_empty_state.dart';
import 'package:charitask/modules/groups/widgets/groups_filters.dart';
import 'package:charitask/modules/groups/widgets/groups_hero.dart';
import 'package:charitask/modules/groups/widgets/groups_kpi_row.dart';
import 'package:charitask/modules/groups/widgets/groups_view_toggle.dart';

class GroupsPage extends StatefulWidget {
  final String organizationId;

  const GroupsPage({super.key, required this.organizationId});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final GroupService _groupService = GroupService();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;
  List<Group> _groups = [];

  bool _showMembers = false;
  bool _isGridView = true;

  GroupType? _selectedGroupType;
  String? _selectedOwner;
  String? _selectedStatus;
  String? _selectedLocation;
  String _selectedSort = 'Name';

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadGroups() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final groups = await _groupService.getGroups(
        organizationId: widget.organizationId,
      );

      if (!mounted) return;

      setState(() {
        _groups = groups;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _groups = [];
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  List<Group> get _filteredGroups {
    Iterable<Group> result = _groups;

    final search = _searchController.text.trim().toLowerCase();

    if (search.isNotEmpty) {
      result = result.where(
        (group) =>
            group.name.toLowerCase().contains(search) ||
            (group.description?.toLowerCase().contains(search) ?? false),
      );
    }

    if (_selectedGroupType != null) {
      result = result.where((group) => group.groupType == _selectedGroupType);
    }

    if (_selectedOwner != null) {
      result = result.where(
        (group) => group.ownerType?.label == _selectedOwner,
      );
    }

    if (_selectedStatus != null) {
      final status = _selectedStatus!.toLowerCase();

      result = result.where((group) => group.status.toLowerCase() == status);
    }

    if (_selectedLocation != null) {
      result = result.where((group) => group.locationId == _selectedLocation);
    }

    final filtered = result.toList();

    switch (_selectedSort) {
      case 'Newest':
        filtered.sort(
          (a, b) => (b.createdAt ?? DateTime(1900)).compareTo(
            a.createdAt ?? DateTime(1900),
          ),
        );
        break;
      case 'Oldest':
        filtered.sort(
          (a, b) => (a.createdAt ?? DateTime(1900)).compareTo(
            b.createdAt ?? DateTime(1900),
          ),
        );
        break;
      case 'Most Members':
        filtered.sort((a, b) => b.memberCount.compareTo(a.memberCount));
        break;
      case 'Fewest Members':
        filtered.sort((a, b) => a.memberCount.compareTo(b.memberCount));
        break;
      case 'Name':
      default:
        filtered.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
    }

    return filtered;
  }

  int get _activeGroups => _groups.where((group) => group.isActive).length;

  int get _staffGroups => _groups
      .where(
        (group) =>
            group.membershipComposition.contains(GroupMembershipType.staff),
      )
      .length;

  int get _volunteerGroups => _groups
      .where(
        (group) => group.membershipComposition.contains(
          GroupMembershipType.volunteers,
        ),
      )
      .length;

  int get _programGroups => _groups
      .where((group) => group.ownerType == GroupOwnerType.program)
      .length;

  double get _averageMembers {
    if (_groups.isEmpty) return 0;

    final total = _groups.fold<int>(0, (sum, group) => sum + group.memberCount);

    return total / _groups.length;
  }

  bool get _hasActiveFilters {
    return _searchController.text.trim().isNotEmpty ||
        _selectedGroupType != null ||
        _selectedOwner != null ||
        _selectedStatus != null ||
        _selectedLocation != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: RefreshIndicator(onRefresh: _loadGroups, child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        GroupsHero(),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 620;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                compact ? 16 : 16,
                0,
                compact ? 16 : 16,
                14,
              ),
              child: compact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GroupsViewToggle(
                          showMembers: _showMembers,
                          onChanged: (showMembers) {
                            setState(() {
                              _showMembers = showMembers;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _buildAddGroupButton(compact: true),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        GroupsViewToggle(
                          showMembers: _showMembers,
                          onChanged: (showMembers) {
                            setState(() {
                              _showMembers = showMembers;
                            });
                          },
                        ),
                        const Spacer(),
                        _buildAddGroupButton(),
                      ],
                    ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GroupsKpiRow(
            activeGroups: _activeGroups,
            staffGroups: _staffGroups,
            volunteerGroups: _volunteerGroups,
            programGroups: _programGroups,
            averageMembers: _averageMembers,
          ),
        ),
        const SizedBox(height: 18),
        GroupsFilters(
          searchController: _searchController,
          selectedGroupType: _selectedGroupType,
          selectedOwner: _selectedOwner,
          selectedStatus: _selectedStatus,
          selectedLocation: _selectedLocation,
          selectedSort: _selectedSort,
          isGridView: _isGridView,
          onSearchChanged: (_) {
            setState(() {});
          },
          onGroupTypeChanged: (value) {
            setState(() {
              _selectedGroupType = value;
            });
          },
          onOwnerChanged: (value) {
            setState(() {
              _selectedOwner = value;
            });
          },
          onStatusChanged: (value) {
            setState(() {
              _selectedStatus = value;
            });
          },
          onLocationChanged: (value) {
            setState(() {
              _selectedLocation = value;
            });
          },
          onSortChanged: (value) {
            setState(() {
              _selectedSort = value;
            });
          },
          onViewChanged: (value) {
            setState(() {
              _isGridView = value;
            });
          },
        ),
        _buildGroupsContent(),
      ],
    );
  }

  Widget _buildAddGroupButton({bool compact = false}) {
    if (compact) {
      return SizedBox(
        width: 44,
        height: 44,
        child: ElevatedButton(
          onPressed: _handleAddGroup,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF06B6D4),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Icon(Icons.add, size: 21),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: _handleAddGroup,
      icon: const Icon(Icons.add, size: 20),
      label: const Text('Add Group'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF06B6D4),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildGroupsContent() {
    if (_showMembers) {
      return _buildMembersPlaceholder();
    }

    final groups = _filteredGroups;

    if (groups.isEmpty) {
      return GroupsEmptyState(
        isFiltered: _hasActiveFilters,
        onAddGroup: _handleAddGroup,
      );
    }

    if (_isGridView) {
      return _buildGrid(groups);
    }

    return _buildList(groups);
  }

  Widget _buildGrid(List<Group> groups) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 1200
              ? 3
              : constraints.maxWidth >= 760
              ? 2
              : 1;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: groups.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: columns == 1 ? 1.65 : 1.45,
            ),
            itemBuilder: (context, index) {
              final group = groups[index];

              return GroupCard(
                group: group,
                onTap: () => _openGroup(group),
                onEdit: () => _editGroup(group),
                onManageMembers: () => _manageMembers(group),
                onViewActivity: () => _viewActivity(group),
                onDuplicate: () => _duplicateGroup(group),
                onArchive: () => _archiveGroup(group),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildList(List<Group> groups) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (var index = 0; index < groups.length; index++) ...[
            GroupListCard(
              group: groups[index],
              onTap: () => _openGroup(groups[index]),
              onEdit: () => _editGroup(groups[index]),
              onManageMembers: () => _manageMembers(groups[index]),
              onViewActivity: () => _viewActivity(groups[index]),
              onDuplicate: () => _duplicateGroup(groups[index]),
              onArchive: () => _archiveGroup(groups[index]),
            ),
            if (index < groups.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  Widget _buildMembersPlaceholder() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Column(
        children: [
          Icon(Icons.people_outline, size: 42, color: Color(0xFF06B6D4)),
          SizedBox(height: 14),
          Text(
            'Members view',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Member management will be connected to the Groups membership workflow.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 120),
        const Icon(
          Icons.error_outline_rounded,
          size: 48,
          color: Color(0xFFB42318),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Unable to load groups',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF64748B)),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: _loadGroups,
            child: const Text('Try Again'),
          ),
        ),
      ],
    );
  }

  void _handleAddGroup() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create Group will be connected next.')),
    );
  }

  void _openGroup(Group group) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Open ${group.name}')));
  }

  void _editGroup(Group group) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Edit ${group.name}')));
  }

  void _manageMembers(Group group) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Manage members for ${group.name}')));
  }

  void _viewActivity(Group group) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('View activity for ${group.name}')));
  }

  void _duplicateGroup(Group group) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Duplicate ${group.name}')));
  }

  Future<void> _archiveGroup(Group group) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Archive ${group.name} will be connected next.')),
    );
  }
}
