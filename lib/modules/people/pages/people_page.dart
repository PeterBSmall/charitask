import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/foundation/data/services/functional_role_service.dart';
import 'package:charitask/modules/foundation/domain/models/functional_role_assignment.dart';
import 'package:charitask/modules/people/data/repositories/people_repository_impl.dart';
import 'package:charitask/modules/people/data/services/functional_role_credential_requirement_service.dart';
import 'package:charitask/modules/people/data/services/people_service.dart';
import 'package:charitask/modules/people/data/services/person_credential_service.dart';
import 'package:charitask/modules/people/data/services/person_private_details_service.dart';
import 'package:charitask/modules/people/domain/models/functional_role_credential_requirement.dart';
import 'package:charitask/modules/people/domain/models/person_credential.dart';
import 'package:charitask/modules/people/domain/repositories/people_repository.dart';
import 'package:charitask/modules/people/domain/services/credential_compliance_evaluator.dart';
import 'package:charitask/modules/people/pages/add_person_page.dart';
import 'package:charitask/modules/people/pages/compliance_page.dart';
import 'package:charitask/modules/people/pages/edit_person_page.dart';
import 'package:charitask/modules/people/widgets/credential_compliance_details_dialog.dart';
import 'package:charitask/modules/people/widgets/people_header.dart';
import 'package:charitask/modules/people/widgets/people_metrics.dart';
import 'package:charitask/modules/people/widgets/people_table.dart';
import 'package:charitask/modules/people/widgets/people_toolbar.dart';
import 'package:charitask/platform/authorization/authorization_service.dart';

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
  Map<String, List<PersonCredential>> _credentialsByPerson = {};

  bool _canViewAnyCredentials = false;
  bool _canEditPeople = false;

  Set<String> _under18PersonIds = {};

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

  bool _isUnder18(DateTime birthDate) {
    final today = DateTime.now();
    final dob = DateTime(birthDate.year, birthDate.month, birthDate.day);
    final currentDay = DateTime(today.year, today.month, today.day);

    // Do not classify invalid future birth dates as minors.
    if (dob.isAfter(currentDay)) return false;

    var age = today.year - dob.year;

    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }

    return age < 18;
  }

  Future<bool> _hasPermission(String permissionKey) {
    return AuthorizationService(Supabase.instance.client).hasPermission(
      organizationId: widget.organizationId,
      permissionKey: permissionKey,
    );
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

      // Load role assignments and credential requirements.
      final roleNamesByPersonId = <String, Set<String>>{};
      Map<String, String> roleNamesById = {};

      List<FunctionalRoleAssignment> activeRoleAssignments = [];
      List<FunctionalRoleCredentialRequirement> credentialRequirements = [];

      var roleDataAvailable = false;
      var requirementsLoaded = false;

      try {
        final canViewFunctionalRoles = await _hasPermission(
          'functionalrole.view',
        );

        if (canViewFunctionalRoles) {
          final roleService = FunctionalRoleService();

          final roles = await roleService.getRoles(
            organizationId: widget.organizationId,
            activeOnly: false,
          );

          final assignments = await roleService.getAssignments(
            organizationId: widget.organizationId,
            activeOnly: true,
          );

          activeRoleAssignments = assignments;
          roleDataAvailable = true;

          roleNamesById = {for (final role in roles) role.id: role.name};

          for (final assignment in assignments) {
            final roleName = roleNamesById[assignment.functionalRoleId];

            if (roleName != null && roleName.trim().isNotEmpty) {
              roleNamesByPersonId
                  .putIfAbsent(assignment.personId, () => <String>{})
                  .add(roleName);
            }
          }

          final assignedRoleIds = assignments
              .map((assignment) => assignment.functionalRoleId)
              .toSet()
              .toList();

          try {
            credentialRequirements =
                await FunctionalRoleCredentialRequirementService().getForRoles(
                  organizationId: widget.organizationId,
                  roleIds: assignedRoleIds,
                );

            requirementsLoaded = true;
          } catch (error) {
            debugPrint('Unable to load credential requirements: $error');
          }
        }
      } catch (error) {
        roleNamesByPersonId.clear();
        activeRoleAssignments = [];
        credentialRequirements = [];
        roleDataAvailable = false;
        requirementsLoaded = false;

        debugPrint('Unable to load functional roles: $error');
      }

      // Retain the assigned role names used by the existing table.
      final peopleWithRoles = people.map((person) {
        final personId = person['id']?.toString() ?? '';

        final roleNames = (roleNamesByPersonId[personId] ?? <String>{}).toList()
          ..sort();

        return <String, dynamic>{
          ...person,
          'role': roleNames.isEmpty ? null : roleNames.join(', '),
        };
      }).toList();

      var canEditPeople = false;

      try {
        canEditPeople = await _hasPermission('people.edit');
      } catch (_) {
        // Fail closed if the permission check fails.
        canEditPeople = false;
      }

      // Load only the IDs of people under 18. Never pass their
      // actual dates of birth into the People table.
      final under18PersonIds = <String>{};

      try {
        final privateDetailsPermissions = await Future.wait([
          _hasPermission('people.personal_details.view'),
          _hasPermission('people.personal_details.manage'),
        ]);

        if (privateDetailsPermissions.any((granted) => granted)) {
          final privateDetails = await PersonPrivateDetailsService()
              .getOrganizationPrivateDetails(
                organizationId: widget.organizationId,
              );

          for (final row in privateDetails) {
            final personId = row['person_id']?.toString();
            final birthDate = DateTime.tryParse(
              row['date_of_birth']?.toString() ?? '',
            );

            if (personId != null &&
                birthDate != null &&
                _isUnder18(birthDate)) {
              under18PersonIds.add(personId);
            }
          }
        }
      } catch (error) {
        // Fail closed: don't display age indicators if authorization
        // or the protected-details lookup fails.
        under18PersonIds.clear();
        debugPrint('Unable to load minor indicators: $error');
      }

      if (!mounted) return;

      // Load credential data only after checking access.
      // Background-check visibility has its own permission.
      var canViewCredentials = false;
      var canViewBackgroundChecks = false;
      var credentialsLoaded = false;

      final credentialsByPerson = <String, List<PersonCredential>>{};

      try {
        final credentialPermissions = await Future.wait([
          _hasPermission('credentials.view'),
          _hasPermission('credentials.manage'),
          _hasPermission('credentials.background_checks.view'),
          _hasPermission('credentials.background_checks.manage'),
        ]);

        // The SELECT policy requires credentials.view specifically.
        canViewCredentials = credentialPermissions[0];
        canViewBackgroundChecks = credentialPermissions[2];

        if (canViewCredentials) {
          final credentials = await PersonCredentialService()
              .getOrganizationCredentials(
                organizationId: widget.organizationId,
              );

          for (final credential in credentials) {
            credentialsByPerson
                .putIfAbsent(credential.personId, () => [])
                .add(credential);
          }

          credentialsLoaded = true;
        }
      } catch (error) {
        // A failed or restricted credential load must never be
        // interpreted as evidence that a required credential is missing.
        canViewCredentials = false;
        canViewBackgroundChecks = false;
        credentialsLoaded = false;
        credentialsByPerson.clear();

        debugPrint('Unable to load credentials: $error');
      }

      // Calculate compliance only when role assignments and the
      // requirements query succeeded. A failed requirements query
      // must not produce a false Missing Required status.
      final complianceByPerson = <String, CredentialComplianceResult>{};

      if (roleDataAvailable && requirementsLoaded) {
        const evaluator = CredentialComplianceEvaluator();

        for (final person in people) {
          final personId = person['id']?.toString();

          if (personId == null || personId.isEmpty) {
            continue;
          }

          final personAssignments = activeRoleAssignments
              .where((assignment) => assignment.personId == personId)
              .toList();

          final activeRoleIds = personAssignments
              .map((assignment) => assignment.functionalRoleId)
              .toSet();

          final personRequirements = credentialRequirements
              .where(
                (requirement) =>
                    activeRoleIds.contains(requirement.functionalRoleId),
              )
              .toList();

          complianceByPerson[personId] = evaluator.evaluate(
            assignments: personAssignments,
            requirements: personRequirements,
            credentials: credentialsByPerson[personId] ?? const [],
            canViewCredentials: canViewCredentials && credentialsLoaded,
            canViewBackgroundChecks: canViewBackgroundChecks,
            roleNamesById: roleNamesById,
          );
        }
      }

      // Attach the result to the corresponding person record so that
      // the table can render it without another database query.
      final peopleWithCompliance = peopleWithRoles.map((person) {
        final personId = person['id']?.toString() ?? '';

        return <String, dynamic>{
          ...person,
          'credential_compliance': complianceByPerson[personId],
        };
      }).toList();

      if (!mounted) return;

      setState(() {
        _people = peopleWithCompliance;
        _credentialsByPerson = credentialsByPerson;
        _canViewAnyCredentials = canViewCredentials;
        _canEditPeople = canEditPeople;
        _under18PersonIds = under18PersonIds;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) return;

      debugPrint('Unable to load people: $error');

      setState(() {
        _people = [];
        _credentialsByPerson = {};
        _under18PersonIds = {};
        _canViewAnyCredentials = false;
        _canEditPeople = false;
        _isLoading = false;
        _errorMessage = 'Unable to load people.';
      });
    }
  }

  Future<void> _viewCredentialCompliance(
    String personId,
    String personName,
    CredentialComplianceResult compliance,
  ) async {
    final selectedRequirement =
        await showDialog<CredentialRequirementAssessment>(
      context: context,
      builder: (dialogContext) => CredentialComplianceDetailsDialog(
        personName: personName,
        compliance: compliance,
      ),
    );

    if (selectedRequirement == null || !mounted) return;

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => CompliancePage(
          organizationId: widget.organizationId,
          initialPersonId: personId,
          initialPersonName: personName,
          initialRequirementAssessment: selectedRequirement,
        ),
      ),
    );

    if (mounted) {
      await _loadPeople();
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
        person['person_type'],
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
                  await _loadPeople();
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
                        textAlign: TextAlign.center,
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
              PeopleTable(
                people: _filteredPeople,
                credentialsByPerson: _credentialsByPerson,
                canViewAnyCredentials: _canViewAnyCredentials,
                under18PersonIds: _under18PersonIds,
                onViewCredentialCompliance: _viewCredentialCompliance,
                onEditPerson: _canEditPeople
                    ? (personId) async {
                        await Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (_) => EditPersonPage(
                              organizationId: widget.organizationId,
                              personId: personId,
                            ),
                          ),
                        );

                        if (mounted) {
                          await _loadPeople();
                        }
                      }
                    : null,
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
