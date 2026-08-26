import 'package:flutter/material.dart';

class DonorTypeSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const DonorTypeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const List<_DonorTypeOption> _options = [
    _DonorTypeOption(
      value: 'Individual Donor',
      description: 'An individual who supports your organization financially',
      icon: Icons.person_outline_rounded,
    ),
    _DonorTypeOption(
      value: 'Major Donor',
      description: 'A significant individual financial supporter',
      icon: Icons.star_outline_rounded,
    ),
    _DonorTypeOption(
      value: 'Recurring Donor',
      description: 'Provides ongoing or recurring financial support',
      icon: Icons.repeat_rounded,
    ),
    _DonorTypeOption(
      value: 'Corporate Donor',
      description: 'A business or company that provides support',
      icon: Icons.business_outlined,
    ),
    _DonorTypeOption(
      value: 'Foundation / Grantor',
      description: 'Provides grants or institutional funding',
      icon: Icons.account_balance_outlined,
    ),
    _DonorTypeOption(
      value: 'Sponsor',
      description: 'Supports a program, event, initiative, or organization',
      icon: Icons.workspace_premium_outlined,
    ),
    _DonorTypeOption(
      value: 'In-Kind Donor',
      description:
          'Contributes goods, services, space, property, or other resources',
      icon: Icons.volunteer_activism_outlined,
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
          'Donor Type',
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxHeight: 650),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Text(
                    'Choose donor type',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2F3A4A),
                    ),
                  ),
                ),

                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: _options.map((option) {
                      return _DonorTypeOptionTile(
                        option: option,
                        selected: option.value == value,
                        onTap: () {
                          onChanged(option.value);
                          Navigator.of(context).pop();
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DonorTypeOption {
  final String value;
  final String description;
  final IconData icon;

  const _DonorTypeOption({
    required this.value,
    required this.description,
    required this.icon,
  });
}

class _DonorTypeOptionTile extends StatelessWidget {
  final _DonorTypeOption option;
  final bool selected;
  final VoidCallback onTap;

  const _DonorTypeOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF1EEFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFDDD5FF)
                    : const Color(0xFFF4F4F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                option.icon,
                color: const Color(0xFF5B3FC4),
                size: 21,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2F3A4A),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    option.description,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),

            if (selected)
              const Icon(Icons.check_circle_rounded, color: Color(0xFF5B3FC4)),
          ],
        ),
      ),
    );
  }
}
