import 'package:flutter/material.dart';

class ExternalRelationshipSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const ExternalRelationshipSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const List<_RelationshipOption> _options = [
    _RelationshipOption(
      value: 'Donor',
      description: 'Provides financial, in-kind, or other charitable support',
      icon: Icons.favorite_border_rounded,
    ),
    _RelationshipOption(
      value: 'Partner',
      description: 'Collaborates with your organization toward shared goals',
      icon: Icons.handshake_outlined,
    ),
    _RelationshipOption(
      value: 'Vendor',
      description: 'Provides products, services, or professional support',
      icon: Icons.storefront_outlined,
    ),
    _RelationshipOption(
      value: 'Community Member',
      description: 'Connected to your organization or community',
      icon: Icons.groups_outlined,
    ),
    _RelationshipOption(
      value: 'Other',
      description: 'A custom or unique external relationship',
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
          'Relationship Type',
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
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.80,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Text(
                    'Choose relationship type',
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
                      return _RelationshipOptionTile(
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

class _RelationshipOption {
  final String value;
  final String description;
  final IconData icon;

  const _RelationshipOption({
    required this.value,
    required this.description,
    required this.icon,
  });
}

class _RelationshipOptionTile extends StatelessWidget {
  final _RelationshipOption option;
  final bool selected;
  final VoidCallback onTap;

  const _RelationshipOptionTile({
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
