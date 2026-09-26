import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/domain/models/location.dart';
import 'package:charitask/modules/locations/data/services/location_service.dart';
import 'package:charitask/modules/locations/pages/add_location_page.dart';
import 'package:charitask/shared/design_system/design_system.dart';
import 'package:charitask/modules/locations/pages/location_details_page.dart';
import '../../../platform/authorization/authorization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:charitask/modules/people/data/services/people_service.dart';
import 'package:charitask/modules/locations/widgets/locations_hero.dart';
import 'package:charitask/modules/locations/widgets/locations_kpi_row.dart';
import 'package:charitask/modules/locations/widgets/locations_section.dart';
import 'package:charitask/modules/locations/widgets/location_filters.dart';

class LocationsPage extends StatefulWidget {
  final String organizationId;

  const LocationsPage({super.key, required this.organizationId});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  final LocationService _locationService = LocationService();
  final PeopleService _peopleService = PeopleService(Supabase.instance.client);
  final AuthorizationService _authorizationService = AuthorizationService(
    Supabase.instance.client,
  );

  bool _isLoading = true;
  bool _canCreate = false;
  bool _showAddLocation = false;
  String? _errorMessage;
  List<Location> _locations = [];
  Map<String, int> _peopleCounts = {};
  String _searchQuery = '';
  String? _selectedType;
  String? _selectedStatus;
  String? _selectedState;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final canCreate = await _authorizationService.hasPermission(
      organizationId: widget.organizationId,
      permissionKey: 'locations.create',
    );

    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final locations = await _locationService.getLocations(
        organizationId: widget.organizationId,
      );

      final peopleCounts = <String, int>{};

      final peopleCountResults = await Future.wait(
        locations.map(
          (location) => _peopleService.getActivePeopleCountForLocation(
            organizationId: widget.organizationId,
            locationId: location.id,
          ),
        ),
      );

      for (var i = 0; i < locations.length; i++) {
        peopleCounts[locations[i].id] = peopleCountResults[i];
      }

      if (!mounted) return;

      setState(() {
        _locations = locations;
        _peopleCounts = peopleCounts;

        _canCreate = canCreate;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  List<Location> get _filteredLocations {
    final query = _searchQuery.trim().toLowerCase();

    return _locations.where((location) {
      final searchable = [
        location.name,
        location.addressLine1,
        location.addressLine2,
        location.city,
        location.state,
        location.postalCode,
      ].whereType<String>().join(' ').toLowerCase();

      final matchesSearch = query.isEmpty || searchable.contains(query);

      final matchesType =
          _selectedType == null || location.locationType == _selectedType;

      final matchesStatus =
          _selectedStatus == null ||
          (_selectedStatus == 'Active'
              ? location.isActive
              : !location.isActive);

      final matchesState =
          _selectedState == null || location.state == _selectedState;

      return matchesSearch && matchesType && matchesStatus && matchesState;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedType = null;
      _selectedStatus = null;
      _selectedState = null;
    });
  }

  void _openAddLocation() {
    setState(() {
      _showAddLocation = true;
    });
  }

  void _closeAddLocation() {
    setState(() {
      _showAddLocation = false;
    });
  }

  void _openLocation(Location location) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LocationDetailsPage(
          organizationId: widget.organizationId,
          locationId: location.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F8FC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Expanded(child: _buildBody())],
      ),
    );
  }

  Widget _buildBody() {
    if (_showAddLocation) {
      return AddLocationPage(
        organizationId: widget.organizationId,
        onCancel: _closeAddLocation,
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_locations.isEmpty) {
      return _buildEmptyState();
    }

    return _buildLocationsDashboard();
  }

  Widget _buildLocationsDashboard() {
    final filteredLocations = _filteredLocations;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        LocationsHero(canCreate: _canCreate, onAddLocation: _openAddLocation),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: LocationsKpiRow(
            locations: _locations,
            peopleCounts: _peopleCounts,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: LocationFilters(
            locations: _locations,
            searchQuery: _searchQuery,
            selectedType: _selectedType,
            selectedStatus: _selectedStatus,
            selectedState: _selectedState,
            onSearchChanged: (value) {
              setState(() => _searchQuery = value);
            },
            onTypeChanged: (value) {
              setState(() => _selectedType = value);
            },
            onStatusChanged: (value) {
              setState(() => _selectedStatus = value);
            },
            onStateChanged: (value) {
              setState(() => _selectedState = value);
            },
            onClear: _clearFilters,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: LocationsSection(
            locations: filteredLocations,
            peopleCounts: _peopleCounts,
            onLocationTap: _openLocation,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFF1EDFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                size: 36,
                color: Color(0xFF5B4BC4),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('No locations yet', style: AppTypography.title),
            const SizedBox(height: 8),
            Text(
              'Add your organization\'s first location to give people, groups, and workspaces a shared place to operate.',
              textAlign: TextAlign.center,
              style: AppTypography.body,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: _openAddLocation,
              icon: const Icon(Icons.add),
              label: const Text('Add Your First Location'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFFB3261E)),
            const SizedBox(height: AppSpacing.md),
            Text('Unable to load locations', style: AppTypography.title),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'An unexpected error occurred.',
              textAlign: TextAlign.center,
              style: AppTypography.body,
            ),
            const SizedBox(height: AppSpacing.md),
            if (_canCreate)
              OutlinedButton.icon(
                onPressed: _loadLocations,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
          ],
        ),
      ),
    );
  }
}
