import 'package:flutter/material.dart';

class GroupsEmptyState extends StatelessWidget {
  final VoidCallback? onAddGroup;
  final bool isFiltered;

  const GroupsEmptyState({super.key, this.onAddGroup, this.isFiltered = false});

  static const _navy = Color(0xFF1E293B);
  static const _gray = Color(0xFF64748B);
  static const _cyan = Color(0xFF06B6D4);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 52),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F9FC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.groups_outlined, size: 36, color: _cyan),
          ),
          const SizedBox(height: 20),
          Text(
            isFiltered ? 'No groups found' : 'No groups yet',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _navy,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Text(
              isFiltered
                  ? 'Try adjusting your search or filters to find the groups you are looking for.'
                  : 'Create your first group to organize people around shared teams, programs, locations, and initiatives.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: _gray, fontSize: 14, height: 1.5),
            ),
          ),
          if (!isFiltered && onAddGroup != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAddGroup,
              icon: const Icon(Icons.add_rounded, size: 19),
              label: const Text('Add Group'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _cyan,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
