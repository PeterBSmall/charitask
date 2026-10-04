import 'package:flutter/material.dart';

class RoleCategoriesToolbar extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onRefresh;
  final bool loading;

  const RoleCategoriesToolbar({
    super.key,
    required this.onSearchChanged,
    required this.onRefresh,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 650;

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearch(),
              const SizedBox(height: 12),
              _buildRefresh(),
            ],
          );
        }

        return Row(
          children: [
            SizedBox(width: 360, child: _buildSearch()),
            const SizedBox(width: 12),
            _buildRefresh(),
          ],
        );
      },
    );
  }

  Widget _buildSearch() {
    return TextField(
      onChanged: onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Search categories...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
    );
  }

  Widget _buildRefresh() {
    return OutlinedButton.icon(
      onPressed: loading ? null : onRefresh,
      icon: loading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.refresh),
      label: Text(loading ? 'Loading...' : 'Refresh'),
    );
  }
}
