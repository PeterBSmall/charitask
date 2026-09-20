import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/foundation/domain/models/location.dart';
import 'package:charitask/modules/people/data/services/people_service.dart';
import 'package:charitask/modules/locations/data/services/location_service.dart';
import 'package:charitask/modules/locations/data/services/location_operating_hours_service.dart';
import 'package:charitask/shared/design_system/design_system.dart';
import 'package:charitask/modules/locations/pages/edit_location_page.dart';

class LocationDetailsPage extends StatefulWidget {
  final String organizationId;
  final String locationId;

  const LocationDetailsPage({
    super.key,
    required this.organizationId,
    required this.locationId,
  });

  @override
  State<LocationDetailsPage> createState() => _LocationDetailsPageState();
}

class _LocationDetailsPageState extends State<LocationDetailsPage>
    with SingleTickerProviderStateMixin {
  final LocationService _locationService = LocationService();
  final PeopleService _peopleService = PeopleService(Supabase.instance.client);
  final LocationOperatingHoursService _operatingHoursService =
      LocationOperatingHoursService();

  late final TabController _tabController;

  Location? _location;
  List<Map<String, dynamic>> _tags = [];
  List<LocationOperatingHours> _operatingHours = [];
  Map<String, dynamic>? _locationManager;
  Map<String, dynamic>? _primaryContact;

  bool _isLoading = true;
  String? _errorMessage;

  static const _tabs = [
    'Overview',
    'Groups',
    'People',
    'Workspaces',
    'Assets',
    'Activity',
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _tabs.length, vsync: this);

    _loadLocation();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final location = await _locationService.getLocation(
        locationId: widget.locationId,
        organizationId: widget.organizationId,
      );

      if (location == null) {
        throw Exception('Location not found.');
      }

      final tags = await _loadTags();

      final operatingHours = await _operatingHoursService.getOperatingHours(
        locationId: widget.locationId,
        organizationId: widget.organizationId,
      );

      Map<String, dynamic>? locationManager;
      Map<String, dynamic>? primaryContact;

      if (location.locationManagerPersonId != null) {
        locationManager = await _peopleService.getPerson(
          organizationId: widget.organizationId,
          personId: location.locationManagerPersonId!,
        );
      }

      if (location.primaryContactPersonId != null) {
        primaryContact = await _peopleService.getPerson(
          organizationId: widget.organizationId,
          personId: location.primaryContactPersonId!,
        );
      }

      if (!mounted) return;

      setState(() {
        _location = location;
        _tags = tags;
        _operatingHours = operatingHours;
        _locationManager = locationManager;
        _primaryContact = primaryContact;
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

  Future<List<Map<String, dynamic>>> _loadTags() async {
    final allTags = await _locationService.getLocationCategoryTags(
      organizationId: widget.organizationId,
    );

    final tagIds = await _locationService.getLocationTagIds(
      locationId: widget.locationId,
      organizationId: widget.organizationId,
    );

    return allTags
        .where((tag) => tagIds.contains(tag['id'] as String))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    final location = _location;

    if (location == null) {
      return _buildErrorState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(location),
        _buildTabs(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOverview(location),
              _buildPlaceholderTab('Groups'),
              _buildPlaceholderTab('People'),
              _buildPlaceholderTab('Workspaces'),
              _buildPlaceholderTab('Assets'),
              _buildPlaceholderTab('Activity'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Location location) {
    final status = _statusFor(location);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back',
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(location.name, style: AppTypography.display),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (location.locationType != null &&
                            location.locationType!.trim().isNotEmpty) ...[
                          Text(
                            location.locationType!,
                            style: AppTypography.body,
                          ),
                          const SizedBox(width: 10),
                          _statusBadge(status),
                        ] else
                          _statusBadge(status),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: () async {
                  final saved = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => EditLocationPage(
                        organizationId: widget.organizationId,
                        location: _location!,
                      ),
                    ),
                  );

                  if (!mounted) return;

                  if (saved == true) {
                    Navigator.of(context).pop(true);
                  }
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Location'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        _quickStat(icon: Icons.people_outline, label: 'People', value: '-'),
        const SizedBox(width: AppSpacing.lg),
        _quickStat(icon: Icons.groups_outlined, label: 'Groups', value: '-'),
        const SizedBox(width: AppSpacing.lg),
        _quickStat(
          icon: Icons.workspaces_outline,
          label: 'Workspaces',
          value: '-',
        ),
      ],
    );
  }

  Widget _quickStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF5B4BC4)),
        const SizedBox(width: 8),
        Text(label, style: AppTypography.body),
        const SizedBox(width: 6),
        Text(value, style: AppTypography.title),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  Widget _buildOverview(Location location) {
    return RefreshIndicator(
      onRefresh: _loadLocation,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _section('Basic Information', Icons.location_on_outlined, [
            _infoRow('Location Name', location.name),
            _infoRow('Location Type', location.locationType),
            _infoRow('Description', location.description),
          ]),
          const SizedBox(height: AppSpacing.md),
          _section('Location Tags', Icons.local_offer_outlined, [
            if (_tags.isEmpty)
              _emptyValue('No location tags assigned.')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags.map((tag) {
                  return Chip(label: Text(tag['name'] as String));
                }).toList(),
              ),
          ]),
          const SizedBox(height: AppSpacing.md),
          _section('Address', Icons.home_work_outlined, [
            _infoRow('Address', location.fullAddress),
          ]),
          const SizedBox(height: AppSpacing.md),
          _section('Contact Information', Icons.contact_phone_outlined, [
            _infoRow('Contact Name', location.contactName),
            _infoRow('Phone', location.phone),
            _infoRow('Email', location.email),
          ]),
          const SizedBox(height: AppSpacing.md),
          _section('Management', Icons.manage_accounts_outlined, [
            _buildPersonInfo('Location Manager', _locationManager),
            const SizedBox(height: 16),
            _buildPersonInfo('Primary Contact', _primaryContact),
          ]),
          const SizedBox(height: AppSpacing.md),
          _section('Capacity', Icons.groups_2_outlined, [
            _infoRow(
              'Building Capacity',
              _formatNumber(location.buildingCapacity),
            ),
            _infoRow('Parking Spaces', _formatNumber(location.parkingSpaces)),
            _infoRow(
              'Volunteer Capacity',
              _formatNumber(location.volunteerCapacity),
            ),
          ]),
          const SizedBox(height: AppSpacing.md),
          _section('Operating Hours', Icons.schedule_outlined, [
            _buildOperatingHours(),
          ]),
          const SizedBox(height: AppSpacing.md),
          _section('Additional Details', Icons.info_outline, [
            _infoRow('Latitude', _formatCoordinate(location.latitude)),
            _infoRow('Longitude', _formatCoordinate(location.longitude)),
            _infoRow('Timezone', location.timezone),
          ]),
          const SizedBox(height: AppSpacing.md),
          _section('Internal Notes', Icons.notes_outlined, [
            _infoRow('Notes', location.internalNotes),
          ]),
        ],
      ),
    );
  }

  Widget _buildPersonInfo(String label, Map<String, dynamic>? person) {
    if (person == null) {
      return _infoRow(label, 'Not assigned');
    }

    final preferredName = person['preferred_name']?.toString().trim();
    final firstName = person['first_name']?.toString().trim() ?? '';
    final lastName = person['last_name']?.toString().trim() ?? '';

    final firstDisplayName = preferredName != null && preferredName.isNotEmpty
        ? preferredName
        : firstName;

    final fullName = [
      firstDisplayName,
      lastName,
    ].where((value) => value.isNotEmpty).join(' ');

    final phone = person['phone']?.toString().trim();
    final email = person['email']?.toString().trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          fullName.isEmpty ? 'Unnamed person' : fullName,
          style: AppTypography.body,
        ),
        if (phone != null && phone.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(phone, style: AppTypography.body),
        ],
        if (email != null && email.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(email, style: AppTypography.body),
        ],
      ],
    );
  }

  Widget _buildOperatingHours() {
    const dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    if (_operatingHours.isEmpty) {
      return _emptyValue('Operating hours have not been configured.');
    }

    final hoursByDay = {
      for (final hours in _operatingHours) hours.dayOfWeek: hours,
    };

    return Column(
      children: List.generate(7, (index) {
        final dayOfWeek = index + 1;
        final hours = hoursByDay[dayOfWeek];

        String value;

        if (hours == null) {
          value = 'Not configured';
        } else if (hours.isClosed) {
          value = 'Closed';
        } else {
          value =
              '${_formatTime(hours.opensAt)} ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã…â€œ ${_formatTime(hours.closesAt)}';
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  dayNames[index],
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(child: Text(value, style: AppTypography.body)),
            ],
          ),
        );
      }),
    );
  }

  String _formatTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Not configured';
    }

    final parts = value.split(':');

    if (parts.length < 2) {
      return value;
    }

    final hour = int.tryParse(parts[0]);

    if (hour == null) {
      return value;
    }

    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0
        ? 12
        : hour > 12
        ? hour - 12
        : hour;

    return '$displayHour:$minute $period';
  }

  Widget _buildPlaceholderTab(String title) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_iconForTab(title), size: 48, color: const Color(0xFF5B4BC4)),
            const SizedBox(height: AppSpacing.md),
            Text('$title coming next', style: AppTypography.title),
            const SizedBox(height: 8),
            Text(
              'This section will be connected as its related module is built.',
              textAlign: TextAlign.center,
              style: AppTypography.body,
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, IconData icon, List<Widget> children) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF5B4BC4)),
                const SizedBox(width: 10),
                Text(title, style: AppTypography.title),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    final hasValue = value != null && value.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              hasValue ? value : 'Not provided',
              style: AppTypography.body,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyValue(String text) {
    return Text(text, style: AppTypography.body);
  }

  Widget _statusBadge(String status) {
    Color background;
    Color foreground;

    switch (status) {
      case 'Archived':
        background = const Color(0xFFFFE8E8);
        foreground = const Color(0xFFB3261E);
        break;
      case 'Inactive':
        background = const Color(0xFFFFF4CC);
        foreground = const Color(0xFF8A6200);
        break;
      default:
        background = const Color(0xFFE5F6E9);
        foreground = const Color(0xFF247A3D);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: foreground,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _statusFor(Location location) {
    if (location.archivedAt != null) {
      return 'Archived';
    }

    if (!location.isActive) {
      return 'Inactive';
    }

    return 'Active';
  }

  String _formatNumber(int? value) {
    if (value == null) return 'Not provided';
    return value.toString();
  }

  String _formatCoordinate(double? value) {
    if (value == null) return 'Not provided';
    return value.toStringAsFixed(6);
  }

  IconData _iconForTab(String title) {
    switch (title) {
      case 'Groups':
        return Icons.groups_outlined;
      case 'People':
        return Icons.people_outline;
      case 'Workspaces':
        return Icons.workspaces_outline;
      case 'Assets':
        return Icons.inventory_2_outlined;
      case 'Activity':
        return Icons.history_outlined;
      default:
        return Icons.info_outline;
    }
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
            Text('Unable to load location', style: AppTypography.title),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'An unexpected error occurred.',
              textAlign: TextAlign.center,
              style: AppTypography.body,
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: _loadLocation,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
