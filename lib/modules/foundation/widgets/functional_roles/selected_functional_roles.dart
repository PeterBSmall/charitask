import 'package:flutter/material.dart';

import '../../domain/models/functional_role.dart';
import 'selected_functional_role_card.dart';

class SelectedFunctionalRoles extends StatelessWidget {
  const SelectedFunctionalRoles({
    super.key,
    required this.roles,
    required this.onRemove,
  });

  final List<FunctionalRole> roles;
  final ValueChanged<FunctionalRole> onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFCFCFD),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Functional Roles',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${roles.length} ${roles.length == 1 ? 'role' : 'roles'} selected',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Actions',
            icon: const Icon(Icons.more_horiz, color: Color(0xFF64748B)),
            onSelected: (_) {},
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'info', child: Text('Assignment actions')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (roles.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.assignment_outlined,
                        size: 42,
                        color: Color(0xFFCBD5E1),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No functional roles selected',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Select roles from the catalog to configure assignments.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: roles.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final role = roles[index];

        return SelectedFunctionalRoleCard(
          role: role,
          onRemove: () => onRemove(role),
        );
      },
    );
  }
}
