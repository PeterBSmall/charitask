import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/services/task_service.dart';

class PersonalHomeStats extends StatefulWidget {
  const PersonalHomeStats({super.key});

  @override
  State<PersonalHomeStats> createState() => _PersonalHomeStatsState();
}

class _PersonalHomeStatsState extends State<PersonalHomeStats> {
  late final TaskService _taskService;

  int _todayAndOverdueTaskCount = 0;
  bool _loadingTasks = true;

  @override
  void initState() {
    super.initState();
    _taskService = TaskService(Supabase.instance.client);
    _loadTaskCount();
  }

  Future<void> _loadTaskCount() async {
    try {
      final tasks = await _taskService.getCurrentPersonTodayAndOverdueTasks();

      if (!mounted) return;

      setState(() {
        _todayAndOverdueTaskCount = tasks.length;
        _loadingTasks = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _todayAndOverdueTaskCount = 0;
        _loadingTasks = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskSubtitle = _loadingTasks
        ? 'loading...'
        : _todayAndOverdueTaskCount == 0
        ? 'nothing needs attention'
        : _todayAndOverdueTaskCount == 1
        ? 'task needs attention'
        : 'tasks need attention';

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Keep the cards at a comfortable minimum width rather than
        // relying on the overall application/window width.
        final columns = width >= 1000
            ? 4
            : width >= 560
            ? 2
            : 1;

        const spacing = 16.0;

        final cardWidth = columns == 1
            ? width
            : (width - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            SizedBox(
              width: cardWidth,
              child: const _StatCard(
                icon: Icons.calendar_today_outlined,
                title: "Today's Schedule",
                value: '4',
                subtitle: 'items today',
                iconBackground: Color(0xFFF0EBFF),
                iconColor: Color(0xFF7C4DFF),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _StatCard(
                icon: Icons.priority_high_rounded,
                title: "Today's Focus",
                value: _loadingTasks
                    ? '—'
                    : _todayAndOverdueTaskCount.toString(),
                subtitle: taskSubtitle,
                iconBackground: const Color(0xFFE8F8FC),
                iconColor: const Color(0xFF08738A),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: const _StatCard(
                icon: Icons.check_circle_outline_rounded,
                title: 'Active Tasks',
                value: '7',
                subtitle: 'open tasks',
                iconBackground: Color(0xFFF3F4F6),
                iconColor: Color(0xFF475467),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: const _StatCard(
                icon: Icons.event_outlined,
                title: 'Upcoming Events',
                value: '3',
                subtitle: 'this week',
                iconBackground: Color(0xFFFFF4E8),
                iconColor: Color(0xFFB76E00),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color iconBackground;
  final Color iconColor;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.iconBackground,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 108),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7E8EE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 46,
            height: 46,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: iconColor),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF273247),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF98A2B3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
