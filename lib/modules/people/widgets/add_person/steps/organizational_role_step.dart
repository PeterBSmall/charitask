import 'package:flutter/material.dart';

import 'organizational_role_summary_card.dart';

class OrganizationalRoleStep extends StatelessWidget {
  const OrganizationalRoleStep({
    super.key,
    required this.personType,
    required this.primaryAreaOfResponsibility,
    required this.boardPosition,
    required this.jobTitleController,
    required this.personTypeOptions,
    required this.areaOfResponsibilityOptions,
    required this.boardPositionOptions,
    required this.onPersonTypeChanged,
    required this.onPrimaryAreaOfResponsibilityChanged,
    required this.onBoardPositionChanged,
  });

  final String personType;
  final String primaryAreaOfResponsibility;
  final String boardPosition;
  final TextEditingController jobTitleController;

  final List<String> personTypeOptions;
  final List<String> areaOfResponsibilityOptions;
  final List<String> boardPositionOptions;

  final ValueChanged<String> onPersonTypeChanged;
  final ValueChanged<String> onPrimaryAreaOfResponsibilityChanged;
  final ValueChanged<String> onBoardPositionChanged;

  String _personTypeDescription(String type) {
    switch (type) {
      case 'Founder / Owner':
        return 'Leads or owns the organization and is responsible for its overall direction.';
      case 'Executive Leadership':
        return 'Provides senior leadership and helps guide organization-wide strategy and decisions.';
      case 'Staff Member':
        return 'Performs ongoing work for the organization as a staff member.';
      case 'Volunteer':
        return 'Contributes time and skills to support the organization’s mission without being a regular staff employee.';
      case 'Board Member':
        return 'Provides governance, oversight, and strategic guidance as a member of the organization’s board.';
      case 'Donor':
        return 'Supports the organization through financial or in-kind contributions.';
      case 'Contractor':
        return 'Provides specialized services or expertise to the organization as an independent contractor.';
      case 'Partner Contact':
        return 'Represents a partner organization or community partner in an organizational relationship.';
      case 'Vendor Contact':
        return 'Represents a vendor or supplier that works with the organization.';
      case 'Community Member':
        return 'Participates in or connects with the organization as a member of the community.';
      default:
        return '';
    }
  }

  bool get _showAreaOfResponsibility {
    return personType == 'Founder / Owner' ||
        personType == 'Executive Leadership' ||
        personType == 'Staff Member' ||
        personType == 'Volunteer' ||
        personType == 'Contractor';
  }

  bool get _areaOfResponsibilityRequired {
    return personType == 'Executive Leadership' || personType == 'Staff Member';
  }

  bool get _showJobTitle {
    return personType == 'Founder / Owner' ||
        personType == 'Executive Leadership' ||
        personType == 'Staff Member' ||
        personType == 'Volunteer';
  }

  bool get _jobTitleRequired {
    return personType == 'Executive Leadership' || personType == 'Staff Member';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1000;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 280,
                      child: OrganizationalRoleSummaryCard(
                        organizationalRole: personType,
                      ),
                    ),
                    const SizedBox(width: 48),
                    Expanded(child: _buildForm()),
                  ],
                )
              : _buildForm(),
        );
      },
    );
  }

  Widget _buildForm() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What kind of person is this?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF292333),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select the type of person and provide the information that applies to them.',
            style: TextStyle(fontSize: 14, color: Color(0xFF6F687A)),
          ),
          const SizedBox(height: 28),

          const _SectionLabel(title: 'Person Type', required: true),
          const SizedBox(height: 10),
          _ChoiceDropdown(
            value: personType.isEmpty ? null : personType,
            hint: 'Select person type',
            items: personTypeOptions,
            onChanged: (value) {
              if (value != null) {
                onPersonTypeChanged(value);
              }
            },
          ),

          if (personType.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              _personTypeDescription(personType),
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Color(0xFF6F687A),
              ),
            ),
          ],

          if (personType == 'Board Member') ...[
            const SizedBox(height: 24),
            const _SectionLabel(title: 'Board Position', required: false),
            const SizedBox(height: 10),
            _ChoiceDropdown(
              value: boardPosition.isEmpty ? null : boardPosition,
              hint: 'Select board position',
              items: boardPositionOptions,
              onChanged: (value) {
                if (value != null) {
                  onBoardPositionChanged(value);
                }
              },
            ),
          ],

          if (_showAreaOfResponsibility) ...[
            const SizedBox(height: 24),
            _SectionLabel(
              title: 'Primary Area of Responsibility',
              required: _areaOfResponsibilityRequired,
            ),
            const SizedBox(height: 10),
            _ChoiceDropdown(
              value: primaryAreaOfResponsibility.isEmpty
                  ? null
                  : primaryAreaOfResponsibility,
              hint: 'Select area of responsibility',
              items: areaOfResponsibilityOptions,
              onChanged: (value) {
                if (value != null) {
                  onPrimaryAreaOfResponsibilityChanged(value);
                }
              },
            ),
          ],

          if (_showJobTitle) ...[
            const SizedBox(height: 24),
            _SectionLabel(title: 'Job Title', required: _jobTitleRequired),
            const SizedBox(height: 10),
            TextField(
              controller: jobTitleController,
              decoration: InputDecoration(
                hintText: _jobTitleRequired
                    ? 'Enter job title'
                    : 'Enter job title (optional)',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2DDEB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2DDEB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF7C4DFF),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 15,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, required this.required});

  final String title;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF40394D),
            ),
          ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              color: Color(0xFF7C4DFF),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class _ChoiceDropdown extends StatelessWidget {
  const _ChoiceDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: value != null ? const Color(0xFFF0EBFF) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2DDEB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: value != null
                ? const Color(0xFF7C4DFF)
                : const Color(0xFFE2DDEB),
            width: value != null ? 1.5 : 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF7C4DFF), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: item == value
                      ? const Color(0xFFF0EBFF)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    color: item == value
                        ? const Color(0xFF7C4DFF)
                        : const Color(0xFF292333),
                    fontWeight: item == value
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
          .toList(),
      selectedItemBuilder: (context) {
        return items.map((item) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item,
              style: const TextStyle(
                color: Color(0xFF292333),
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList();
      },
      onChanged: onChanged,
    );
  }
}
