import 'package:flutter/material.dart';

class AddPersonHeader extends StatelessWidget {
  const AddPersonHeader({
    super.key,
    required this.onCancel,
    required this.onSaveDraft,
  });

  final VoidCallback onCancel;
  final VoidCallback onSaveDraft;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 1100;

        if (isCompact) {
          return _buildCompactHeader();
        }

        return _buildDesktopHeader();
      },
    );
  }

  Widget _buildDesktopHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Row(
        children: [
          const Icon(
            Icons.person_add_alt_1_outlined,
            size: 32,
            color: Color(0xFF5B4BC4),
          ),
          const SizedBox(width: 16),
          Expanded(child: _buildTitleContent()),
          const SizedBox(width: 16),
          _buildCancelButton(),
          const SizedBox(width: 12),
          _buildSaveDraftButton(),
          const SizedBox(width: 8),
          _buildCloseButton(),
        ],
      ),
    );
  }

  Widget _buildCompactHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.person_add_alt_1_outlined,
                size: 32,
                color: Color(0xFF5B4BC4),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildTitleContent()),
              const SizedBox(width: 8),
              _buildCloseButton(),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [_buildCancelButton(), _buildSaveDraftButton()],
          ),
        ],
      ),
    );
  }

  Widget _buildTitleContent() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Person',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2F3A4A),
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Add a new person and connect them to your organization.',
          softWrap: true,
          style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildCancelButton() {
    return OutlinedButton(onPressed: onCancel, child: const Text('Cancel'));
  }

  Widget _buildSaveDraftButton() {
    return ElevatedButton(
      onPressed: onSaveDraft,
      child: const Text('Save Draft'),
    );
  }

  Widget _buildCloseButton() {
    return IconButton(
      onPressed: onCancel,
      icon: const Icon(Icons.close),
      tooltip: 'Close',
    );
  }
}
