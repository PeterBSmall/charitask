import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/foundation/data/services/functional_role_service.dart';
import 'package:charitask/modules/foundation/domain/models/functional_role.dart';
import 'package:charitask/modules/people/data/services/person_credential_document_service.dart';
import 'package:charitask/modules/people/data/services/person_credential_service.dart';
import 'package:charitask/modules/people/data/services/person_private_details_service.dart';
import 'package:charitask/modules/people/domain/models/person_credential.dart';
import 'package:charitask/modules/people/domain/repositories/people_repository.dart';
import 'package:charitask/platform/authorization/authorization_service.dart';

class AddPersonCreationResult {
  final String personId;
  final List<String> warnings;

  AddPersonCreationResult({
    required this.personId,
    List<String> warnings = const [],
  }) : warnings = List.unmodifiable(warnings);

  bool get hasWarnings => warnings.isNotEmpty;
}

class AddPersonCreationException implements Exception {
  final String message;

  const AddPersonCreationException(this.message);

  @override
  String toString() => message;
}

/// Coordinates persistence for the Add Person wizard.
/// UI state and dialogs remain in AddPersonPage.
class AddPersonCreationService {
  final PeopleRepository _repository;
  final FunctionalRoleService _functionalRoleService;
  final SupabaseClient _supabase;

  AddPersonCreationService({
    required PeopleRepository repository,
    required FunctionalRoleService functionalRoleService,
    SupabaseClient? supabase,
  }) : _repository = repository,
       _functionalRoleService = functionalRoleService,
       _supabase = supabase ?? Supabase.instance.client;

  Future<AddPersonCreationResult> createPerson({
    required String organizationId,
    required String firstName,
    required String lastName,
    String? preferredName,
    String? email,
    String? phone,
    String? notes,
    required String membershipStatus,
    required List<FunctionalRole> functionalRoles,
    required List<PersonCredentialDraft> credentials,
    required DateTime? dateOfBirth,
    required String informationProviderType,
    String? providerName,
    String? providerRelationship,
    required String personType,
  }) async {
    final cleanProviderName = providerName?.trim();
    final cleanProviderRelationship = providerRelationship?.trim();

    final needsProviderName =
        informationProviderType == 'parent_guardian' ||
        informationProviderType == 'authorized_representative';

    if (needsProviderName &&
        (cleanProviderName == null || cleanProviderName.isEmpty)) {
      throw const AddPersonCreationException(
        'Please enter the parent, guardian, or representative name.',
      );
    }

    final hasPrivateDetails =
        dateOfBirth != null ||
        informationProviderType != 'organization_staff' ||
        (cleanProviderName?.isNotEmpty ?? false) ||
        (cleanProviderRelationship?.isNotEmpty ?? false);

    // Check authorization before creating the person.
    if (hasPrivateDetails) {
      final canManage = await AuthorizationService(_supabase).hasPermission(
        organizationId: organizationId,
        permissionKey: 'people.personal_details.manage',
      );

      if (!canManage) {
        throw const AddPersonCreationException(
          'Your account does not have permission to save protected personal '
          'details. Please contact an organization administrator.',
        );
      }
    }

    // Create the base person. Errors here occur before post-creation work.
    final person = await _repository.createPerson(
      organizationId: organizationId,
      firstName: firstName,
      lastName: lastName,
      preferredName: preferredName,
      email: email,
      phone: phone,
      employmentType: null,
      personType: personType,
      notes: notes,
    );

    final personId = person['id'] as String?;

    if (personId == null || personId.isEmpty) {
      throw Exception('Person was created without an ID.');
    }

    // Once the person exists, collect failures instead of inviting
    // the user to submit the entire form a second time.
    final warnings = <String>[];

    try {
      await _repository.createOrganizationMembership(
        organizationId: organizationId,
        personId: personId,
        status: membershipStatus,
      );
    } catch (_) {
      warnings.add('The organization membership could not be saved.');
    }

    for (final role in functionalRoles) {
      try {
        await _functionalRoleService.createAssignment(
          organizationId: organizationId,
          personId: personId,
          functionalRoleId: role.id,
        );
      } catch (_) {
        warnings.add(
          'One or more functional-role assignments could not be saved.',
        );
        break;
      }
    }

    // Save private details independently of credential uploads.
    if (hasPrivateDetails) {
      try {
        await PersonPrivateDetailsService(
          supabase: _supabase,
        ).savePrivateDetails(
          organizationId: organizationId,
          personId: personId,
          dateOfBirth: dateOfBirth,
          informationProviderType: informationProviderType,
          providerName: cleanProviderName?.isEmpty ?? true
              ? null
              : cleanProviderName,
          providerRelationship: cleanProviderRelationship?.isEmpty ?? true
              ? null
              : cleanProviderRelationship,
        );
      } catch (_) {
        warnings.add('The protected personal details could not be saved.');
      }
    }

    final credentialService = PersonCredentialService(supabase: _supabase);
    final documentService = PersonCredentialDocumentService();

    for (final credential in credentials) {
      PersonCredential savedCredential;

      try {
        savedCredential = await credentialService.createCredential(
          organizationId: organizationId,
          personId: personId,
          credential: credential,
        );
      } catch (_) {
        warnings.add('One or more credentials could not be saved.');
        continue;
      }

      if (credential.documents.isNotEmpty) {
        try {
          await documentService.uploadDocuments(
            organizationId: organizationId,
            personId: personId,
            credentialId: savedCredential.id,
            category: credential.category,
            documents: credential.documents,
          );
        } catch (_) {
          warnings.add(
            'One or more supporting documents could not be uploaded.',
          );
        }
      }
    }

    return AddPersonCreationResult(personId: personId, warnings: warnings);
  }
}
