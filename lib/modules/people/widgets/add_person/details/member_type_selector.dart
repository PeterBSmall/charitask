import 'package:flutter/material.dart';

class MemberTypeSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const MemberTypeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const List<_MemberTypeOption> _options = [
    _MemberTypeOption(
      value: 'Staff',
      description: 'Paid employee or long-term team member',
      icon: Icons.badge_outlined,
    ),
    _MemberTypeOption(
      value: 'Volunteer',
      description: 'Unpaid contributor',
      icon: Icons.volunteer_activism_outlined,
    ),
    _MemberTypeOption(
      value: 'Intern',
      description: 'Temporary learning or training role',
      icon: Icons.school_outlined,
    ),
    _MemberTypeOption(
      value: 'Board Member',
      description: 'Governance and organizational leadership',
      icon: Icons.account_balance_outlined,
    ),
    _MemberTypeOption(
      value: 'Contractor',
      description: 'Paid external worker or service provider',
      icon: Icons.handyman_outlined,
    ),
    _MemberTypeOption(
      value: 'Other',
      description: 'Custom or unique relationship',
      icon: Icons.more_horiz_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedOption = _options.firstWhere(
      (option) => option.value == value,
      orElse: () => _options.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Member Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),

        const SizedBox(height: 8),

        InkWell(
          onTap: () => _showSelector(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E4EA)),
            ),
            child: Row(
              children: [
                Icon(selectedOption.icon, color: const Color(0xFF5B3FC4)),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    selectedOption.value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2F3A4A),
                    ),
                  ),
                ),

                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF6B7280),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 56,
            vertical: 32,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720, maxHeight: 700),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 30,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(32, 28, 32, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Choose member type',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2F3A4A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Column(
                        children: _options
                            .map(
                              (option) => _MemberTypeOptionTile(
                                option: option,
                                selected: option.value == value,
                                onTap: () {
                                  onChanged(option.value);

                                  Navigator.of(dialogContext).pop();
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),

                  const Divider(height: 1),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF5B3FC4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MemberTypeOption {
  final String value;
  final String description;
  final IconData icon;

  const _MemberTypeOption({
    required this.value,
    required this.description,
    required this.icon,
  });
}

class _MemberTypeOptionTile extends StatelessWidget {
  final _MemberTypeOption option;
  final bool selected;
  final VoidCallback onTap;

  const _MemberTypeOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF1EEFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: selected ? Border.all(color: const Color(0xFFD8CEFF)) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFDDD5FF)
                    : const Color(0xFFF4F4F5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                option.icon,
                color: const Color(0xFF5B3FC4),
                size: 23,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.value,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2F3A4A),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    option.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),

            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF5B3FC4),
                size: 26,
              ),
          ],
        ),
      ),
    );
  }
}
