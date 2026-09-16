import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PersonalHomeHeader extends StatelessWidget {
  const PersonalHomeHeader({super.key});

  Future<void> _signOut(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();

    if (!context.mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final metadata = user?.userMetadata ?? {};

    final firstName = (metadata['first_name'] as String?)?.trim() ?? '';
    final lastName = (metadata['last_name'] as String?)?.trim() ?? '';

    final fullName = [
      firstName,
      lastName,
    ].where((name) => name.isNotEmpty).join(' ');

    final displayName = fullName.isEmpty ? 'ChariTask User' : fullName;

    final initials = [
      if (firstName.isNotEmpty) firstName[0],
      if (lastName.isNotEmpty) lastName[0],
    ].join().toUpperCase();

    final displayInitials = initials.isEmpty ? 'CT' : initials;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final veryCompact = width < 600;
        final compact = width < 850;

        return Container(
          height: 72,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE8EAF0))),
          ),
          padding: EdgeInsets.symmetric(horizontal: veryCompact ? 12 : 24),
          child: Row(
            children: [
              // ===========================================================
              // SEARCH
              // ===========================================================
              if (veryCompact)
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          size: 21,
                          color: Color(0xFF667085),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF7F7FA),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  width: compact ? 260 : 360,
                  height: 42,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search ChariTask...',
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 21,
                        color: Color(0xFF667085),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF7F7FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),

              if (!veryCompact) const Spacer(),

              // ===========================================================
              // NOTIFICATIONS
              // ===========================================================
              IconButton(
                tooltip: 'Notifications',
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF475467),
                ),
              ),

              // ===========================================================
              // HELP
              // ===========================================================
              if (!veryCompact)
                IconButton(
                  tooltip: 'Help',
                  onPressed: () {},
                  icon: const Icon(
                    Icons.help_outline_rounded,
                    color: Color(0xFF475467),
                  ),
                ),

              if (!veryCompact) const SizedBox(width: 12),

              // ===========================================================
              // ACCOUNT
              // ===========================================================
              PopupMenuButton<String>(
                tooltip: 'Account',
                offset: const Offset(0, 58),
                onSelected: (value) {
                  if (value == 'logout') {
                    _signOut(context);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem<String>(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person_outline_rounded, size: 20),
                        SizedBox(width: 10),
                        Text('Personal Profile'),
                      ],
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout_rounded, size: 20),
                        SizedBox(width: 10),
                        Text('Log Out'),
                      ],
                    ),
                  ),
                ],
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: veryCompact ? 4 : 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFF8F7FB),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF0EBFF),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          displayInitials,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF6547E8),
                          ),
                        ),
                      ),

                      if (!veryCompact) ...[
                        const SizedBox(width: 10),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: compact ? 120 : 180,
                              ),
                              child: Text(
                                displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF273247),
                                ),
                              ),
                            ),
                            const SizedBox(height: 1),
                            const Text(
                              'Personal Home',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF718096),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 6),
                      ],

                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 19,
                        color: Color(0xFF667085),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
