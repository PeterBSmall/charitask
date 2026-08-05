import 'package:flutter/material.dart';

class OrganizationOptionCard extends StatelessWidget {
  const OrganizationOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String description;
  final Widget icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Row(
          children: [
            _buildIconBubble(),

            const SizedBox(width: 16),

            Expanded(child: _buildContent()),

            _buildSelectionIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBubble() {
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade100,
      ),
      child: icon,
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildSelectionIndicator() {
    return Icon(
      selected ? Icons.check_circle : Icons.radio_button_unchecked,
      color: selected ? Colors.deepPurple : Colors.grey.shade400,
      size: 26,
    );
  }
}
