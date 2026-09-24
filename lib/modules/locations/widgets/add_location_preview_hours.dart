import 'package:flutter/material.dart';

import 'package:charitask/shared/widgets/operating_hours/ct_operating_hours_day.dart';

class AddLocationPreviewHours extends StatelessWidget {
  final List<CTOperatingHoursDay> operatingHours;

  const AddLocationPreviewHours({super.key, required this.operatingHours});

  @override
  Widget build(BuildContext context) {
    const days = [
      (1, 'Monday'),
      (2, 'Tuesday'),
      (3, 'Wednesday'),
      (4, 'Thursday'),
      (5, 'Friday'),
      (6, 'Saturday'),
      (7, 'Sunday'),
    ];

    final hoursMap = {for (final day in operatingHours) day.dayOfWeek: day};

    return _buildSection(
      icon: Icons.schedule_outlined,
      title: 'Operating Hours',
      child: Column(
        children: [
          for (final (dayOfWeek, dayName) in days)
            _buildOperatingHoursLine(context, dayName, hoursMap[dayOfWeek]),
        ],
      ),
    );
  }

  Widget _buildOperatingHoursLine(
    BuildContext context,
    String dayName,
    CTOperatingHoursDay? day,
  ) {
    final isOpen = day?.isOpen ?? false;

    String formatTime(TimeOfDay? time) {
      if (time == null) return 'Set time';
      return time.format(context);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 76,
            child: Text(
              dayName,
              style: const TextStyle(
                color: Color(0xFF475569),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              !isOpen
                  ? 'Closed'
                  : '${formatTime(day?.opensAt)} – ${formatTime(day?.closesAt)}',
              style: TextStyle(
                color: !isOpen
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF334155),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
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
