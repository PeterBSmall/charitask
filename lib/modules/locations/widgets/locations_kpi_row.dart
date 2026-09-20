import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/domain/models/location.dart';
import 'package:charitask/modules/locations/widgets/locations_kpi_card.dart';
import 'package:charitask/shared/design_system/design_system.dart';

class LocationsKpiRow extends StatelessWidget {
  final List<Location> locations;
  final Map<String, int> peopleCounts;

  const LocationsKpiRow({
    super.key,
    required this.locations,
    required this.peopleCounts,
  });

  @override
  Widget build(BuildContext context) {
    final activeCount = locations.where((location) => location.isActive).length;

    final inactiveCount = locations
        .where((location) => !location.isActive)
        .length;

    final peopleCount = peopleCounts.values.fold<int>(
      0,
      (total, count) => total + count,
    );

    final cards = [
      LocationsKpiCard(
        label: 'Total Locations',
        value: locations.length.toString(),
        icon: Icons.location_on_rounded,
      ),
      LocationsKpiCard(
        label: 'Active',
        value: activeCount.toString(),
        icon: Icons.check_circle_outline_rounded,
      ),
      LocationsKpiCard(
        label: 'Inactive',
        value: inactiveCount.toString(),
        icon: Icons.pause_circle_outline_rounded,
      ),
      LocationsKpiCard(
        label: 'People',
        value: peopleCount.toString(),
        icon: Icons.people_outline_rounded,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final columns = width >= 1200
            ? 4
            : width >= 700
            ? 2
            : 1;

        if (columns == 1) {
          return Column(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                cards[i],
                if (i < cards.length - 1) const SizedBox(height: AppSpacing.sm),
              ],
            ],
          );
        }

        final cardWidth = (width - ((columns - 1) * AppSpacing.sm)) / columns;

        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final card in cards) SizedBox(width: cardWidth, child: card),
          ],
        );
      },
    );
  }
}
