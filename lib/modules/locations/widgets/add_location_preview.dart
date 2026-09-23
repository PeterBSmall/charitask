import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:charitask/shared/design_system/design_system.dart';

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
  });

  bool get _hasCoordinates =>
      latitude != null &&
      longitude != null &&
      latitude!.isFinite &&
      longitude!.isFinite;

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

                  if (selectedTags.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _buildClassification(),
                  ],

                  if (_displayAddress.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _buildAddress(),
                  ],

                  if (_hasCoordinates) ...[
                    const SizedBox(height: AppSpacing.md),
                    _buildMap(),
                  ],

                  if (_hasContactInformation) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _buildContact(),
                  ],
                ],
              ),
            ),
          ],
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
          Text(
            'Location Preview',
            style: AppTypography.title.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
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
      child: Wrap(
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.location_on, color: Color(0xFF16A34A), size: 22),
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

  bool get _hasContactInformation =>
      phone.isNotEmpty ||
      email.isNotEmpty ||
      contactName.isNotEmpty ||
      contactRole.isNotEmpty ||
      contactPhone.isNotEmpty;

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
