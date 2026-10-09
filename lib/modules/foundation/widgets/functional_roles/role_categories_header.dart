import 'package:flutter/material.dart';

class RoleCategoriesHeader extends StatelessWidget {
  final bool compact;

  const RoleCategoriesHeader({super.key, required this.compact});

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: 16),
          _buildCreateButton(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildTitle()),
        const SizedBox(width: 20),
        _buildCreateButton(),
      ],
    );
  }

  Widget _buildTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select a Department',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Select a department to view and manage its functional roles.',
          style: TextStyle(fontSize: 15, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return FilledButton.icon(
      onPressed: null,
      icon: const Icon(Icons.add),
      label: const Text('Create Category'),
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF5B3FD3),
        disabledBackgroundColor: const Color(0xFF5B3FD3),
        disabledForegroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
    );
  }
}
