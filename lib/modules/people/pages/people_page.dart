import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/people/data/repositories/people_repository_impl.dart';
import 'package:charitask/modules/people/data/services/people_service.dart';
import 'package:charitask/modules/people/domain/repositories/people_repository.dart';
import 'package:charitask/modules/people/pages/add_person_page.dart';
import 'package:charitask/modules/people/widgets/people_header.dart';
import 'package:charitask/modules/people/widgets/people_metrics.dart';
import 'package:charitask/modules/people/widgets/people_table.dart';
import 'package:charitask/modules/people/widgets/people_toolbar.dart';

class PeoplePage extends StatefulWidget {
  final String organizationId;

  const PeoplePage({super.key, required this.organizationId});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  late final PeopleRepository _repository;

  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _people = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _repository = PeopleRepositoryImpl(PeopleService(Supabase.instance.client));

    _loadPeople();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPeople() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final people = await _repository.getPeople(
        organizationId: widget.organizationId,
      );

      if (!mounted) return;

      setState(() {
        _people = people;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to load people.';
      });
    }
  }

  List<Map<String, dynamic>> get _filteredPeople {
    final query = _searchQuery.trim().toLowerCase();

    final filtered = _people.where((person) {
      if (query.isEmpty) {
        return true;
      }

      final searchableValues = [
        person['first_name'],
        person['last_name'],
        person['preferred_name'],
        person['email'],
        person['phone'],
        person['role'],
        person['groups'],
        person['locations'],
      ];

      return searchableValues.any(
        (value) =>
            value != null && value.toString().toLowerCase().contains(query),
      );
    }).toList();

    filtered.sort((a, b) {
      final aPreferred = a['preferred_name']?.toString().trim();
      final aFirst = a['first_name']?.toString().trim() ?? '';
      final aLast = a['last_name']?.toString().trim() ?? '';

      final bPreferred = b['preferred_name']?.toString().trim();
      final bFirst = b['first_name']?.toString().trim() ?? '';
      final bLast = b['last_name']?.toString().trim() ?? '';

      final aFirstName = aPreferred != null && aPreferred.isNotEmpty
          ? aPreferred
          : aFirst;

      final bFirstName = bPreferred != null && bPreferred.isNotEmpty
          ? bPreferred
          : bFirst;

      final aName = '$aFirstName $aLast'.trim().toLowerCase();
      final bName = '$bFirstName $bLast'.trim().toLowerCase();

      return aName.compareTo(bName);
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F8FC),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PeopleHeader(
              onAddPerson: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        AddPersonPage(organizationId: widget.organizationId),
                  ),
                );

                if (mounted) {
                  _loadPeople();
                }
              },
            ),
            const SizedBox(height: 24),
            PeopleToolbar(
              searchController: _searchController,
              onSearchChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 24),
            PeopleMetrics(people: _people),
            const SizedBox(height: 24),
            if (_isLoading)
              const SizedBox(
                height: 420,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_errorMessage != null)
              SizedBox(
                height: 420,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _loadPeople,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              )
            else
              PeopleTable(people: _filteredPeople),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
