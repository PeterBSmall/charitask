import 'package:flutter/material.dart';

import 'glance_card.dart';

class EventsGlanceCard extends StatelessWidget {
  final Color accentColor;

  const EventsGlanceCard({super.key, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return GlanceCard(
      icon: Icons.calendar_month_outlined,
      title: 'Upcoming Events',
      headerAction: 'View all →',
      accentColor: const Color(0xFF16A34A),
      child: Column(
        children: [
          _EventRow(
            month: 'MAY',
            day: '18',
            title: 'Volunteer Orientation',
            time: '10:00 AM – 12:00 PM',
            location: 'Falmouth ReStore',
          ),
          _EventRow(
            month: 'MAY',
            day: '24',
            title: 'Community Clean-Up',
            time: '9:00 AM – 1:00 PM',
            location: 'Yarmouth ReStore',
          ),
          _EventRow(
            month: 'JUN',
            day: '05',
            title: 'Summer Kickoff Event',
            time: '11:00 AM – 2:00 PM',
            location: 'Cape Cod Fairgrounds',
            showBottomBorder: false,
          ),
        ],
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  final String month;
  final String day;
  final String title;
  final String time;
  final String location;
  final bool showBottomBorder;

  const _EventRow({
    required this.month,
    required this.day,
    required this.title,
    required this.time,
    required this.location,
    this.showBottomBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
      decoration: BoxDecoration(
        border: showBottomBorder
            ? const Border(bottom: BorderSide(color: Color(0xFFE8ECF2)))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F7EE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  month,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF3B9460),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  day,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF3B9460),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF27345B),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_outlined,
                      size: 12,
                      color: Color(0xFF68738A),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        time,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFF68738A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color: Color(0xFF68738A),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFF68738A),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
