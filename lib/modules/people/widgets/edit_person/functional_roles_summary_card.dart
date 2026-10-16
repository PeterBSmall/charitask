import 'package:flutter/material.dart';

class FunctionalRolesSummaryCard extends StatelessWidget {
  const FunctionalRolesSummaryCard({
    super.key,
    required this.roleNames,
    required this.canManage,
    required this.onManageRoles,
  });

  final List<String> roleNames;
  final bool canManage;
  final VoidCallback onManageRoles;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasRoles = roleNames.isNotEmpty;
    final primaryColor = theme.colorScheme.primary;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.assignment_ind_outlined,
                    color: primaryColor,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Functional Roles',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (hasRoles)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: roleNames.map((roleName) {
                  return Container(
                    constraints: const BoxConstraints(maxWidth: 320),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      roleName,
                      softWrap: true,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              )
            else
              Text(
                'No functional roles assigned.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            if (canManage) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: onManageRoles,
                  icon: const Icon(Icons.tune, size: 18),
                  label: const Text('Manage Roles'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
