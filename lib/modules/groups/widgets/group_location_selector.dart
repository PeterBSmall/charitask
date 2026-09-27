import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/domain/models/location.dart';
import 'package:charitask/modules/locations/data/services/location_service.dart';

class GroupLocationSelector extends StatefulWidget {
  final String organizationId;
  final Set<String> selectedLocationIds;
  final ValueChanged<Set<String>> onChanged;

  const GroupLocationSelector({
    super.key,
    required this.organizationId,
    required this.selectedLocationIds,
    required this.onChanged,
  });

  @override
  State<GroupLocationSelector> createState() => _GroupLocationSelectorState();
}

class _GroupLocationSelectorState extends State<GroupLocationSelector> {
  final LocationService _locationService = LocationService();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;
  List<Location> _locations = [];

  @override
  void initState() {
    super.initState();
    _loadLocations();
    _searchController.addListener(_handleSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    super.dispose();
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
        _locations = [];
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  void _handleSearchChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  List<Location> get _filteredLocations {
    final search = _searchController.text.trim().toLowerCase();

    if (search.isEmpty) {
      return _locations;
    }

    return _locations.where((location) {
      final name = location.name.toLowerCase();
      final type = (location.locationType ?? '').toLowerCase();
      final address = location.fullAddress.toLowerCase();

      return name.contains(search) ||
          type.contains(search) ||
          address.contains(search);
    }).toList();
  }

  void _toggleLocation(Location location) {
    final updated = Set<String>.from(widget.selectedLocationIds);

    if (updated.contains(location.id)) {
      updated.remove(location.id);
    } else {
      updated.add(location.id);
    }

    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildSearchField(),
        const SizedBox(height: 12),
        _buildContent(),
      ],
    );
  }

  Widget _buildHeader() {
    final count = widget.selectedLocationIds.length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Associated Locations',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Connect this group to one or more locations in your organization.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        if (count > 0) ...[
          const SizedBox(width: 12),
          _buildSelectedCount(count),
        ],
      ],
    );
  }

  Widget _buildSelectedCount(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE6FAFD),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFB8EEF5)),
      ),
      child: Text(
        '$count selected',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0891B2),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search locations...',
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 20,
          color: Color(0xFF64748B),
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                tooltip: 'Clear search',
                onPressed: _searchController.clear,
                icon: const Icon(Icons.close_rounded, size: 18),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
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
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Color(0xFF06B6D4),
            ),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildMessage(
        icon: Icons.error_outline_rounded,
        title: 'Unable to load locations',
        message: 'Please try again.',
        actionLabel: 'Retry',
        onAction: _loadLocations,
      );
    }

    final locations = _filteredLocations;

    if (_locations.isEmpty) {
      return _buildMessage(
        icon: Icons.location_off_outlined,
        title: 'No active locations',
        message:
            'Add an active location to your organization before associating it with this group.',
      );
    }

    if (locations.isEmpty) {
      return _buildMessage(
        icon: Icons.search_off_rounded,
        title: 'No locations found',
        message: 'Try a different search.',
      );
    }

    return Column(
      children: locations
          .map(
            (location) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildLocationTile(location),
            ),
          )
          .toList(),
    );
  }

  Widget _buildLocationTile(Location location) {
    final selected = widget.selectedLocationIds.contains(location.id);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _toggleLocation(location),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFE6FAFD) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFF06B6D4)
                  : const Color(0xFFE2E8F0),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              _buildCheckbox(selected),
              const SizedBox(width: 12),
              _buildLocationIcon(selected),
              const SizedBox(width: 12),
              Expanded(child: _buildLocationDetails(location)),
              const SizedBox(width: 8),
              _buildTypeBadge(location),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(bool selected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF06B6D4) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: selected ? const Color(0xFF06B6D4) : const Color(0xFFCBD5E1),
          width: 1.5,
        ),
      ),
      child: selected
          ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
          : null,
    );
  }

  Widget _buildLocationIcon(bool selected) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFCFF7FC) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.location_on_outlined,
        size: 20,
        color: selected ? const Color(0xFF0891B2) : const Color(0xFF64748B),
      ),
    );
  }

  Widget _buildLocationDetails(Location location) {
    final address = location.fullAddress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          location.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        if (address.isNotEmpty) ...[
          const SizedBox(height: 3),
          Text(
            address,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              height: 1.3,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTypeBadge(Location location) {
    final type = _formatLocationType(location.locationType);

    if (type.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 120),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFA),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        type,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F766E),
        ),
      ),
    );
  }

  Widget _buildMessage({
    required IconData icon,
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: const Color(0xFF64748B)),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Color(0xFF64748B),
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 12),
            TextButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ],
      ),
    );
  }

  String _formatLocationType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }

    return value
        .split('_')
        .map(
          (part) => part.isEmpty
              ? part
              : '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
