import 'package:flutter/material.dart';

class PersonalHomeRightRail extends StatelessWidget {
  const PersonalHomeRightRail({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        _RailCard(
          title: 'Internal Messaging',
          icon: Icons.chat_bubble_outline_rounded,
          accent: Color(0xFF7C4DFF),
          child: _MessagingContent(),
        ),
        SizedBox(height: 16),
        _RailCard(
          title: 'Invitations & Requests',
          icon: Icons.mail_outline_rounded,
          accent: Color(0xFF06B6D4),
          child: _InvitationsContent(),
        ),
        SizedBox(height: 16),
        _RailCard(
          title: 'Upcoming Events',
          icon: Icons.event_outlined,
          accent: Color(0xFFE07A00),
          child: _EventsContent(),
        ),
      ],
    );
  }
}

class _RailCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accent;
  final Widget child;

  const _RailCard({
    required this.title,
    required this.icon,
    required this.accent,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7E8EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: accent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF273247),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _MessagingContent extends StatelessWidget {
  const _MessagingContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stay connected with your teams and organizations.',
          style: TextStyle(fontSize: 12, height: 1.4, color: Color(0xFF718096)),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: 38,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.chat_outlined, size: 17),
            label: const Text(
              'Open Messages',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6547E8),
              side: const BorderSide(color: Color(0xFFDCD5F7)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InvitationsContent extends StatelessWidget {
  const _InvitationsContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RequestRow(
          title: 'Volunteer Team',
          subtitle: 'Group invitation',
          accent: const Color(0xFF06B6D4),
        ),
        const SizedBox(height: 12),
        _RequestRow(
          title: 'Holiday Campaign',
          subtitle: 'Project invitation',
          accent: const Color(0xFF7C4DFF),
        ),
        const SizedBox(height: 14),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'View All Requests →',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6547E8),
            ),
          ),
        ),
      ],
    );
  }
}

class _RequestRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color accent;

  const _RequestRow({
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
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
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF273247),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Color(0xFF718096)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EventsContent extends StatelessWidget {
  const _EventsContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _EventRow(
          day: '14',
          month: 'SEP',
          title: 'Team Planning Meeting',
          time: '10:00 AM',
        ),
        SizedBox(height: 14),
        _EventRow(
          day: '16',
          month: 'SEP',
          title: 'Volunteer Orientation',
          time: '2:00 PM',
        ),
        SizedBox(height: 14),
        _EventRow(
          day: '18',
          month: 'SEP',
          title: 'Fundraising Planning',
          time: '4:30 PM',
        ),
      ],
    );
  }
}

class _EventRow extends StatelessWidget {
  final String day;
  final String month;
  final String title;
  final String time;

  const _EventRow({
    required this.day,
    required this.month,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4E8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                month,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFE07A00),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                day,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF273247),
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF273247),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(fontSize: 11, color: Color(0xFF718096)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
