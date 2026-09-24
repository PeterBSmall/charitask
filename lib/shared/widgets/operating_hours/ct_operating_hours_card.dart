import 'package:flutter/material.dart';

import 'ct_operating_hours_day.dart';
import 'ct_operating_hours_row.dart';

class CTOperatingHoursCard extends StatelessWidget {
  final List<CTOperatingHoursDay> days;
  final ValueChanged<CTOperatingHoursDay> onDayChanged;

  const CTOperatingHoursCard({
    super.key,
    required this.days,
    required this.onDayChanged,
  });

  static const _defaultDays = [
    (1, 'Monday'),
    (2, 'Tuesday'),
    (3, 'Wednesday'),
    (4, 'Thursday'),
    (5, 'Friday'),
    (6, 'Saturday'),
    (7, 'Sunday'),
  ];

  @override
  Widget build(BuildContext context) {
    final dayMap = {for (final day in days) day.dayOfWeek: day};

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.schedule_outlined,
                  color: Color(0xFF16A34A),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Operating Hours',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Set the regular hours for this location.',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          const SizedBox(height: 8),

          for (final (dayOfWeek, dayName) in _defaultDays)
            CTOperatingHoursRow(
              dayName: dayName,
              isOpen: dayMap[dayOfWeek]?.isOpen ?? false,
              opensAt: dayMap[dayOfWeek]?.opensAt,
              closesAt: dayMap[dayOfWeek]?.closesAt,
              onOpenChanged: (isOpen) {
                final current =
                    dayMap[dayOfWeek] ??
                    CTOperatingHoursDay(dayOfWeek: dayOfWeek, dayName: dayName);

                onDayChanged(
                  current.copyWith(
                    isOpen: isOpen,
                    clearOpensAt: !isOpen,
                    clearClosesAt: !isOpen,
                  ),
                );
              },
              onOpenTimeTap: () async {
                final current = dayMap[dayOfWeek];

                final selected = await showTimePicker(
                  context: context,
                  initialTime:
                      current?.opensAt ?? const TimeOfDay(hour: 9, minute: 0),
                );

                if (selected == null) return;

                final currentDay =
                    current ??
                    CTOperatingHoursDay(dayOfWeek: dayOfWeek, dayName: dayName);

                onDayChanged(
                  currentDay.copyWith(isOpen: true, opensAt: selected),
                );
              },
              onCloseTimeTap: () async {
                final current = dayMap[dayOfWeek];

                final selected = await showTimePicker(
                  context: context,
                  initialTime:
                      current?.closesAt ?? const TimeOfDay(hour: 17, minute: 0),
                );

                if (selected == null) return;

                final currentDay =
                    current ??
                    CTOperatingHoursDay(dayOfWeek: dayOfWeek, dayName: dayName);

                onDayChanged(
                  currentDay.copyWith(isOpen: true, closesAt: selected),
                );
              },
            ),
        ],
      ),
    );
  }
}
