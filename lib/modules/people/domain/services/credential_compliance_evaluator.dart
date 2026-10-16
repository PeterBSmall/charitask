import 'package:charitask/modules/foundation/domain/models/functional_role_assignment.dart';
import 'package:charitask/modules/people/domain/models/functional_role_credential_requirement.dart';
import 'package:charitask/modules/people/domain/models/person_credential.dart';

enum CredentialComplianceStatus {
  noRequirements,
  accessRestricted,
  expired,
  missingRequired,
  reviewRequired,
  valid,
}

enum CredentialRequirementItemStatus {
  satisfied,
  missing,
  expired,
  reviewRequired,
  accessRestricted,
}

class CredentialRequirementAssessment {
  const CredentialRequirementAssessment({
    required this.requirement,
    required this.roleName,
    required this.status,
    this.matchingCredential,
  });

  final FunctionalRoleCredentialRequirement requirement;
  final String roleName;
  final CredentialRequirementItemStatus status;
  final PersonCredential? matchingCredential;

  String get displayName {
    final name = requirement.credentialName?.trim();

    if (name == null || name.isEmpty) {
      return '${requirement.category.label} (any qualifying credential)';
    }

    return name;
  }

  String get statusLabel => switch (status) {
    CredentialRequirementItemStatus.satisfied => 'Satisfied',
    CredentialRequirementItemStatus.missing => 'Missing',
    CredentialRequirementItemStatus.expired => 'Expired',
    CredentialRequirementItemStatus.reviewRequired => 'Review Required',
    CredentialRequirementItemStatus.accessRestricted => 'Restricted',
  };
}

class CredentialComplianceResult {
  const CredentialComplianceResult({
    required this.status,
    required this.totalRequirements,
    required this.satisfiedRequirements,
    required this.missingRequirements,
    required this.expiredRequirements,
    required this.reviewRequirements,
    required this.accessRestricted,
    this.requirementAssessments = const [],
  });

  final CredentialComplianceStatus status;
  final int totalRequirements;
  final int satisfiedRequirements;
  final int missingRequirements;
  final int expiredRequirements;
  final int reviewRequirements;
  final bool accessRestricted;
  final List<CredentialRequirementAssessment> requirementAssessments;

  bool get hasRequirements => totalRequirements > 0;

  bool get isValid => status == CredentialComplianceStatus.valid;
}

class CredentialComplianceEvaluator {
  const CredentialComplianceEvaluator();

  CredentialComplianceResult evaluate({
    required List<FunctionalRoleAssignment> assignments,
    required List<FunctionalRoleCredentialRequirement> requirements,
    required List<PersonCredential> credentials,
    required bool canViewCredentials,
    required bool canViewBackgroundChecks,
    Map<String, String> roleNamesById = const {},
  }) {
    // Only requirements for the person's active Functional Roles apply.
    final activeRoleIds = assignments
        .where((assignment) => assignment.isActive)
        .map((assignment) => assignment.functionalRoleId)
        .toSet();

    final applicableRequirements = requirements
        .where(
          (requirement) => activeRoleIds.contains(requirement.functionalRoleId),
        )
        .toList();

    // No configured requirements means we must not label the person
    // as missing credentials or claim that they are compliant.
    if (applicableRequirements.isEmpty) {
      return const CredentialComplianceResult(
        status: CredentialComplianceStatus.noRequirements,
        totalRequirements: 0,
        satisfiedRequirements: 0,
        missingRequirements: 0,
        expiredRequirements: 0,
        reviewRequirements: 0,
        accessRestricted: false,
      );
    }

    // Do not imply that a requirement is missing when permissions
    // prevent us from checking its credentials.
    if (!canViewCredentials ||
        (!canViewBackgroundChecks &&
            applicableRequirements.any(
              (requirement) => requirement.category.isBackgroundCheck,
            ))) {
      final assessments = applicableRequirements
          .map(
            (requirement) => CredentialRequirementAssessment(
              requirement: requirement,
              roleName:
                  roleNamesById[requirement.functionalRoleId] ??
                  'Functional role',
              status: CredentialRequirementItemStatus.accessRestricted,
            ),
          )
          .toList(growable: false);

      return CredentialComplianceResult(
        status: CredentialComplianceStatus.accessRestricted,
        totalRequirements: applicableRequirements.length,
        satisfiedRequirements: 0,
        missingRequirements: 0,
        expiredRequirements: 0,
        reviewRequirements: 0,
        accessRestricted: true,
        requirementAssessments: assessments,
      );
    }

    var satisfied = 0;
    var missing = 0;
    var expired = 0;
    var needsReview = 0;

    final assessments = <CredentialRequirementAssessment>[];

    for (final requirement in applicableRequirements) {
      final matches = credentials
          .where(
            (credential) => requirement.matchesCredential(
              credentialCategory: credential.category,
              credentialName: credential.credentialName,
            ),
          )
          .toList();

      final roleName =
          roleNamesById[requirement.functionalRoleId] ?? 'Functional role';

      if (matches.isEmpty) {
        missing++;

        assessments.add(
          CredentialRequirementAssessment(
            requirement: requirement,
            roleName: roleName,
            status: CredentialRequirementItemStatus.missing,
          ),
        );

        continue;
      }

      // A requirement is satisfied if any matching credential is
      // verified or cleared and has not expired.
      PersonCredential? usableCredential;

      for (final credential in matches) {
        if (credential.isVerifiedAndCurrent) {
          usableCredential = credential;
          break;
        }
      }

      if (usableCredential != null) {
        satisfied++;

        assessments.add(
          CredentialRequirementAssessment(
            requirement: requirement,
            roleName: roleName,
            status: CredentialRequirementItemStatus.satisfied,
            matchingCredential: usableCredential,
          ),
        );

        continue;
      }

      // If no usable credential exists, identify whether a matching
      // credential is expired or needs review.
      PersonCredential? expiredCredential;

      for (final credential in matches) {
        if (credential.isExpired) {
          expiredCredential = credential;
          break;
        }
      }

      if (expiredCredential != null) {
        expired++;

        assessments.add(
          CredentialRequirementAssessment(
            requirement: requirement,
            roleName: roleName,
            status: CredentialRequirementItemStatus.expired,
            matchingCredential: expiredCredential,
          ),
        );
      } else {
        needsReview++;

        assessments.add(
          CredentialRequirementAssessment(
            requirement: requirement,
            roleName: roleName,
            status: CredentialRequirementItemStatus.reviewRequired,
            matchingCredential: matches.first,
          ),
        );
      }
    }

    // Preserve the existing overall status priority.
    final status = expired > 0
        ? CredentialComplianceStatus.expired
        : missing > 0
        ? CredentialComplianceStatus.missingRequired
        : needsReview > 0
        ? CredentialComplianceStatus.reviewRequired
        : CredentialComplianceStatus.valid;

    return CredentialComplianceResult(
      status: status,
      totalRequirements: applicableRequirements.length,
      satisfiedRequirements: satisfied,
      missingRequirements: missing,
      expiredRequirements: expired,
      reviewRequirements: needsReview,
      accessRestricted: false,
      requirementAssessments: assessments,
    );
  }
}
