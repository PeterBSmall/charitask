import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/domain/models/location.dart';
import 'package:charitask/modules/locations/widgets/location_relationship_metric.dart';
import 'package:charitask/modules/locations/widgets/location_status_badge.dart';
import 'package:charitask/shared/design_system/design_system.dart';

class LocationCard extends StatelessWidget {
  final Location location;
  final int peopleCount;
  final VoidCallback? onTap;

  const LocationCard({
    super.key,
    required this.location,
    required this.peopleCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        hoverColor: const Color(0xFFF8F7FF),
        splashColor: const Color(0x126848D8),
        child: Ink(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              if (_hasAddress) ...[const SizedBox(height: 12), _buildAddress()],

              const SizedBox(height: 14),

              const Divider(height: 1, color: Color(0xFFE2E8F0)),

              const SizedBox(height: 14),

              _buildRelationships(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF0EBFF),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.location_on_rounded,
            color: Color(0xFF6848D8),
            size: 25,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 7),

              Wrap(
                spacing: 7,
                runSpacing: 5,
                children: [
                  _buildTypeBadge(),
                  LocationStatusBadge(isActive: location.isActive),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFF94A3B8),
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        location.locationType ?? 'Other',
        style: const TextStyle(
          color: Color(0xFF475569),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAddress() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.place_outlined, size: 17, color: Color(0xFF64748B)),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            _addressText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelationships() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: LocationRelationshipMetric(
                icon: Icons.people_outline_rounded,
                label: 'People',
                value: peopleCount.toString(),
              ),
            ),
            const Expanded(
              child: LocationRelationshipMetric(
                icon: Icons.groups_outlined,
                label: 'Groups',
                value: '—',
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            const Expanded(
              child: LocationRelationshipMetric(
                icon: Icons.volunteer_activism_outlined,
                label: 'Programs',
                value: '—',
              ),
            ),
            const Expanded(
              child: LocationRelationshipMetric(
                icon: Icons.event_outlined,
                label: 'Events',
                value: '—',
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool get _hasAddress {
    return _addressText.trim().isNotEmpty;
  }

  String get _addressText {
    final parts = <String>[
      if (location.addressLine1?.trim().isNotEmpty ?? false)
        location.addressLine1!.trim(),
      if (location.addressLine2?.trim().isNotEmpty ?? false)
        location.addressLine2!.trim(),
      if (location.city?.trim().isNotEmpty ?? false) location.city!.trim(),
      if (location.state?.trim().isNotEmpty ?? false) location.state!.trim(),
      if (location.postalCode?.trim().isNotEmpty ?? false)
        location.postalCode!.trim(),
    ];

    return parts.join(', ');
  }
}
