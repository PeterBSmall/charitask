import 'package:flutter/material.dart';

class OrganizationalRoleSelector extends StatelessWidget {
  final List<Map<String, dynamic>> roles;
  final String? selectedRoleId;
  final ValueChanged<String?> onChanged;

  const OrganizationalRoleSelector({
    super.key,
    required this.roles,
    required this.selectedRoleId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedRole = roles.cast<Map<String, dynamic>?>().firstWhere(
      (role) => role?['id'] == selectedRoleId,
      orElse: () => null,
    );

    final selectedName = selectedRole?['name']?.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Organizational Role',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),

        const SizedBox(height: 8),

        InkWell(
          onTap: () => _showSelector(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E4EA)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.account_tree_outlined,
                  color: Color(0xFF5B3FC4),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    selectedName ?? 'Select organizational role',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: selectedName == null
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF2F3A4A),
                    ),
                  ),
                ),

                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF6B7280),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 56,
            vertical: 32,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720, maxHeight: 700),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 30,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(32, 28, 32, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Choose organizational role',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2F3A4A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  if (roles.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'No organizational roles have been created yet.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    )
                  else
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Column(
                          children: roles.map((role) {
                            final id = role['id']?.toString() ?? '';
                            final name = role['name']?.toString() ?? '';

                            return _RoleOptionTile(
                              name: name,
                              selected: id == selectedRoleId,
                              onTap: () {
                                onChanged(id);
                                Navigator.of(dialogContext).pop();
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                  const Divider(height: 1),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF5B3FC4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RoleOptionTile extends StatelessWidget {
  final String name;
  final bool selected;
  final VoidCallback onTap;

  const _RoleOptionTile({
    required this.name,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF1EEFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: selected ? Border.all(color: const Color(0xFFD8CEFF)) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFDDD5FF)
                    : const Color(0xFFF4F4F5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.account_tree_outlined,
                color: Color(0xFF5B3FC4),
                size: 23,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2F3A4A),
                ),
              ),
            ),

            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF5B3FC4),
                size: 26,
              ),
          ],
        ),
      ),
    );
  }
}
