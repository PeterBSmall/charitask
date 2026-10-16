import 'person_credential_document.dart';

enum CredentialCategory {
  certification('certification', 'Certification'),
  license('license', 'License'),
  training('training', 'Training'),
  backgroundCheck('background_check', 'Background Check'),
  other('other', 'Other');

  const CredentialCategory(this.value, this.label);

  final String value;
  final String label;

  bool get isBackgroundCheck => this == CredentialCategory.backgroundCheck;

  static CredentialCategory fromValue(Object? value) {
    for (final category in values) {
      if (category.value == value) return category;
    }
    return CredentialCategory.other;
  }
}

enum CredentialStatus {
  pending('pending', 'Pending'),
  verified('verified', 'Verified'),
  rejected('rejected', 'Rejected'),
  cleared('cleared', 'Cleared'),
  reviewRequired('review_required', 'Review Required'),
  notCleared('not_cleared', 'Not Cleared');

  const CredentialStatus(this.value, this.label);

  final String value;
  final String label;

  bool get isSuccessful =>
      this == CredentialStatus.verified || this == CredentialStatus.cleared;

  static CredentialStatus fromValue(Object? value) {
    for (final status in values) {
      if (status.value == value) return status;
    }
    return CredentialStatus.pending;
  }

  static List<CredentialStatus> forCategory(CredentialCategory category) {
    if (category.isBackgroundCheck) {
      return [
        CredentialStatus.pending,
        CredentialStatus.cleared,
        CredentialStatus.reviewRequired,
        CredentialStatus.notCleared,
      ];
    }

    return [
      CredentialStatus.pending,
      CredentialStatus.verified,
      CredentialStatus.rejected,
    ];
  }
}

/// A credential being entered in a form before it is saved.
class PersonCredentialDraft {
  final CredentialCategory category;
  final String credentialName;
  final String? issuingOrganization;
  final DateTime? issueDate;
  final DateTime? expirationDate;
  final CredentialStatus status;
  final List<CredentialDocumentDraft> documents;

  const PersonCredentialDraft({
    required this.category,
    required this.credentialName,
    this.issuingOrganization,
    this.issueDate,
    this.expirationDate,
    this.status = CredentialStatus.pending,
    this.documents = const [],
  });

  Map<String, dynamic> toInsertMap({
    required String organizationId,
    required String personId,
  }) {
    final cleanIssuer = issuingOrganization?.trim();

    return {
      'organization_id': organizationId,
      'person_id': personId,
      'category': category.value,
      'credential_name': credentialName.trim(),
      'issuing_organization': cleanIssuer == null || cleanIssuer.isEmpty
          ? null
          : cleanIssuer,
      'issue_date': _dateOnly(issueDate),
      'expiration_date': _dateOnly(expirationDate),
      'status': status.value,
      'reviewed_at': status.isSuccessful
          ? DateTime.now().toIso8601String()
          : null,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    final cleanIssuer = issuingOrganization?.trim();

    return {
      'category': category.value,
      'credential_name': credentialName.trim(),
      'issuing_organization': cleanIssuer == null || cleanIssuer.isEmpty
          ? null
          : cleanIssuer,
      'issue_date': _dateOnly(issueDate),
      'expiration_date': _dateOnly(expirationDate),
      'status': status.value,
      'reviewed_at': status.isSuccessful
          ? DateTime.now().toIso8601String()
          : null,
    };
  }
}

/// A credential that has been persisted in Supabase.
class PersonCredential {
  final String id;
  final String organizationId;
  final String personId;
  final CredentialCategory category;
  final String credentialName;
  final String? issuingOrganization;
  final DateTime? issueDate;
  final DateTime? expirationDate;
  final CredentialStatus status;
  final DateTime? reviewedAt;
  final String? reviewedByPersonId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PersonCredential({
    required this.id,
    required this.organizationId,
    required this.personId,
    required this.category,
    required this.credentialName,
    this.issuingOrganization,
    this.issueDate,
    this.expirationDate,
    required this.status,
    this.reviewedAt,
    this.reviewedByPersonId,
    this.createdAt,
    this.updatedAt,
  });

  factory PersonCredential.fromMap(Map<String, dynamic> row) {
    return PersonCredential(
      id: row['id'] as String,
      organizationId: row['organization_id'] as String,
      personId: row['person_id'] as String,
      category: CredentialCategory.fromValue(row['category']),
      credentialName: row['credential_name'] as String,
      issuingOrganization: row['issuing_organization'] as String?,
      issueDate: _parseDate(row['issue_date']),
      expirationDate: _parseDate(row['expiration_date']),
      status: CredentialStatus.fromValue(row['status']),
      reviewedAt: _parseDate(row['reviewed_at']),
      reviewedByPersonId: row['reviewed_by_person_id'] as String?,
      createdAt: _parseDate(row['created_at']),
      updatedAt: _parseDate(row['updated_at']),
    );
  }

  PersonCredentialDraft toDraft() {
    return PersonCredentialDraft(
      category: category,
      credentialName: credentialName,
      issuingOrganization: issuingOrganization,
      issueDate: issueDate,
      expirationDate: expirationDate,
      status: status,
    );
  }

  bool get isExpired {
    if (expirationDate == null) return false;

    return _day(expirationDate!).isBefore(_day(DateTime.now()));
  }

  bool isExpiringSoon({int withinDays = 30, DateTime? referenceDate}) {
    if (expirationDate == null || isExpired) return false;

    final today = _day(referenceDate ?? DateTime.now());
    final boundary = today.add(Duration(days: withinDays));

    return !_day(expirationDate!).isAfter(boundary);
  }

  bool get isVerifiedAndCurrent => status.isSuccessful && !isExpired;
}

String? _dateOnly(DateTime? date) {
  if (date == null) return null;

  final normalized = _day(date);

  return '${normalized.year.toString().padLeft(4, '0')}-'
      '${normalized.month.toString().padLeft(2, '0')}-'
      '${normalized.day.toString().padLeft(2, '0')}';
}

DateTime? _parseDate(Object? value) {
  if (value == null) return null;

  return DateTime.tryParse(value.toString());
}

DateTime _day(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}
