import 'package:flutter/material.dart';

class GroupsHero extends StatelessWidget {
  const GroupsHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      padding: const EdgeInsets.fromLTRB(34, 26, 26, 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2389B4), Color(0xFF38B7D6), Color(0xFFB9F0F7)],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final narrow = constraints.maxWidth < 600;
          final compact = constraints.maxWidth < 800;

          return Stack(
            children: [
              if (!compact)
                const Positioned(
                  right: -10,
                  top: -35,
                  child: _HeroPeopleDecoration(),
                ),
              _buildContent(narrow: narrow),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent({required bool narrow}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'GROUPS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 4),

        Text(
          'Groups',
          maxLines: 1,
          softWrap: false,
          style: TextStyle(
            color: Colors.white,
            fontSize: narrow ? 34 : 42,
            height: 1,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'Connect people around shared purpose.',
          maxLines: narrow ? 2 : 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: narrow ? 17 : 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 10),

        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: narrow ? 430 : 560),
          child: Text(
            'Groups help you organize people, assign roles, and bring teams together around programs, locations, and initiatives. Build stronger connections and greater impact.',
            maxLines: narrow ? 4 : null,
            overflow: narrow ? TextOverflow.ellipsis : null,
            style: TextStyle(
              color: Colors.white,
              fontSize: narrow ? 13 : 14,
              height: 1.45,
            ),
          ),
        ),

        // The feature row is intentionally omitted on narrow screens.
        // It is supporting decoration and cannot fit reliably in a
        // very narrow responsive layout.
        if (!narrow) ...[
          const SizedBox(height: 18),
          const Wrap(
            spacing: 20,
            runSpacing: 8,
            children: [
              _HeroFeature(icon: Icons.groups_outlined, label: 'People'),
              _HeroFeature(icon: Icons.people_alt_outlined, label: 'Teams'),
              _HeroFeature(
                icon: Icons.handshake_outlined,
                label: 'Collaboration',
              ),
              _HeroFeature(
                icon: Icons.favorite_border_rounded,
                label: 'Greater Impact',
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _HeroFeature extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroFeature({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: Colors.white),
        const SizedBox(width: 7),
        Flexible(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroPeopleDecoration extends StatelessWidget {
  const _HeroPeopleDecoration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: 20, left: 105, child: _Bubble(size: 54)),
          Positioned(top: 42, right: 25, child: _Bubble(size: 48)),
          Positioned(top: 90, left: 50, child: _Bubble(size: 42)),
          Positioned(bottom: 12, left: 95, child: _Bubble(size: 104)),
          Positioned(bottom: 18, right: 54, child: _Bubble(size: 74)),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final double size;

  const _Bubble({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .72),
        shape: BoxShape.circle,
      ),
    );
  }
}
