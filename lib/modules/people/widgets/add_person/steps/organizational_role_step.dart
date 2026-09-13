import 'package:flutter/material.dart';
import 'organizational_role_summary_card.dart';

class OrganizationalRoleStep extends StatelessWidget {
  const OrganizationalRoleStep({
    super.key,
    required this.organizationalRole,
    required this.primaryDepartment,
    required this.jobTitleController,
    required this.organizationalRoleOptions,
    required this.departmentOptions,
    required this.onOrganizationalRoleChanged,
    required this.onPrimaryDepartmentChanged,
  });

  final String organizationalRole;
  final String primaryDepartment;
  final TextEditingController jobTitleController;
  final List<String> organizationalRoleOptions;
  final List<String> departmentOptions;
  final ValueChanged<String> onOrganizationalRoleChanged;
  final ValueChanged<String> onPrimaryDepartmentChanged;

  String _roleDescription(String role) {
    switch (role) {
      case 'Founder / Owner':
        return 'Leads or owns the organization and is responsible for its overall direction.';
      case 'Executive Leadership':
        return 'Provides senior leadership and helps guide organization-wide strategy and decisions.';
      case 'Director':
        return 'Leads a major area of the organization and is responsible for its programs, people, or operations.';
      case 'Manager':
        return 'Oversees day-to-day work, people, or operations within a team or area.';
      case 'Team Lead':
        return 'Guides a team’s day-to-day work and helps coordinate people and priorities.';
      case 'Staff Member':
        return 'Performs day-to-day operational work and typically reports to a manager or team lead.';
      case 'Volunteer':
        return 'Contributes time and skills to support the organization’s mission without being a regular staff employee.';
      case 'Board Member':
        return 'Provides governance, oversight, and strategic guidance as a member of the organization’s board.';
      default:
        return '';
    }
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
                        organizationalRole: organizationalRole,
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
            'Which best describes this person\'s role in the organization?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF292333),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This helps standardize how people are organized across ChariTask.',
            style: TextStyle(fontSize: 14, color: Color(0xFF6F687A)),
          ),
          const SizedBox(height: 28),

          _SectionLabel(title: 'Organizational Role', required: true),
          const SizedBox(height: 10),
          _ChoiceDropdown(
            value: organizationalRole.isEmpty ? null : organizationalRole,
            hint: 'Select organizational role',
            items: organizationalRoleOptions,
            onChanged: (value) {
              if (value != null) {
                onOrganizationalRoleChanged(value);
              }
            },
          ),

          if (organizationalRole.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              _roleDescription(organizationalRole),
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Color(0xFF6F687A),
              ),
            ),
          ],

          const SizedBox(height: 24),

          _SectionLabel(title: 'Primary Department', required: false),
          const SizedBox(height: 10),
          _ChoiceDropdown(
            value: primaryDepartment.isEmpty ? null : primaryDepartment,
            hint: 'Select primary department',
            items: departmentOptions,
            onChanged: (value) {
              if (value != null) {
                onPrimaryDepartmentChanged(value);
              }
            },
          ),

          const SizedBox(height: 24),

          _SectionLabel(title: 'Job Title', required: false),
          const SizedBox(height: 10),
          TextField(
            controller: jobTitleController,
            decoration: InputDecoration(
              hintText: 'Enter job title (optional)',
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
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF40394D),
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
