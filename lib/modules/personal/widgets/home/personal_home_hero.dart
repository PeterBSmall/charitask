import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PersonalHomeHero extends StatelessWidget {
  const PersonalHomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final metadata = user?.userMetadata ?? {};

    final firstName = (metadata['first_name'] as String?)?.trim() ?? '';
    final greetingName = firstName.isEmpty ? 'there' : firstName;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 300),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE7E0FA)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 800;

          return Stack(
            children: [
              // Hero image on the right.
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                width: compact
                    ? constraints.maxWidth * 0.42
                    : constraints.maxWidth * 0.48,
                child: Image.asset(
                  'assets/images/hero_library/abstract/'
                  'charitask_background_abstract.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                ),
              ),

              // Content.
              Padding(
                padding: EdgeInsets.fromLTRB(
                  compact ? 24 : 44,
                  compact ? 26 : 38,
                  compact
                      ? constraints.maxWidth * 0.32
                      : constraints.maxWidth * 0.43,
                  compact ? 26 : 34,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GOOD MORNING,',
                      style: TextStyle(
                        fontSize: compact ? 14 : 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                        color: const Color(0xFF6547E8),
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      greetingName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: compact ? 34 : 42,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                        color: const Color(0xFF273247),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Container(height: 1, color: const Color(0xFFE4E0F0)),

                    const SizedBox(height: 18),

                    Text(
                      'You have:',
                      style: TextStyle(
                        fontSize: compact ? 15 : 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF59677D),
                      ),
                    ),

                    const SizedBox(height: 12),

                    compact
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _HeroSummaryRow(
                                icon: Icons.check_circle_outline_rounded,
                                text: '2 tasks due today',
                              ),
                              const SizedBox(height: 9),
                              _HeroSummaryRow(
                                icon: Icons.mail_outline_rounded,
                                text: '3 pending invitations',
                              ),
                              const SizedBox(height: 9),
                              _HeroSummaryRow(
                                icon: Icons.event_outlined,
                                text: '1 event tomorrow',
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: _HeroSummaryRow(
                                  icon: Icons.check_circle_outline_rounded,
                                  text: '2 tasks due today',
                                ),
                              ),
                              _HeroSummaryDivider(),
                              Expanded(
                                child: _HeroSummaryRow(
                                  icon: Icons.mail_outline_rounded,
                                  text: '3 pending invitations',
                                ),
                              ),
                              _HeroSummaryDivider(),
                              Expanded(
                                child: _HeroSummaryRow(
                                  icon: Icons.event_outlined,
                                  text: '1 event tomorrow',
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeroSummaryRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HeroSummaryRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 21, color: const Color(0xFF7C4DFF)),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF59677D),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroSummaryDivider extends StatelessWidget {
  const _HeroSummaryDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 42,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: const Color(0xFFE4E0F0),
    );
  }
}
