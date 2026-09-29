import 'package:flutter/material.dart';

class InvitationsHero extends StatelessWidget {
  const InvitationsHero({super.key, required this.onCreateInvitation});

  final VoidCallback onCreateInvitation;

  static const _purple = Color(0xFF7C3AED);
  static const _text = Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFEDE9FE), Color(0xFFDCD6FE), Color(0xFFEDE9FE)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 720;

          final content = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(),
              const SizedBox(width: 18),
              Expanded(child: _buildContent()),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [content, const SizedBox(height: 18), _buildAction()],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: content),
              const SizedBox(width: 20),
              _buildAction(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: _purple,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _purple.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(
        Icons.mark_email_unread_outlined,
        color: Colors.white,
        size: 38,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'INVITATIONS',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: _purple,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Invitations',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: _text,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Invite people to join your organization, workspaces, programs, '
          'locations and groups. Track invitation status and manage access.',
          style: TextStyle(
            color: Color(0xFF475569),
            fontSize: 14,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: const [
            _HeroTag(label: 'People'),
            _HeroDot(),
            _HeroTag(label: 'Opportunities'),
            _HeroDot(),
            _HeroTag(label: 'Greater Impact'),
          ],
        ),
      ],
    );
  }

  Widget _buildAction() {
    return FilledButton.icon(
      onPressed: onCreateInvitation,
      icon: const Icon(Icons.add_rounded),
      label: const Text('Create Invitation'),
      style: FilledButton.styleFrom(
        backgroundColor: _purple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
    );
  }
}

class _HeroTag extends StatelessWidget {
  const _HeroTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: InvitationsHero._purple,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _HeroDot extends StatelessWidget {
  const _HeroDot();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '•',
      style: TextStyle(
        color: InvitationsHero._purple,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
