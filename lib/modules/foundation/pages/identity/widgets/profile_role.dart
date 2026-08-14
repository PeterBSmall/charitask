import 'package:flutter/material.dart';

class ProfileRole extends StatelessWidget {
  final String organizationalRole;

  const ProfileRole({super.key, required this.organizationalRole});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Role',
          style: TextStyle(
            color: Color(0xFF263248),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Your place in the organization and how you use ChariTask.',
          style: TextStyle(color: Color(0xFF687286), fontSize: 14, height: 1.4),
        ),

        const SizedBox(height: 24),

        // Organizational Role
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE6E0FF)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0ECFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.business_outlined,
                  color: Color(0xFF6246E5),
                  size: 22,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Organizational Role',
                      style: TextStyle(
                        color: Color(0xFF263248),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Describes how you relate to the organization.',
                      style: TextStyle(
                        color: Color(0xFF687286),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF4E5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.people_alt_outlined,
                            color: Color(0xFF4D7C3A),
                            size: 17,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            _formatRole(organizationalRole),
                            style: const TextStyle(
                              color: Color(0xFF4D7C3A),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Functional Roles
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE6E0FF)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0ECFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.work_outline,
                  color: Color(0xFF6246E5),
                  size: 22,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Functional Roles',
                      style: TextStyle(
                        color: Color(0xFF263248),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Describe what you do within a specific suite or operational context.',
                      style: TextStyle(
                        color: Color(0xFF687286),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F3FA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0xFF6246E5),
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'No functional roles assigned yet.\n'
                              'They can be assigned as you begin using ChariTask tools.',
                              style: TextStyle(
                                color: Color(0xFF687286),
                                fontSize: 13,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatRole(String role) {
    switch (role) {
      case 'boardMember':
        return 'Board Member';

      case 'staffMember':
        return 'Staff Member';

      case 'volunteer':
        return 'Volunteer';

      case 'administrator':
        return 'Administrator';

      default:
        return role
            .replaceAllMapped(
              RegExp(r'([a-z])([A-Z])'),
              (match) => '${match.group(1)} ${match.group(2)}',
            )
            .replaceFirstMapped(
              RegExp(r'^\w'),
              (match) => match.group(0)!.toUpperCase(),
            );
    }
  }
}
