import 'package:flutter/material.dart';

import 'package:charitask/modules/groups/domain/models/create_group_draft.dart';
import 'package:charitask/modules/groups/domain/models/group.dart';
import 'package:charitask/modules/groups/widgets/create_group/steps/group_owner_location_field.dart';
import 'package:charitask/modules/locations/pages/add_location_page.dart';

class GroupDefinitionStep extends StatefulWidget {
  final CreateGroupDraft draft;
  final String organizationId;

  const GroupDefinitionStep({
    super.key,
    required this.draft,
    required this.organizationId,
  });

  @override
  State<GroupDefinitionStep> createState() => _GroupDefinitionStepState();
}

class _GroupDefinitionStepState extends State<GroupDefinitionStep> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  static const _attributes = [
    'Staff Group',
    'Volunteer Group',
    'Board-Related',
    'Location Focused',
    'Program Focused',
    'Event-Based',
    'Eligibility Requirements',
    'Temporary Group',
  ];

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.draft.name);
    _descriptionController = TextEditingController(
      text: widget.draft.description,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateDraft() {
    widget.draft.name = _nameController.text;
    widget.draft.description = _descriptionController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Group Definition',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Start by defining what this group is and who it belongs to.',
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 28),
        _buildGroupType(),
        const SizedBox(height: 26),
        _buildBasicInformation(),
        const SizedBox(height: 26),
        _buildAttributes(),
        const SizedBox(height: 26),
        _buildOwner(),
      ],
    );
  }

  Widget _buildGroupType() {
    return _section(
      title: 'Group Type',
      subtitle: 'Choose the type that best describes this group.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 760
              ? 4
              : constraints.maxWidth >= 500
              ? 2
              : 1;

          final spacing = 12.0;
          final width = columns == 1
              ? constraints.maxWidth
              : (constraints.maxWidth - spacing * (columns - 1)) / columns;

          const options = [
            CreateGroupTypeOption.team,
            CreateGroupTypeOption.committee,
            CreateGroupTypeOption.cohort,
            CreateGroupTypeOption.other,
          ];

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: options.map((option) {
              return SizedBox(width: width, child: _typeCard(option));
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _typeCard(CreateGroupTypeOption option) {
    final selected = widget.draft.groupTypeOption == option;

    return InkWell(
      onTap: () {
        setState(() {
          widget.draft.setGroupType(option);
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFECFEFF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF06B6D4) : const Color(0xFFE2E8F0),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _typeIcon(option),
              color: selected
                  ? const Color(0xFF0891B2)
                  : const Color(0xFF64748B),
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _typeLabel(option),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                size: 18,
                color: Color(0xFF06B6D4),
              ),
          ],
        ),
      ),
    );
  }

  IconData _typeIcon(CreateGroupTypeOption option) {
    switch (option) {
      case CreateGroupTypeOption.team:
        return Icons.groups_rounded;
      case CreateGroupTypeOption.committee:
        return Icons.account_balance_rounded;
      case CreateGroupTypeOption.cohort:
        return Icons.diversity_3_rounded;
      case CreateGroupTypeOption.other:
        return Icons.more_horiz_rounded;
    }
  }

  String _typeLabel(CreateGroupTypeOption option) {
    switch (option) {
      case CreateGroupTypeOption.team:
        return 'Team';
      case CreateGroupTypeOption.committee:
        return 'Committee';
      case CreateGroupTypeOption.cohort:
        return 'Cohort';
      case CreateGroupTypeOption.other:
        return 'Other';
    }
  }

  Widget _buildBasicInformation() {
    return _section(
      title: 'Basic Information',
      subtitle: 'Give the group a clear name and description.',
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            onChanged: (_) {
              setState(_updateDraft);
            },
            decoration: _inputDecoration(
              label: 'Group Name',
              hint: 'e.g. Falmouth ReStore Volunteers',
              required: true,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _descriptionController,
            onChanged: (_) {
              setState(_updateDraft);
            },
            minLines: 3,
            maxLines: 5,
            decoration: _inputDecoration(
              label: 'Description',
              hint: 'Describe the purpose of this group.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributes() {
    return _section(
      title: 'Group Attributes',
      subtitle: 'Select any characteristics that apply.',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _attributes.map((attribute) {
          final selected = widget.draft.attributes.contains(attribute);

          return FilterChip(
            selected: selected,
            label: Text(attribute),
            onSelected: (value) {
              setState(() {
                if (value) {
                  widget.draft.attributes.add(attribute);
                } else {
                  widget.draft.attributes.remove(attribute);
                }
              });
            },
            selectedColor: const Color(0xFFCFFAFE),
            checkmarkColor: const Color(0xFF0891B2),
            side: BorderSide(
              color: selected
                  ? const Color(0xFF06B6D4)
                  : const Color(0xFFE2E8F0),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOwner() {
    final ownerType = widget.draft.ownerType;

    return _section(
      title: 'Primary Owner',
      subtitle: 'Choose who this group mainly belongs to or is managed by.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;

          final ownerTypeField = DropdownButtonFormField<GroupOwnerType>(
            initialValue: ownerType,
            decoration: _inputDecoration(label: 'Primary Owner Type'),
            items: GroupOwnerType.values
                .where(
                  (type) =>
                      type == GroupOwnerType.organization ||
                      type == GroupOwnerType.location ||
                      type == GroupOwnerType.program,
                )
                .map(
                  (type) =>
                      DropdownMenuItem(value: type, child: Text(type.label)),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                widget.draft.ownerType = value;
                widget.draft.ownerId = value == GroupOwnerType.organization
                    ? widget.organizationId
                    : null;
              });
            },
          );

          final ownerField = _buildOwnerField(ownerType);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: compact
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 12) / 2,
                    child: ownerTypeField,
                  ),
                  SizedBox(
                    width: compact
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 12) / 2,
                    child: ownerField,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildOwnerGuidance(ownerType),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOwnerField(GroupOwnerType? ownerType) {
    switch (ownerType) {
      case GroupOwnerType.organization:
        return TextFormField(
          initialValue: 'Current Organization',
          enabled: false,
          decoration: _inputDecoration(label: 'Owner'),
        );

      case GroupOwnerType.location:
        return GroupOwnerLocationField(
          key: ValueKey(widget.draft.ownerId),
          organizationId: widget.organizationId,
          selectedLocationId: widget.draft.ownerId,
          onChanged: (location) {
            setState(() {
              widget.draft.ownerId = location?.id;
            });
          },
          onCreateLocation: _createLocation,
        );

      case GroupOwnerType.program:
        return TextFormField(
          enabled: false,
          decoration: _inputDecoration(
            label: 'Owner',
            hint: 'Program lookup will be available when Programs is added.',
          ),
        );

      case null:
        return TextFormField(
          enabled: false,
          decoration: _inputDecoration(
            label: 'Owner',
            hint: 'Select a Primary Owner Type first.',
          ),
        );

      default:
        return TextFormField(
          enabled: false,
          decoration: _inputDecoration(label: 'Owner'),
        );
    }
  }

  Widget _buildOwnerGuidance(GroupOwnerType? ownerType) {
    String title;
    String message;
    String example;

    switch (ownerType) {
      case GroupOwnerType.organization:
        title = 'When to use Organization';
        message = 'Use this when the group belongs to the whole organization.';
        example = 'Example: Board of Directors';
        break;

      case GroupOwnerType.location:
        title = 'When to use Location';
        message =
            'Use this when the group is mainly connected to one location.';
        example = 'Example: Falmouth ReStore Volunteer Team';
        break;

      case GroupOwnerType.program:
        title = 'When to use Program';
        message = 'Use this when the group is mainly connected to a program.';
        example = 'Example: Home Repair Volunteers';
        break;

      case null:
        title = 'What is Primary Owner?';
        message = 'Choose who this group mainly belongs to or is managed by.';
        example =
            'You can connect this group to other locations or programs later.';
        break;

      default:
        title = 'What is Primary Owner?';
        message = 'Choose who this group mainly belongs to or is managed by.';
        example =
            'You can connect this group to other locations or programs later.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFECFEFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFA5F3FC)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: Color(0xFF0891B2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF155E75),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  example,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    bool required = false,
  }) {
    return InputDecoration(
      labelText: required ? '$label *' : label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 1.5),
      ),
    );
  }

  Future<void> _createLocation() async {
    String? createdLocationId;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddLocationPage(
          organizationId: widget.organizationId,
          onCreated: (location) {
            createdLocationId = location.id;
            Navigator.of(context).pop();
          },
        ),
      ),
    );

    if (!mounted || createdLocationId == null) return;

    setState(() {
      widget.draft.ownerType = GroupOwnerType.location;
      widget.draft.ownerId = createdLocationId;
    });
  }
}
