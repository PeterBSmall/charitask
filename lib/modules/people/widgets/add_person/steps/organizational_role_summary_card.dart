import 'package:flutter/material.dart';
import 'organizational_role_definition.dart';

class OrganizationalRoleSummaryCard extends StatelessWidget {
  const OrganizationalRoleSummaryCard({
    super.key,
    required this.organizationalRole,
  });

  final String organizationalRole;

  OrganizationalRoleDefinition? get _definition {
    for (final definition in organizationalRoleDefinitions) {
      if (definition.name == organizationalRole) {
        return definition;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final definition = _definition;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E0EC)),
      ),
      child: definition == null
          ? const _EmptySummary()
          : _RoleSummary(definition: definition),
    );
  }
}

class _RoleSummary extends StatelessWidget {
  const _RoleSummary({required this.definition});

  final OrganizationalRoleDefinition definition;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ROLE SUMMARY',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
            color: Color(0xFF7C4DFF),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          definition.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF292333),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Organizational level',
          style: TextStyle(fontSize: 12, color: Color(0xFF8A8295)),
        ),
        const SizedBox(height: 18),
        Text(
          definition.description,
          style: const TextStyle(
            fontSize: 13,
            height: 1.5,
            color: Color(0xFF6F687A),
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Typical focus',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF40394D),
          ),
        ),
        const SizedBox(height: 10),
        ...definition.focus.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Icon(Icons.circle, size: 5, color: Color(0xFF7C4DFF)),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: Color(0xFF6F687A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptySummary extends StatelessWidget {
  const _EmptySummary();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ROLE SUMMARY',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
            color: Color(0xFF7C4DFF),
          ),
        ),
        SizedBox(height: 18),
        Text(
          'Select a role',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF292333),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Choose an organizational role to see a brief summary of what that level typically represents.',
          style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF6F687A)),
        ),
      ],
    );
  }
}
