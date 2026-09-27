import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/domain/models/location.dart';
import 'package:charitask/modules/locations/data/services/location_service.dart';

class GroupOwnerLocationField extends StatefulWidget {
  final String organizationId;
  final String? selectedLocationId;
  final ValueChanged<Location?> onChanged;
  final VoidCallback? onCreateLocation;

  const GroupOwnerLocationField({
    super.key,
    required this.organizationId,
    required this.selectedLocationId,
    required this.onChanged,
    this.onCreateLocation,
  });

  @override
  State<GroupOwnerLocationField> createState() =>
      _GroupOwnerLocationFieldState();
}

class _GroupOwnerLocationFieldState extends State<GroupOwnerLocationField> {
  final LocationService _locationService = LocationService();

  List<Location> _locations = [];
  Location? _selectedLocation;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  @override
  void didUpdateWidget(covariant GroupOwnerLocationField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedLocationId != widget.selectedLocationId) {
      _syncSelectedLocation();
    }
  }

  Future<void> _loadLocations() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final locations = await _locationService.getLocations(
        organizationId: widget.organizationId,
      );

      if (!mounted) return;

      setState(() {
        _locations = locations;
        _loading = false;
      });

      _syncSelectedLocation();
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Unable to load locations.';
      });
    }
  }

  void _syncSelectedLocation() {
    final id = widget.selectedLocationId;

    if (id == null) {
      if (_selectedLocation != null && mounted) {
        setState(() => _selectedLocation = null);
      }
      return;
    }

    final match = _locations.where((location) => location.id == id);

    if (match.isNotEmpty && mounted) {
      setState(() => _selectedLocation = match.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return _buildField(
        child: const Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Text(
              'Loading locations...',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return _buildField(
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Unable to load locations.',
                style: TextStyle(fontSize: 13, color: Color(0xFFB91C1C)),
              ),
            ),
            TextButton(onPressed: _loadLocations, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_locations.isEmpty) {
      return _buildEmptyState();
    }

    return DropdownButtonFormField<String>(
      initialValue: widget.selectedLocationId,
      decoration: _inputDecoration(
        label: 'Owner',
        hint: 'Search locations...',
        required: true,
      ),
      isExpanded: true,
      items: _locations.map((location) {
        return DropdownMenuItem<String>(
          value: location.id,
          child: Text(location.name, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (value) {
        final location = _locations
            .where((item) => item.id == value)
            .firstOrNull;

        widget.onChanged(location);
      },
    );
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEmptyStateContent(),
                    const SizedBox(height: 12),
                    _buildCreateLocationButton(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _buildEmptyStateContent()),
                    const SizedBox(width: 16),
                    _buildCreateLocationButton(),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildEmptyStateContent() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_on_outlined, size: 20, color: Color(0xFF06B6D4)),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'No locations found yet.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF334155),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Create a location to use it as the primary owner of this group.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreateLocationButton() {
    return OutlinedButton.icon(
      onPressed: widget.onCreateLocation,
      icon: const Icon(Icons.add_location_alt_outlined, size: 17),
      label: const Text('Create New Location'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF06B6D4),
        side: const BorderSide(color: Color(0xFF67E8F9)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      ),
    );
  }

  Widget _buildField({required Widget child}) {
    return InputDecorator(
      decoration: _inputDecoration(label: 'Owner', required: true),
      child: child,
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    bool required = false,
  }) {
    return InputDecoration(
      labelText: required ? '$label *' : label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 1.5),
      ),
    );
  }
}
