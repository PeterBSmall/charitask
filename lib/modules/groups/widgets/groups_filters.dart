import 'package:flutter/material.dart';

import '../domain/models/group.dart';

class GroupsFilters extends StatelessWidget {
  final TextEditingController searchController;
  final GroupType? selectedGroupType;
  final String? selectedOwner;
  final String? selectedStatus;
  final String? selectedLocation;
  final String selectedSort;
  final bool isGridView;

  final ValueChanged<String> onSearchChanged;
  final ValueChanged<GroupType?> onGroupTypeChanged;
  final ValueChanged<String?> onOwnerChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onLocationChanged;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<bool> onViewChanged;

  const GroupsFilters({
    super.key,
    required this.searchController,
    required this.selectedGroupType,
    required this.selectedOwner,
    required this.selectedStatus,
    required this.selectedLocation,
    required this.selectedSort,
    required this.isGridView,
    required this.onSearchChanged,
    required this.onGroupTypeChanged,
    required this.onOwnerChanged,
    required this.onStatusChanged,
    required this.onLocationChanged,
    required this.onSortChanged,
    required this.onViewChanged,
  });

  static const _navy = Color(0xFF1E293B);
  static const _gray = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);
  static const _cyan = Color(0xFF06B6D4);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 900;

        if (compact) {
          return _buildCompact();
        }

        return _buildWide();
      },
    );
  }

  Widget _buildWide() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _SearchField(
              controller: searchController,
              onChanged: onSearchChanged,
            ),
          ),
          const SizedBox(width: 10),
          _GroupTypeDropdown(
            value: selectedGroupType,
            onChanged: onGroupTypeChanged,
          ),
          const SizedBox(width: 10),
          _FilterDropdown(
            value: selectedOwner,
            hint: 'Owner',
            items: const [
              'Organization',
              'Program',
              'Location',
              'Event',
              'Project',
            ],
            onChanged: onOwnerChanged,
          ),
          const SizedBox(width: 10),
          _FilterDropdown(
            value: selectedStatus,
            hint: 'Status',
            items: const ['Active', 'Inactive'],
            onChanged: onStatusChanged,
          ),
          const SizedBox(width: 10),
          _FilterDropdown(
            value: selectedLocation,
            hint: 'Location',
            items: const [],
            onChanged: onLocationChanged,
          ),
          const SizedBox(width: 10),
          _FilterDropdown(
            value: selectedSort,
            hint: 'Sort',
            items: const [
              'Name',
              'Newest',
              'Oldest',
              'Most Members',
              'Fewest Members',
            ],
            onChanged: (value) {
              if (value != null) {
                onSortChanged(value);
              }
            },
          ),
          const SizedBox(width: 10),
          _ViewToggle(isGridView: isGridView, onChanged: onViewChanged),
        ],
      ),
    );
  }

  Widget _buildCompact() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
      child: Column(
        children: [
          _SearchField(
            controller: searchController,
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _GroupTypeDropdown(
                value: selectedGroupType,
                onChanged: onGroupTypeChanged,
              ),
              _FilterDropdown(
                value: selectedOwner,
                hint: 'Owner',
                items: const [
                  'Organization',
                  'Program',
                  'Location',
                  'Event',
                  'Project',
                ],
                onChanged: onOwnerChanged,
              ),
              _FilterDropdown(
                value: selectedStatus,
                hint: 'Status',
                items: const ['Active', 'Inactive'],
                onChanged: onStatusChanged,
              ),
              _FilterDropdown(
                value: selectedLocation,
                hint: 'Location',
                items: const [],
                onChanged: onLocationChanged,
              ),
              _FilterDropdown(
                value: selectedSort,
                hint: 'Sort',
                items: const [
                  'Name',
                  'Newest',
                  'Oldest',
                  'Most Members',
                  'Fewest Members',
                ],
                onChanged: (value) {
                  if (value != null) {
                    onSortChanged(value);
                  }
                },
              ),
              _ViewToggle(isGridView: isGridView, onChanged: onViewChanged),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: GroupsFilters._navy, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Search groups',
        hintStyle: const TextStyle(color: GroupsFilters._gray, fontSize: 14),
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 20,
          color: GroupsFilters._gray,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                onPressed: controller.clear,
                icon: const Icon(Icons.close_rounded, size: 18),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: GroupsFilters._border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: GroupsFilters._border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: GroupsFilters._cyan, width: 1.5),
        ),
      ),
    );
  }
}

class _GroupTypeDropdown extends StatelessWidget {
  final GroupType? value;
  final ValueChanged<GroupType?> onChanged;

  const _GroupTypeDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _DropdownShell(
      width: 150,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<GroupType?>(
          value: value,
          isExpanded: true,
          hint: const Text('Group Type'),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 19),
          style: const TextStyle(
            color: GroupsFilters._navy,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          items: [
            const DropdownMenuItem<GroupType?>(
              value: null,
              child: Text('All Types'),
            ),
            ...GroupType.values.map(
              (type) => DropdownMenuItem<GroupType?>(
                value: type,
                child: Text(type.label),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _DropdownShell(
      width: 125,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 19),
          style: const TextStyle(
            color: GroupsFilters._navy,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          items: [
            DropdownMenuItem<String>(value: null, child: Text('All $hint')),
            ...items.map(
              (item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _DropdownShell extends StatelessWidget {
  final double width;
  final Widget child;

  const _DropdownShell({required this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GroupsFilters._border),
      ),
      child: child,
    );
  }
}

class _ViewToggle extends StatelessWidget {
  final bool isGridView;
  final ValueChanged<bool> onChanged;

  const _ViewToggle({required this.isGridView, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GroupsFilters._border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ViewButton(
            icon: Icons.grid_view_rounded,
            selected: isGridView,
            onPressed: () => onChanged(true),
          ),
          _ViewButton(
            icon: Icons.view_list_rounded,
            selected: !isGridView,
            onPressed: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _ViewButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  const _ViewButton({
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? GroupsFilters._cyan.withValues(alpha: 0.12)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(7),
        child: SizedBox(
          width: 36,
          height: 38,
          child: Icon(
            icon,
            size: 18,
            color: selected ? GroupsFilters._cyan : GroupsFilters._gray,
          ),
        ),
      ),
    );
  }
}
