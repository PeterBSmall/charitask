import 'package:flutter/material.dart';

import '../../design_system/foundations/app_colors.dart';
import '../../design_system/foundations/app_spacing.dart';
import '../../design_system/foundations/app_typography.dart';

class CTWorkspaceSidebarItem {
  final String label;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const CTWorkspaceSidebarItem({
    required this.label,
    required this.icon,
    this.iconColor,
    this.onTap,
  });
}

class CTWorkspaceSidebar extends StatelessWidget {
  final String workspaceName;
  final String workspaceLabel;
  final List<CTWorkspaceSidebarItem> items;
  final String selectedItem;

  const CTWorkspaceSidebar({
    super.key,
    required this.workspaceName,
    this.workspaceLabel = 'Workspace',
    required this.items,
    required this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE7E8EF))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ---------------------------------------------------------------
          // WORKSPACE HEADER
          // ---------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.missionPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    workspaceName.isEmpty
                        ? '?'
                        : workspaceName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workspaceName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.title.copyWith(
                          color: AppColors.missionPurple,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        workspaceLabel,
                        style: AppTypography.body.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE7E8EF)),

          const SizedBox(height: AppSpacing.md),

          // ---------------------------------------------------------------
          // NAVIGATION
          // ---------------------------------------------------------------
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final selected = item.label == selectedItem;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: _SidebarItem(item: item, selected: selected),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final CTWorkspaceSidebarItem item;
  final bool selected;

  const _SidebarItem({required this.item, required this.selected});

  @override
  Widget build(BuildContext context) {
    final iconColor = selected
        ? AppColors.missionPurple
        : item.iconColor ?? const Color(0xFF536070);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.missionPurple.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(item.icon, size: 20, color: iconColor),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  item.label,
                  style: AppTypography.body.copyWith(
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: selected
                        ? AppColors.missionPurple
                        : const Color(0xFF263247),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
