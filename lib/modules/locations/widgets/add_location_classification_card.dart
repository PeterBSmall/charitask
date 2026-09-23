import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/design_system.dart';

class AddLocationClassificationCard extends StatelessWidget {
  final List<Map<String, dynamic>> tags;
  final Set<String> selectedTagIds;
  final bool loading;
  final ValueChanged<String> onTagSelected;

  const AddLocationClassificationCard({
    super.key,
    required this.tags,
    required this.selectedTagIds,
    required this.loading,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F7F1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.sell_outlined,
                  size: 18,
                  color: Color(0xFF059669),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Classification',
                style: AppTypography.title.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF172033),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Add tags to help organize and find this location.',
                style: AppTypography.caption.copyWith(
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (tags.isEmpty)
            Text(
              'No location tags are configured.',
              style: AppTypography.body.copyWith(
                color: const Color(0xFF64748B),
              ),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: tags.map((tag) {
                final id = tag['id']?.toString();
                final name = tag['name']?.toString() ?? '';

                if (id == null || name.isEmpty) {
                  return const SizedBox.shrink();
                }

                final selected = selectedTagIds.contains(id);

                return InkWell(
                  onTap: () => onTagSelected(id),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF059669) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF059669)
                            : const Color(0xFFD1D5DB),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (selected) ...[
                          const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          name,
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : const Color(0xFF334155),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
