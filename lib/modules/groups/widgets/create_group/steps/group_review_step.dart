import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/groups/domain/models/create_group_draft.dart';
import 'package:charitask/modules/groups/domain/models/group.dart';
import 'package:charitask/modules/people/data/services/people_service.dart';
import 'package:charitask/modules/people/domain/models/people_access_person.dart';
import 'package:charitask/modules/people/domain/services/people_access_service.dart';
import 'package:charitask/modules/locations/data/services/location_service.dart';
import 'package:charitask/modules/foundation/domain/models/location.dart';

class GroupReviewStep extends StatefulWidget {
  const GroupReviewStep({
    super.key,
    required this.draft,
    required this.organizationId,
    required this.onEditStep,
  });

  final CreateGroupDraft draft;
  final String organizationId;
  final ValueChanged<int> onEditStep;

  @override
  State<GroupReviewStep> createState() => _GroupReviewStepState();
}

class _GroupReviewStepState extends State<GroupReviewStep> {
  late final PeopleAccessService _peopleService;
  final LocationService _locationService = LocationService();

  List<PeopleAccessPerson> _people = [];
  List<Location> _locations = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();

    _peopleService = PeopleAccessService(
      PeopleService(Supabase.instance.client),
    );

    _loadReviewData();
  }

  Future<void> _loadReviewData() async {
    try {
      final people = await _peopleService.searchPeople(
        organizationId: widget.organizationId,
      );

      final locations = await _locationService.getLocations(
        organizationId: widget.organizationId,
      );

      if (!mounted) return;

      setState(() {
        _people = people;
        _locations = locations;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  String _ownerName() {
    switch (widget.draft.ownerType) {
      case GroupOwnerType.organization:
        return 'Current Organization';

      case GroupOwnerType.location:
        return _locationName(widget.draft.ownerId);

      case GroupOwnerType.program:
        return 'Program selection not yet available';

      default:
        return 'Not selected';
    }
  }

  String _locationName(String? id) {
    if (id == null) return 'Not selected';

    for (final location in _locations) {
      if (location.id == id) return location.name;
    }

    return 'Location unavailable';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return _buildError();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Review Your Group',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        const Text(
          'Confirm your group details before creating it.',
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 24),

        _buildDefinitionSection(),
        const SizedBox(height: 16),

        _buildMembershipSection(),
        const SizedBox(height: 16),

        _buildAssociationsSection(),
        const SizedBox(height: 16),

        _buildVisibilitySection(),
      ],
    );
  }

  Widget _buildDefinitionSection() {
    final draft = widget.draft;

    return _section(
      title: 'Group Definition',
      step: 0,
      children: [
        _detail('Group Name', draft.name),
        _detail('Group Type', draft.groupType?.label ?? 'Not selected'),
        _detail(
          'Description',
          draft.description.trim().isEmpty
              ? 'No description provided'
              : draft.description,
        ),
        _detail(
          'Primary Association',
          draft.ownerType?.label ?? 'Not selected',
        ),
        _detail('Owner', _ownerName()),
        if (draft.attributes.isNotEmpty)
          _detail('Attributes', draft.attributes.join(', ')),
      ],
    );
  }

  Widget _buildMembershipSection() {
    final selectedPeople = _people
        .where((person) => widget.draft.memberIds.contains(person.id))
        .toList();

    return _section(
      title: 'Membership',
      step: 1,
      children: [
        if (selectedPeople.isEmpty)
          const Text('No members selected. Members can be added later.')
        else ...[
          Text(
            '${selectedPeople.length} '
            '${selectedPeople.length == 1 ? 'person' : 'people'} selected',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          ...selectedPeople.map((person) {
            final role = widget.draft.memberRoles[person.id] ?? 'member';

            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(child: Icon(Icons.person_outline)),
              title: Text(
                person.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: person.email == null
                  ? null
                  : Text(
                      person.email!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
              trailing: Text(
                role,
                style: const TextStyle(
                  color: Color(0xFF0E7490),
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildAssociationsSection() {
    final associatedLocations = widget.draft.associatedLocationIds
        .map(_locationName)
        .toList();

    return _section(
      title: 'Associations',
      step: 2,
      children: [
        if (associatedLocations.isEmpty)
          const Text('No additional locations selected.')
        else
          ...associatedLocations.map((name) => _detail('Location', name)),
      ],
    );
  }

  Widget _buildVisibilitySection() {
    return _section(
      title: 'Group Visibility',
      step: 3,
      children: [_detail('Visibility', widget.draft.visibility.label)],
    );
  }

  Widget _section({
    required String title,
    required int step,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => widget.onEditStep(step),
                child: const Text('Edit'),
              ),
            ],
          ),
          const Divider(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _detail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Unable to load the group review details.'),
          const SizedBox(height: 8),
          Text(_error ?? '', maxLines: 3, overflow: TextOverflow.ellipsis),
          TextButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _error = null;
              });
              _loadReviewData();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
