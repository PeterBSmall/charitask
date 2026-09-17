import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/domain/models/location.dart';
import 'package:charitask/modules/locations/data/services/location_service.dart';
import 'package:charitask/modules/locations/pages/add_location_page.dart';
import 'package:charitask/shared/design_system/design_system.dart';
import 'package:charitask/modules/locations/pages/location_details_page.dart';

class LocationsPage extends StatefulWidget {
  final String organizationId;

  const LocationsPage({super.key, required this.organizationId});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  final LocationService _locationService = LocationService();

  bool _isLoading = true;
  String? _errorMessage;
  List<Location> _locations = [];

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final locations = await _locationService.getLocations(
        organizationId: widget.organizationId,
      );

      if (!mounted) return;

      setState(() {
        _locations = locations;
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

  Future<void> _openAddLocation() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddLocationPage(organizationId: widget.organizationId),
      ),
    );

    if (created == true && mounted) {
      await _loadLocations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F8FC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Locations', style: AppTypography.display),
                const SizedBox(height: 4),
                Text(
                  'Manage the places where your organization operates, serves, and gathers.',
                  style: AppTypography.body,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          FilledButton.icon(
            onPressed: _openAddLocation,
            icon: const Icon(Icons.add),
            label: const Text('Add Location'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_locations.isEmpty) {
      return _buildEmptyState();
    }

    return _buildLocationList();
  }

  Widget _buildLocationList() {
    return RefreshIndicator(
      onRefresh: _loadLocations,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        itemCount: _locations.length,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (context, index) {
          return _LocationCard(
            location: _locations[index],
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LocationDetailsPage(
                    organizationId: widget.organizationId,
                    locationId: _locations[index].id,
                  ),
                ),
              );
            },
          );
        },
      ),
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

class _LocationCard extends StatelessWidget {
  final Location location;
  final VoidCallback onTap;

  const _LocationCard({required this.location, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1EDFF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFF5B4BC4),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(location.name, style: AppTypography.title),
                    if (location.locationType != null &&
                        location.locationType!.trim().isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(location.locationType!, style: AppTypography.body),
                    ],
                    if (location.fullAddress.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(location.fullAddress, style: AppTypography.body),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const Icon(Icons.chevron_right, color: Color(0xFF7A7A85)),
            ],
          ),
        ),
      ),
    );
  }
}
