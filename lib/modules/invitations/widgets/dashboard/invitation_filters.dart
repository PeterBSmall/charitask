import 'package:flutter/material.dart';

class InvitationFilters extends StatelessWidget {
  const InvitationFilters({
    super.key,
    required this.searchController,
    required this.selectedStatus,
    required this.selectedInvitationType,
    required this.selectedInvitedTo,
    required this.selectedAccessType,
    required this.onStatusChanged,
    required this.onInvitationTypeChanged,
    required this.onInvitedToChanged,
    required this.onAccessTypeChanged,
    required this.onClear,
  });

  final TextEditingController searchController;
  final String? selectedStatus;
  final String? selectedInvitationType;
  final String? selectedInvitedTo;
  final String? selectedAccessType;

  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onInvitationTypeChanged;
  final ValueChanged<String?> onInvitedToChanged;
  final ValueChanged<String?> onAccessTypeChanged;
  final VoidCallback onClear;

  static const _purple = Color(0xFF7C3AED);
  static const _text = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  static const _statuses = ['Pending', 'Accepted', 'Expired', 'Revoked'];

  static const _invitationTypes = [
    'Organization',
    'Workspace',
    'Location',
    'Program',
    'Group',
    'Event',
  ];

  static const _invitedToOptions = [
    'Organization',
    'Workspace',
    'Location',
    'Program',
    'Group',
    'Event',
  ];

  static const _accessTypes = ['Existing Person', 'New Person'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 850;

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSearch(),
                const SizedBox(height: 12),
                _buildFilters(),
              ],
            );
          }

          return Row(
            children: [
              Expanded(flex: 2, child: _buildSearch()),
              const SizedBox(width: 12),
              Expanded(flex: 3, child: _buildFilters()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearch() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search by name, email, or invited to...',
        hintStyle: const TextStyle(color: _muted, fontSize: 13),
        prefixIcon: const Icon(Icons.search_rounded, color: _muted, size: 20),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _purple),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildDropdown(
          label: 'Status',
          value: selectedStatus,
          items: _statuses,
          onChanged: onStatusChanged,
        ),
        _buildDropdown(
          label: 'Invitation Type',
          value: selectedInvitationType,
          items: _invitationTypes,
          onChanged: onInvitationTypeChanged,
        ),
        _buildDropdown(
          label: 'Invited To',
          value: selectedInvitedTo,
          items: _invitedToOptions,
          onChanged: onInvitedToChanged,
        ),
        _buildDropdown(
          label: 'Access Type',
          value: selectedAccessType,
          items: _accessTypes,
          onChanged: onAccessTypeChanged,
        ),
        OutlinedButton.icon(
          onPressed: onClear,
          icon: const Icon(Icons.filter_alt_off_outlined, size: 17),
          label: const Text('Clear'),
          style: OutlinedButton.styleFrom(
            foregroundColor: _muted,
            side: const BorderSide(color: _border),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        hint: Text(label, style: const TextStyle(color: _muted, fontSize: 13)),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 18,
          color: _muted,
        ),
        borderRadius: BorderRadius.circular(10),
        items: [
          for (final item in items)
            DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _text, fontSize: 13),
              ),
            ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
