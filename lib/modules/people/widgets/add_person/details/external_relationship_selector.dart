import 'package:flutter/material.dart';

class ExternalRelationshipSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const ExternalRelationshipSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const List<_ExternalRelationshipOption> _options = [
    _ExternalRelationshipOption(
      value: 'Donor',
      description: 'Supports your organization through financial contributions',
      icon: Icons.volunteer_activism_outlined,
    ),
    _ExternalRelationshipOption(
      value: 'Customer',
      description: 'Receives products, services, or support',
      icon: Icons.shopping_bag_outlined,
    ),
    _ExternalRelationshipOption(
      value: 'Vendor',
      description: 'Provides products or services to your organization',
      icon: Icons.storefront_outlined,
    ),
    _ExternalRelationshipOption(
      value: 'Partner',
      description: 'Works collaboratively with your organization',
      icon: Icons.handshake_outlined,
    ),
    _ExternalRelationshipOption(
      value: 'Contact',
      description: 'An external person connected to your organization',
      icon: Icons.person_outline_rounded,
    ),
    _ExternalRelationshipOption(
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
      builder: (context) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(12),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
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
            child: SingleChildScrollView(
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

                  ..._options.map(
                    (option) => _ExternalRelationshipOptionTile(
                      option: option,
                      selected: option.value == value,
                      onTap: () {
                        onChanged(option.value);
                        Navigator.of(context).pop();
                      },
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

class _ExternalRelationshipOption {
  final String value;
  final String description;
  final IconData icon;

  const _ExternalRelationshipOption({
    required this.value,
    required this.description,
    required this.icon,
  });
}

class _ExternalRelationshipOptionTile extends StatelessWidget {
  final _ExternalRelationshipOption option;
  final bool selected;
  final VoidCallback onTap;

  const _ExternalRelationshipOptionTile({
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
