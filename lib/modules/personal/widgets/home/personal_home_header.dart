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
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE8EAF0))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // ===============================================================
          // SEARCH
          // ===============================================================
          SizedBox(
            width: 360,
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),

          const Spacer(),

          // ===============================================================
          // NOTIFICATIONS
          // ===============================================================
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF475467),
            ),
          ),

          const SizedBox(width: 6),

          // ===============================================================
          // HELP
          // ===============================================================
          IconButton(
            tooltip: 'Help',
            onPressed: () {},
            icon: const Icon(
              Icons.help_outline_rounded,
              color: Color(0xFF475467),
            ),
          ),

          const SizedBox(width: 12),

          // ===============================================================
          // ACCOUNT
          // ===============================================================
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF6547E8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF273247),
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Personal Home',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 6),
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
  }
}
