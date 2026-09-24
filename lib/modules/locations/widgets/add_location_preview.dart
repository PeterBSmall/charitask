import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:charitask/shared/widgets/operating_hours/ct_operating_hours_day.dart';
import 'package:charitask/shared/design_system/design_system.dart';
import 'package:charitask/modules/locations/widgets/add_location_preview_hours.dart';

class AddLocationPreview extends StatelessWidget {
  final String name;
  final String? locationType;
  final bool isActive;
  final List<String> selectedTags;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String phone;
  final String email;
  final String contactName;
  final String contactRole;
  final String contactPhone;
  final double? latitude;
  final double? longitude;
  final List<CTOperatingHoursDay> operatingHours;

  const AddLocationPreview({
    super.key,
    required this.name,
    required this.locationType,
    required this.isActive,
    required this.selectedTags,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.phone,
    required this.email,
    required this.contactName,
    required this.contactRole,
    required this.contactPhone,
    required this.latitude,
    required this.longitude,
    required this.operatingHours,
  });

  bool get _hasCoordinates =>
      latitude != null &&
      longitude != null &&
      latitude!.isFinite &&
      longitude!.isFinite;

  bool get _hasContactInformation =>
      phone.isNotEmpty ||
      email.isNotEmpty ||
      contactName.isNotEmpty ||
      contactRole.isNotEmpty ||
      contactPhone.isNotEmpty;

  String get _displayName => name.isNotEmpty ? name : 'Your Location Name';

  String get _displayType {
    if (locationType == null || locationType!.isEmpty) {
      return 'Location Type';
    }

    return locationType!;
  }

  String get _displayAddress {
    final lines = <String>[];

    if (address.isNotEmpty) {
      lines.add(address);
    }

    final cityStateZip = [
      if (city.isNotEmpty) city,
      if (state.isNotEmpty) state,
      if (postalCode.isNotEmpty) postalCode,
    ].join(', ').replaceFirst(RegExp(r', ([A-Z]{2}),'), ', ');

    if (cityStateZip.isNotEmpty) {
      lines.add(cityStateZip);
    }

    return lines.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLocationIdentity(),

                    const SizedBox(height: AppSpacing.lg),

                    _buildClassification(),

                    const SizedBox(height: AppSpacing.lg),

                    _buildAddress(),

                    if (_hasCoordinates) ...[
                      const SizedBox(height: AppSpacing.md),
                      _buildMap(),
                    ] else ...[
                      const SizedBox(height: AppSpacing.md),
                      _buildMapPlaceholder(),
                    ],

                    if (_hasContactInformation) ...[
                      const SizedBox(height: AppSpacing.lg),
                      _buildContact(),
                    ] else ...[
                      const SizedBox(height: AppSpacing.lg),
                      _buildEmptyContact(),
                    ],

                    const SizedBox(height: AppSpacing.lg),

                    AddLocationPreviewHours(operatingHours: operatingHours),

                    const SizedBox(height: AppSpacing.lg),

                    _buildRelationshipNotice(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF0FDF4),
        border: Border(bottom: BorderSide(color: Color(0xFFDCFCE7))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.visibility_outlined,
              color: Color(0xFF15803D),
              size: 21,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location Preview',
                  style: AppTypography.title.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'This is how your location will appear after creation.',
                  style: AppTypography.caption.copyWith(
                    color: const Color(0xFF64748B),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationIdentity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _displayName,
          style: AppTypography.title.copyWith(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildBadge(
              icon: isActive
                  ? Icons.check_circle_outline
                  : Icons.pause_circle_outline,
              label: isActive ? 'Active' : 'Inactive',
              backgroundColor: isActive
                  ? const Color(0xFFDCFCE7)
                  : const Color(0xFFF3F4F6),
              foregroundColor: isActive
                  ? const Color(0xFF166534)
                  : const Color(0xFF4B5563),
            ),
            _buildBadge(
              icon: Icons.storefront_outlined,
              label: _displayType,
              backgroundColor: const Color(0xFFEDE9FE),
              foregroundColor: const Color(0xFF6D28D9),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: foregroundColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassification() {
    return _buildSection(
      icon: Icons.sell_outlined,
      title: 'Classification',
      child: selectedTags.isEmpty
          ? _buildSectionPlaceholder(
              'Location tags will appear here.',
              Icons.sell_outlined,
            )
          : Wrap(
              spacing: 7,
              runSpacing: 7,
              children: selectedTags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F3FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE9D5FF)),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Color(0xFF6D28D9),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  Widget _buildAddress() {
    return _buildSection(
      icon: Icons.location_on_outlined,
      title: 'Address',
      child: _displayAddress.isEmpty
          ? _buildSectionPlaceholder(
              'Address details will appear here.',
              Icons.location_on_outlined,
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.location_on,
                    color: Color(0xFF16A34A),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    _displayAddress,
                    style: const TextStyle(
                      color: Color(0xFF374151),
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F7F1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.map_outlined,
              color: Color(0xFF16A34A),
              size: 23,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Location map',
            style: TextStyle(
              color: Color(0xFF475569),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'A map will appear when an address is selected.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    final point = LatLng(latitude!, longitude!);

    return Container(
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      clipBehavior: Clip.antiAlias,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: point,
          initialZoom: 15,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.charitask.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: point,
                width: 44,
                height: 44,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          RichAttributionWidget(
            attributions: [TextSourceAttribution('OpenStreetMap contributors')],
          ),
        ],
      ),
    );
  }

  Widget _buildContact() {
    return _buildSection(
      icon: Icons.contact_phone_outlined,
      title: 'Contact',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (contactName.isNotEmpty) ...[
            Text(
              contactName,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (contactRole.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                contactRole,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
            ],
          ],
          if (phone.isNotEmpty) ...[
            if (contactName.isNotEmpty) const SizedBox(height: 9),
            _buildContactLine(Icons.phone_outlined, phone),
          ],
          if (contactPhone.isNotEmpty) ...[
            if (phone.isNotEmpty || contactName.isNotEmpty)
              const SizedBox(height: 6),
            _buildContactLine(Icons.person_outline, contactPhone),
          ],
          if (email.isNotEmpty) ...[
            const SizedBox(height: 6),
            _buildContactLine(Icons.email_outlined, email),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyContact() {
    return _buildSection(
      icon: Icons.contact_phone_outlined,
      title: 'Contact',
      child: _buildSectionPlaceholder(
        'Contact information will appear here.',
        Icons.contact_phone_outlined,
      ),
    );
  }

  Widget _buildContactLine(IconData icon, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Color(0xFF475569), fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionPlaceholder(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipNotice() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F7F1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hub_outlined,
                  size: 17,
                  color: Color(0xFF16A34A),
                ),
              ),
              const SizedBox(width: 9),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connected to your organization',
                      style: TextStyle(
                        color: Color(0xFF334155),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'After creation, you can connect people, programs, events, and assets to this location.',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildRelationshipChip(Icons.people_outline, 'People'),
              _buildRelationshipChip(Icons.work_outline, 'Programs'),
              _buildRelationshipChip(Icons.event_outlined, 'Events'),
              _buildRelationshipChip(Icons.inventory_2_outlined, 'Assets'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF64748B)),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF64748B)),
            const SizedBox(width: 7),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF475569),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        child,
      ],
    );
  }
}
