import 'package:flutter/material.dart';

import 'package:charitask/modules/groups/domain/models/create_group_draft.dart';
import 'package:charitask/modules/people/domain/models/people_access_person.dart';
import 'package:charitask/modules/people/widgets/people_access/people_access_picker.dart';

class GroupMembershipStep extends StatefulWidget {
  final CreateGroupDraft draft;
  final String organizationId;

  const GroupMembershipStep({
    super.key,
    required this.draft,
    required this.organizationId,
  });

  @override
  State<GroupMembershipStep> createState() => _GroupMembershipStepState();
}

class _GroupMembershipStepState extends State<GroupMembershipStep> {
  bool _addMembersNow = false;

  @override
  void initState() {
    super.initState();
    _addMembersNow = widget.draft.memberIds.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Membership',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Choose whether to add people now or build the group first.',
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 28),
        _buildMembershipChoice(),
        const SizedBox(height: 24),
        if (_addMembersNow) _buildPeopleSection(),
      ],
    );
  }

  Widget _buildMembershipChoice() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;

        final children = [
          _membershipChoiceCard(
            icon: Icons.person_add_alt_1_rounded,
            title: 'Add Members Now',
            description:
                'Select people who should belong to this group as soon as it is created.',
            selected: _addMembersNow,
            onTap: () {
              setState(() {
                _addMembersNow = true;
              });
            },
          ),
          _membershipChoiceCard(
            icon: Icons.people_outline_rounded,
            title: 'Add Members Later',
            description:
                'Create the group now and manage membership after setup.',
            selected: !_addMembersNow,
            onTap: () {
              setState(() {
                _addMembersNow = false;
                widget.draft.memberIds.clear();
                widget.draft.memberRoles.clear();
              });
            },
          ),
        ];

        if (isNarrow) {
          return Column(
            children: [children[0], const SizedBox(height: 12), children[1]],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: children[0]),
            const SizedBox(width: 12),
            Expanded(child: children[1]),
          ],
        );
      },
    );
  }

  Widget _membershipChoiceCard({
    required IconData icon,
    required String title,
    required String description,
    required bool selected,
    required VoidCallback onTap,
  }) {
    const cyan = Color(0xFF06B6D4);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFECFEFF) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? cyan : const Color(0xFFE2E8F0),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFCFFAFE)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  size: 21,
                  color: selected ? cyan : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _selectionIndicator(selected),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectionIndicator(bool selected) {
    const cyan = Color(0xFF06B6D4);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? cyan : Colors.white,
        border: Border.all(
          color: selected ? cyan : const Color(0xFFCBD5E1),
          width: 1.5,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, size: 13, color: Colors.white)
          : null,
    );
  }

  Widget _buildPeopleSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.people_alt_outlined,
                size: 20,
                color: Color(0xFF06B6D4),
              ),
              SizedBox(width: 9),
              Text(
                'People Access',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            'Select existing people to assign to this group.',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 18),
          PeopleAccessPicker(
            organizationId: widget.organizationId,
            initialSelectedPeople: _selectedPeople(),
            title: 'Add People',
            subtitle:
                'Existing people will be assigned to this group. New people can be added through the People workflow.',
            onChanged: _handlePeopleChanged,
            onAddNewPerson: _handleAddNewPerson,
          ),
          if (widget.draft.memberIds.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildSelectedMembers(),
          ],
        ],
      ),
    );
  }

  List<PeopleAccessPerson> _selectedPeople() {
    return const [];
  }

  void _handlePeopleChanged(List<PeopleAccessPerson> people) {
    setState(() {
      widget.draft.memberIds
        ..clear()
        ..addAll(people.map((person) => person.id));

      for (final person in people) {
        widget.draft.memberRoles.putIfAbsent(person.id, () => 'member');
      }

      widget.draft.memberRoles.removeWhere(
        (personId, _) => !widget.draft.memberIds.contains(personId),
      );
    });
  }

  Future<void> _handleAddNewPerson() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New people will be added through the People workflow.'),
      ),
    );
  }

  Widget _buildSelectedMembers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        const SizedBox(height: 18),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Selected Members',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            _countBadge(widget.draft.memberIds.length),
          ],
        ),
        const SizedBox(height: 12),
        ...widget.draft.memberIds.map(_buildMemberRow),
      ],
    );
  }

  Widget _buildMemberRow(String personId) {
    final role = widget.draft.memberRoles[personId] ?? 'member';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 17,
            backgroundColor: Color(0xFFCFFAFE),
            child: Icon(
              Icons.person_outline,
              size: 18,
              color: Color(0xFF0891B2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              personId,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: Color(0xFF334155)),
            ),
          ),
          const SizedBox(width: 8),
          _buildRoleDropdown(personId, role),
        ],
      ),
    );
  }

  Widget _buildRoleDropdown(String personId, String role) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: role,
        isDense: true,
        items: const [
          DropdownMenuItem(value: 'leader', child: Text('Leader')),
          DropdownMenuItem(value: 'co_leader', child: Text('Co-Leader')),
          DropdownMenuItem(value: 'coordinator', child: Text('Coordinator')),
          DropdownMenuItem(value: 'member', child: Text('Member')),
        ],
        onChanged: (value) {
          if (value == null) {
            return;
          }

          setState(() {
            widget.draft.memberRoles[personId] = value;
          });
        },
      ),
    );
  }

  Widget _countBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFCFFAFE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0E7490),
        ),
      ),
    );
  }
}
