import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/people/data/services/people_service.dart';
import 'package:charitask/modules/people/domain/models/people_access_person.dart';
import 'package:charitask/modules/people/domain/services/people_access_service.dart';

class PeopleAccessPicker extends StatefulWidget {
  const PeopleAccessPicker({
    super.key,
    required this.organizationId,
    this.initialSelectedPeople = const [],
    this.onChanged,
    this.onAddNewPerson,
    this.title = 'Add People',
    this.subtitle =
        'Search for people in your organization or add someone new.',
  });

  final String organizationId;
  final List<PeopleAccessPerson> initialSelectedPeople;
  final ValueChanged<List<PeopleAccessPerson>>? onChanged;
  final VoidCallback? onAddNewPerson;
  final String title;
  final String subtitle;

  @override
  State<PeopleAccessPicker> createState() => _PeopleAccessPickerState();
}

class _PeopleAccessPickerState extends State<PeopleAccessPicker> {
  late final PeopleAccessService _accessService;

  final TextEditingController _searchController = TextEditingController();

  List<PeopleAccessPerson> _people = [];
  final Set<String> _selectedIds = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();

    _accessService = PeopleAccessService(
      PeopleService(Supabase.instance.client),
    );

    for (final person in widget.initialSelectedPeople) {
      _selectedIds.add(person.id);
    }

    _loadPeople();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPeople() async {
    try {
      final people = await _accessService.searchPeople(
        organizationId: widget.organizationId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _people = people;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  List<PeopleAccessPerson> get _filteredPeople {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return _people;
    }

    return _people.where((person) {
      return person.displayName.toLowerCase().contains(query) ||
          person.firstName.toLowerCase().contains(query) ||
          person.lastName.toLowerCase().contains(query) ||
          (person.email?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  void _togglePerson(PeopleAccessPerson person) {
    setState(() {
      if (_selectedIds.contains(person.id)) {
        _selectedIds.remove(person.id);
      } else {
        _selectedIds.add(person.id);
      }
    });

    _notifyChanged();
  }

  void _notifyChanged() {
    if (widget.onChanged == null) {
      return;
    }

    final selected = _people
        .where((person) => _selectedIds.contains(person.id))
        .toList();

    widget.onChanged!(selected);
  }

  bool get _hasSearchQuery => _searchController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 16),
            _buildSearchField(theme),
            const SizedBox(height: 16),
            if (_selectedIds.isNotEmpty) ...[
              _buildSelectionSummary(theme),
              const SizedBox(height: 12),
            ],
            _buildPeopleContent(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF06B6D4).withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.people_outline, color: Color(0xFF06B6D4)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Search people by name or email...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _hasSearchQuery
            ? IconButton(
                tooltip: 'Clear search',
                icon: const Icon(Icons.close),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              )
            : null,
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.45,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSelectionSummary(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF06B6D4).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 20,
            color: Color(0xFF06B6D4),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${_selectedIds.length} ${_selectedIds.length == 1 ? 'person' : 'people'} selected',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0E7490),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeopleContent(ThemeData theme) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return _buildErrorState(theme);
    }

    final people = _filteredPeople;

    if (people.isEmpty) {
      return _buildEmptyState(theme);
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 360),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: people.length,
        separatorBuilder: (_, __) => const SizedBox(height: 6),
        itemBuilder: (context, index) {
          return _buildPersonTile(theme, people[index]);
        },
      ),
    );
  }

  Widget _buildPersonTile(ThemeData theme, PeopleAccessPerson person) {
    final selected = _selectedIds.contains(person.id);

    return Material(
      color: selected
          ? const Color(0xFF06B6D4).withValues(alpha: 0.08)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _togglePerson(person),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              _buildAvatar(theme, person),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (person.email != null &&
                        person.email!.trim().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        person.email!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                selected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: selected
                    ? const Color(0xFF06B6D4)
                    : theme.colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme, PeopleAccessPerson person) {
    final initials = [person.firstName, person.lastName]
        .where((value) => value.trim().isNotEmpty)
        .map((value) => value.trim()[0].toUpperCase())
        .take(2)
        .join();

    return CircleAvatar(
      radius: 21,
      backgroundColor: const Color(0xFF06B6D4).withValues(alpha: 0.12),
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: theme.textTheme.labelLarge?.copyWith(
          color: const Color(0xFF0E7490),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    final searching = _searchController.text.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.35,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            searching ? Icons.person_search_outlined : Icons.people_outline,
            size: 36,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 10),
          Text(
            searching ? 'No people found' : 'No people available',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            searching
                ? 'Try another name or email address.'
                : 'There are no people available to add yet.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (searching && widget.onAddNewPerson != null) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: widget.onAddNewPerson,
              icon: const Icon(Icons.person_add_outlined),
              label: const Text('Add New Person'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'We could not load people right now.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          IconButton(
            tooltip: 'Retry',
            onPressed: () {
              setState(() {
                _isLoading = true;
                _error = null;
              });
              _loadPeople();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
