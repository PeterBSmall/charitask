import 'package:flutter/material.dart';

import '../data/workspace_template_data.dart';

class WorkspaceTemplateCard extends StatelessWidget {
  final WorkspaceTemplate template;
  final bool isSelected;
  final VoidCallback onTap;

  const WorkspaceTemplateCard({
    super.key,
    required this.template,
    required this.isSelected,
    required this.onTap,
  });

  static const Color _textColor = Color(0xFF1E293B);
  static const Color _secondaryTextColor = Color(0xFF64748B);
  static const Color _borderColor = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? template.iconBackgroundColor : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? template.accentColor : _borderColor,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildIcon(),
                  const SizedBox(width: 14),
                  Expanded(child: _buildContent()),
                ],
              ),

              if (isSelected)
                Positioned(top: 0, right: 0, child: _buildCheckmark()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isSelected ? template.accentColor : template.iconBackgroundColor,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        template.icon,
        size: 23,
        color: isSelected ? Colors.white : template.accentColor,
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            template.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              height: 1.15,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            template.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.35,
              color: _secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckmark() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: template.accentColor,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check, size: 15, color: Colors.white),
    );
  }
}
