import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/domain/models/location.dart';
import 'package:charitask/modules/locations/data/services/location_service.dart';
import 'package:charitask/modules/groups/domain/models/create_group_draft.dart';
import 'package:charitask/modules/groups/domain/models/group.dart';

class GroupAssociationsStep extends StatefulWidget {
  const GroupAssociationsStep({
    super.key,
    required this.draft,
    required this.organizationId,
    required this.canManage,
    required this.onChanged,
  });

  final CreateGroupDraft draft;
  final String organizationId;
  final bool canManage;
  final VoidCallback onChanged;

  @override
  State<GroupAssociationsStep> createState() => _GroupAssociationsStepState();
}

class _GroupAssociationsStepState extends State<GroupAssociationsStep> {
  final LocationService _locationService = LocationService();

  List<Location> _locations = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    try {
      final locations = await _locationService.getLocations(
        organizationId: widget.organizationId,
      );

      if (!mounted) return;

      setState(() {
        _locations = locations
            .where(
              (location) =>
                  !(widget.draft.ownerType == GroupOwnerType.location &&
                      location.id == widget.draft.ownerId),
            )
            .toList();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Associate Locations',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const Text(
          'Optionally connect this group to additional organizational '
          'locations. The owner location is managed separately.',
          style: TextStyle(color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 20),
        if (!widget.canManage)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'You can view locations, but group management permission '
              'is required to associate them.',
              style: TextStyle(color: Color(0xFFB45309)),
            ),
          ),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_error != null)
          Text('Unable to load locations: $_error')
        else if (_locations.isEmpty)
          const Text('No additional active locations are available.')
        else
          ..._locations.map(
            (location) => CheckboxListTile(
              value: widget.draft.associatedLocationIds.contains(location.id),
              onChanged: widget.canManage
                  ? (selected) {
                      setState(() {
                        if (selected == true) {
                          widget.draft.associatedLocationIds.add(location.id);
                        } else {
                          widget.draft.associatedLocationIds.remove(
                            location.id,
                          );
                        }
                      });
                      widget.onChanged();
                    }
                  : null,
              title: Text(location.name),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFF06B6D4),
              contentPadding: EdgeInsets.zero,
            ),
          ),
      ],
    );
  }
}
