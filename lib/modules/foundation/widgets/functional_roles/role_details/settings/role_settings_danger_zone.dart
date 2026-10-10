import 'package:flutter/material.dart';

class RoleSettingsDangerZone extends StatelessWidget {
  final bool active;
  final bool archiving;
  final bool restoring;
  final bool deleting;
  final bool canDelete;

  final VoidCallback onArchive;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  const RoleSettingsDangerZone({
    super.key,
    required this.active,
    required this.archiving,
    required this.restoring,
    required this.deleting,
    required this.canDelete,
    required this.onArchive,
    required this.onRestore,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final busy = archiving || restoring || deleting;

    if (active) {
      return _buildArchiveSection(busy);
    }

    return _buildInactiveSection(busy);
  }

  Widget _buildArchiveSection(bool busy) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 650;

          final description = const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Archive Role',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF991B1B),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Archive this role when it should no longer be used. '
                'Archived roles are removed from the active role list.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          );

          final button = OutlinedButton(
            onPressed: busy ? null : onArchive,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFB91C1C),
              side: const BorderSide(color: Color(0xFFDC2626)),
            ),
            child: archiving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Archive Role'),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [description, const SizedBox(height: 16), button],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: description),
              const SizedBox(width: 20),
              button,
            ],
          );
        },
      ),
    );
  }

  Widget _buildInactiveSection(bool busy) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 650;

          final restoreSection = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Restore Role',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Restore this role to make it active and available for '
                'assignments again.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: busy ? null : onRestore,
                icon: restoring
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.restore_outlined, size: 18),
                label: const Text('Restore Role'),
              ),
            ],
          );

          final deleteSection = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Delete Role',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF991B1B),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Permanently delete this role. This action cannot be undone.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: busy || !canDelete ? null : onDelete,
                icon: deleting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.delete_outline, size: 18),
                label: const Text('Delete Role'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFB91C1C),
                  side: const BorderSide(color: Color(0xFFDC2626)),
                ),
              ),
              if (!canDelete) ...[
                const SizedBox(height: 6),
                const Text(
                  'You do not have permission to permanently delete roles.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                ),
              ],
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                restoreSection,
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 20),
                deleteSection,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: restoreSection),
              const SizedBox(width: 32),
              Expanded(child: deleteSection),
            ],
          );
        },
      ),
    );
  }
}
