import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/foundation/domain/models/location.dart';
import 'package:charitask/modules/groups/data/services/group_membership_service.dart';
import 'package:charitask/modules/groups/data/services/group_service.dart';
import 'package:charitask/modules/groups/domain/models/group.dart';
import 'package:charitask/modules/locations/data/services/location_service.dart';
import 'package:charitask/modules/people/widgets/edit_person/edit_person_assignment_history.dart';
import 'package:charitask/modules/people/widgets/edit_person/edit_person_functional_roles_panel.dart';
import 'package:charitask/modules/people/widgets/edit_person/edit_person_groups.dart';
import 'package:charitask/modules/people/widgets/edit_person/edit_person_locations.dart';
import 'package:charitask/platform/authorization/authorization_service.dart';

class EditPersonOrganizationalAssignments extends StatefulWidget {
  const EditPersonOrganizationalAssignments({
    super.key,
    required this.organizationId,
    required this.personId,
    required this.canViewGroups,
    required this.functionalRolesAvailable,
    required this.canManageFunctionalRoles,
    required this.canViewFunctionalRoles,
  });

  final String organizationId;
  final String personId;
  final bool canViewGroups;
  final bool functionalRolesAvailable;
  final bool canManageFunctionalRoles;
  final bool canViewFunctionalRoles;

  @override
  State<EditPersonOrganizationalAssignments> createState() =>
      _EditPersonOrganizationalAssignmentsState();
}

class _EditPersonOrganizationalAssignmentsState
    extends State<EditPersonOrganizationalAssignments> {
  late final GroupService _groupService;
  late final GroupMembershipService _membershipService;
  late final AuthorizationService _authorization;
  late final LocationService _locationService;

  bool _isLoadingGroups = true;
  bool _isLoadingLocations = true;

  bool _canManageGroups = false;
  bool _canViewLocations = false;
  bool _canManageLocations = false;

  String _selectedTab = 'groups';

  String? _groupLoadError;
  String? _locationLoadError;

  List<Group> _availableGroups = [];
  List<Map<String, dynamic>> _memberships = [];

  List<Location> _availableLocations = [];
  List<Map<String, dynamic>> _locationAssignments = [];

  @override
  void initState() {
    super.initState();

    final supabase = Supabase.instance.client;

    _groupService = GroupService(supabase: supabase);
    _membershipService = GroupMembershipService(supabase: supabase);
    _locationService = LocationService(supabase: supabase);
    _authorization = AuthorizationService(supabase);

    _initialize();
  }

  Future<void> _initialize() async {
    if (widget.canViewGroups) {
      try {
        _canManageGroups = await _authorization.hasPermission(
          organizationId: widget.organizationId,
          permissionKey: 'groups.manage',
        );

        await _loadGroupData();
      } catch (error) {
        debugPrint('Group membership initialization failed: $error');
        _groupLoadError = 'Group memberships could not be loaded.';
      } finally {
        _isLoadingGroups = false;
      }
    } else {
      _isLoadingGroups = false;
    }

    try {
      final permissions = await Future.wait([
        _authorization.hasPermission(
          organizationId: widget.organizationId,
          permissionKey: 'people.view',
        ),
        _authorization.hasPermission(
          organizationId: widget.organizationId,
          permissionKey: 'locations.view',
        ),
        _authorization.hasPermission(
          organizationId: widget.organizationId,
          permissionKey: 'people.edit',
        ),
      ]);

      // person_locations and locations have separate SELECT policies.
      _canViewLocations = permissions[0] && permissions[1];
      _canManageLocations = _canViewLocations && permissions[2];

      if (_canViewLocations) {
        await _loadLocationData();
      }
    } catch (error) {
      debugPrint('Location assignment initialization failed: $error');
      _locationLoadError = 'Location assignments could not be loaded.';
    } finally {
      _isLoadingLocations = false;
    }

    if (widget.canViewGroups) {
      _selectedTab = 'groups';
    } else if (_canViewLocations) {
      _selectedTab = 'locations';
    } else if (widget.canViewFunctionalRoles) {
      _selectedTab = 'roles';
    } else if (widget.functionalRolesAvailable) {
      _selectedTab = 'roles';
    } else {
      _selectedTab = 'history';
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadGroupData() async {
    final results = await Future.wait([
      _groupService.getGroups(organizationId: widget.organizationId),
      _membershipService.getPersonMemberships(
        organizationId: widget.organizationId,
        personId: widget.personId,
      ),
    ]);

    _availableGroups = results[0] as List<Group>;
    _memberships = results[1] as List<Map<String, dynamic>>;
    _groupLoadError = null;
  }

  Future<void> _refreshGroups() async {
    if (mounted) {
      setState(() {
        _isLoadingGroups = true;
        _groupLoadError = null;
      });
    }

    try {
      await _loadGroupData();
    } catch (error) {
      debugPrint('Group membership refresh failed: $error');
      _groupLoadError = 'Group memberships could not be refreshed.';
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingGroups = false;
        });
      }
    }
  }

  Future<void> _addGroup(String groupId) async {
    if (!widget.canViewGroups || !_canManageGroups) return;

    try {
      await _membershipService.addMember(
        organizationId: widget.organizationId,
        groupId: groupId,
        personId: widget.personId,
      );

      if (!mounted) return;

      _showMessage('Group membership added.');
      await _refreshGroups();
    } catch (error) {
      debugPrint('Group assignment failed: $error');
      _showMessage('Unable to assign this person to the group.');
    }
  }

  Future<void> _endMembership(String membershipId) async {
    if (!widget.canViewGroups || !_canManageGroups) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('End group membership?'),
        content: const Text(
          'This will end the membership but preserve its history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('End Membership'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await _membershipService.endMembership(
        organizationId: widget.organizationId,
        membershipId: membershipId,
      );

      if (!mounted) return;

      _showMessage('Group membership ended.');
      await _refreshGroups();
    } catch (error) {
      debugPrint('Ending group membership failed: $error');
      _showMessage('Unable to end this group membership.');
    }
  }

  Future<void> _loadLocationData() async {
    final locations = await _locationService.getLocations(
      organizationId: widget.organizationId,
    );

    final assignments = await _locationService.getPersonLocationAssignments(
      organizationId: widget.organizationId,
      personId: widget.personId,
    );

    _availableLocations = locations;
    _locationAssignments = assignments;
    _locationLoadError = null;
  }

  Future<void> _refreshLocations() async {
    if (mounted) {
      setState(() {
        _isLoadingLocations = true;
        _locationLoadError = null;
      });
    }

    try {
      await _loadLocationData();
    } catch (error) {
      debugPrint('Location assignment refresh failed: $error');
      _locationLoadError = 'Location assignments could not be refreshed.';
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocations = false;
        });
      }
    }
  }

  Future<void> _assignLocation(String locationId, bool makePrimary) async {
    if (!_canViewLocations || !_canManageLocations) return;

    try {
      await _locationService.assignPersonToLocation(
        organizationId: widget.organizationId,
        personId: widget.personId,
        locationId: locationId,
        makePrimary: makePrimary,
      );

      await _refreshLocations();
      _showMessage('Location assigned.');
    } catch (error) {
      debugPrint('Location assignment failed: $error');
      _showMessage('Unable to assign this location.');
    }
  }

  Future<void> _setPrimaryLocation(String locationId) async {
    if (!_canViewLocations || !_canManageLocations) return;

    await _assignLocation(locationId, true);
  }

  Future<void> _endLocationAssignment(String assignmentId) async {
    if (!_canViewLocations || !_canManageLocations) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('End location assignment?'),
        content: const Text(
          'This will end the assignment while preserving its history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('End Assignment'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await _locationService.endPersonLocationAssignment(
        organizationId: widget.organizationId,
        assignmentId: assignmentId,
      );

      await _refreshLocations();
      _showMessage('Location assignment ended.');
    } catch (error) {
      debugPrint('Ending location assignment failed: $error');
      _showMessage('Unable to end this location assignment.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final canViewHistory =
        widget.canViewGroups ||
        _canViewLocations ||
        widget.canViewFunctionalRoles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (widget.canViewGroups)
              ChoiceChip(
                label: const Text('Groups'),
                selected: _selectedTab == 'groups',
                onSelected: (_) {
                  setState(() {
                    _selectedTab = 'groups';
                  });
                },
              ),
            if (_canViewLocations)
              ChoiceChip(
                label: const Text('Locations'),
                selected: _selectedTab == 'locations',
                onSelected: (_) {
                  setState(() {
                    _selectedTab = 'locations';
                  });
                },
              ),
            if (widget.functionalRolesAvailable)
              ChoiceChip(
                label: const Text('Functional Roles'),
                selected: _selectedTab == 'roles',
                onSelected: (_) {
                  setState(() {
                    _selectedTab = 'roles';
                  });
                },
              ),
            if (canViewHistory)
              ChoiceChip(
                label: const Text('Assignment History'),
                selected: _selectedTab == 'history',
                onSelected: (_) {
                  setState(() {
                    _selectedTab = 'history';
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: 20),

        // Groups panel
        if (_selectedTab == 'groups' && widget.canViewGroups)
          if (_isLoadingGroups)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_groupLoadError != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_groupLoadError!, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _refreshGroups,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            )
          else
            EditPersonGroups(
              memberships: _memberships,
              availableGroups: _availableGroups,
              canManage: _canManageGroups,
              onAddGroup: _addGroup,
              onEndMembership: _endMembership,
            ),

        // Locations panel
        if (_selectedTab == 'locations' && _canViewLocations)
          if (_isLoadingLocations)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_locationLoadError != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_locationLoadError!, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _refreshLocations,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            )
          else
            EditPersonLocations(
              assignments: _locationAssignments,
              availableLocations: _availableLocations,
              canManage: _canManageLocations,
              onAssignLocation: _assignLocation,
              onSetPrimary: _setPrimaryLocation,
              onEndAssignment: _endLocationAssignment,
            ),

        // Functional Roles panel
        if (_selectedTab == 'roles' && widget.functionalRolesAvailable)
          EditPersonFunctionalRolesPanel(
            organizationId: widget.organizationId,
            personId: widget.personId,
            canManage: widget.canManageFunctionalRoles,
          ),

        // Assignment History
        if (_selectedTab == 'history' && canViewHistory)
          EditPersonAssignmentHistory(
            organizationId: widget.organizationId,
            personId: widget.personId,
            canViewGroups: widget.canViewGroups,
            canViewLocations: _canViewLocations,
            canViewFunctionalRoles: widget.canViewFunctionalRoles,
          ),
      ],
    );
  }
}
