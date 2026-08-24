import 'package:flutter/material.dart';
import 'package:charitask/modules/people/widgets/add_person/add_person_text_field.dart';

class MembershipStep extends StatelessWidget {
  const MembershipStep({
    super.key,
    required this.membershipStatus,
    required this.roleCategory,
    required this.joinDateController,
    required this.onMembershipStatusChanged,
    required this.onRoleCategoryChanged,
  });

  final String membershipStatus;
  final String roleCategory;
  final TextEditingController joinDateController;
  final ValueChanged<String> onMembershipStatusChanged;
  final ValueChanged<String> onRoleCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT STORY PANEL
              Expanded(
                flex: 5,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 600),
                  padding: const EdgeInsets.all(48),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFF4F1FF), Color(0xFFEDEAFF)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Every role has\na purpose.',
                        style: TextStyle(
                          fontSize: 42,
                          height: 1.1,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2F3A4A),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Define how this person fits into your organization and help ChariTask understand their journey.',
                        style: TextStyle(
                          fontSize: 17,
                          height: 1.6,
                          color: Color(0xFF6B7280),
                        ),
                      ),

                      const Spacer(),

                      Center(
                        child: Container(
                          width: 230,
                          height: 230,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.55),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.account_tree_outlined,
                            size: 100,
                            color: Color(0xFF5B4BC4),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      const Center(
                        child: Text(
                          'People grow. Roles evolve.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF5B4BC4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 64),

              // RIGHT FORM PANEL
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2F3A4A),
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Tell us a little more about this person and their relationship with your organization.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),

                      const SizedBox(height: 48),

                      const Text(
                        'Membership Status',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF374151),
                        ),
                      ),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        value: membershipStatus,
                        decoration: _inputDecoration(),
                        items: const [
                          DropdownMenuItem(
                            value: 'Active',
                            child: Text('Active'),
                          ),
                          DropdownMenuItem(
                            value: 'Inactive',
                            child: Text('Inactive'),
                          ),
                          DropdownMenuItem(
                            value: 'Pending',
                            child: Text('Pending'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            onMembershipStatusChanged(value);
                          }
                        },
                      ),

                      const SizedBox(height: 28),

                      Row(
                        children: [
                          Expanded(
                            child: AddPersonTextField(
                              label: 'Join Date',
                              controller: joinDateController,
                              hint: 'MM/DD/YYYY',
                              keyboardType: TextInputType.datetime,
                              required: false,
                            ),
                          ),

                          const SizedBox(width: 20),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Role Category',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF374151),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                DropdownButtonFormField<String>(
                                  value: roleCategory,
                                  decoration: _inputDecoration(),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Staff',
                                      child: Text('Staff'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Volunteer',
                                      child: Text('Volunteer'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Board',
                                      child: Text('Board'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Other',
                                      child: Text('Other'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      onRoleCategoryChanged(value);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F7FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE1DDFC)),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.auto_awesome_outlined,
                              color: Color(0xFF5B4BC4),
                            ),

                            SizedBox(width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'This can change later',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2F3A4A),
                                    ),
                                  ),

                                  SizedBox(height: 4),

                                  Text(
                                    'People can take on new roles, change their status, or become connected to your organization in new ways.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE1E5EC)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE1E5EC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF5B4BC4), width: 2),
      ),
    );
  }
}
