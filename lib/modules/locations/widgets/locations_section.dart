import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/domain/models/location.dart';
import 'package:charitask/modules/locations/widgets/location_card.dart';
import 'package:charitask/shared/design_system/design_system.dart';

class LocationsSection extends StatelessWidget {
  final List<Location> locations;
  final Map<String, int> peopleCounts;
  final ValueChanged<Location> onLocationTap;

  const LocationsSection({
    super.key,
    required this.locations,
    required this.peopleCounts,
    required this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                'Your Locations',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              '${locations.length} '
              '${locations.length == 1 ? 'location' : 'locations'}',
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            final columns = width >= 1200
                ? 3
                : width >= 760
                ? 2
                : 1;

            final rows = <Widget>[];

            for (var i = 0; i < locations.length; i += columns) {
              final rowLocations = locations.skip(i).take(columns).toList();

              rows.add(
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var j = 0; j < columns; j++) ...[
                      if (j < rowLocations.length)
                        Expanded(
                          child: LocationCard(
                            location: rowLocations[j],
                            peopleCount: peopleCounts[rowLocations[j].id] ?? 0,
                            onTap: () => onLocationTap(rowLocations[j]),
                          ),
                        )
                      else
                        const Expanded(child: SizedBox.shrink()),

                      if (j < columns - 1) const SizedBox(width: AppSpacing.md),
                    ],
                  ],
                ),
              );

              if (i + columns < locations.length) {
                rows.add(const SizedBox(height: AppSpacing.md));
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: rows,
            );
          },
        ),
      ],
    );
  }
}
