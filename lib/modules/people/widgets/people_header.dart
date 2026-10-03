import 'package:flutter/material.dart';

class PeopleHeader extends StatelessWidget {
  const PeopleHeader({super.key, this.onAddPerson, this.onImportPeople});

  final VoidCallback? onAddPerson;
  final VoidCallback? onImportPeople;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 760) {
          return _buildCompactHeader();
        }

        return _buildDesktopHeader();
      },
    );
  }

  Widget _buildDesktopHeader() {
    return Row(
      children: [
        _buildDesktopTitle(),
        const SizedBox(width: 24),
        _buildAddPersonButton(),
        const SizedBox(width: 12),
        _buildImportPeopleButton(),
      ],
    );
  }

  Widget _buildCompactHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCompactTitle(),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [_buildAddPersonButton(), _buildImportPeopleButton()],
        ),
      ],
    );
  }

  Widget _buildDesktopTitle() {
    return Expanded(
      child: Row(
        children: [
          const Icon(Icons.people_outline, size: 32, color: Color(0xFF5B4BC4)),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'People',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2F3A4A),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Manage and connect people in your organization.',
                  style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.people_outline, size: 32, color: Color(0xFF5B4BC4)),
        const SizedBox(width: 16),
        const Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'People',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2F3A4A),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Manage and connect people in your organization.',
                softWrap: true,
                style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddPersonButton() {
    return ElevatedButton.icon(
      onPressed: onAddPerson,
      icon: const Icon(Icons.add),
      label: const Text('Add Person'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5B4BC4),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildImportPeopleButton() {
    return OutlinedButton.icon(
      onPressed: onImportPeople,
      icon: const Icon(Icons.upload_outlined),
      label: const Text('Import People'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF6B7280),
        side: const BorderSide(color: Color(0xFFE2E5EC)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
