import 'dart:typed_data';

const int maxComplianceRecordDocumentBytes = 10 * 1024 * 1024;

const Map<String, String> supportedComplianceRecordDocumentTypes = {
  'pdf': 'application/pdf',
  'jpg': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'png': 'image/png',
};

class PersonComplianceRecordDocumentDraft {
  const PersonComplianceRecordDocumentDraft({
    required this.fileName,
    required this.contentType,
    required this.bytes,
  });

  final String fileName;
  final String contentType;
  final Uint8List bytes;

  int get sizeInBytes => bytes.length;
}

/// Metadata for a private agreement or medical-clearance document.
/// Medical uploads should contain clearance evidence only, never detailed
/// medical reports or clinical records.
class PersonComplianceRecordDocument {
  const PersonComplianceRecordDocument({
    required this.id,
    required this.organizationId,
    required this.personId,
    required this.storagePath,
    required this.fileName,
    required this.contentType,
    required this.fileSize,
    this.agreementAcknowledgementId,
    this.medicalClearanceRecordId,
    this.uploadedByPersonId,
    this.createdAt,
  });

  final String id;
  final String organizationId;
  final String personId;
  final String? agreementAcknowledgementId;
  final String? medicalClearanceRecordId;
  final String storagePath;
  final String fileName;
  final String contentType;
  final int fileSize;
  final String? uploadedByPersonId;
  final DateTime? createdAt;

  bool get isAgreementDocument => agreementAcknowledgementId != null;
  bool get isMedicalClearanceDocument => medicalClearanceRecordId != null;

  factory PersonComplianceRecordDocument.fromMap(Map<String, dynamic> map) {
    final rawSize = map['file_size'];
    return PersonComplianceRecordDocument(
      id: map['id'] as String,
      organizationId: map['organization_id'] as String,
      personId: map['person_id'] as String,
      agreementAcknowledgementId:
          map['agreement_acknowledgement_id'] as String?,
      medicalClearanceRecordId: map['medical_clearance_record_id'] as String?,
      storagePath: map['storage_path'] as String,
      fileName: map['file_name'] as String,
      contentType: map['content_type'] as String,
      fileSize: rawSize is num ? rawSize.toInt() : int.parse('$rawSize'),
      uploadedByPersonId: map['uploaded_by_person_id'] as String?,
      createdAt: _parseDate(map['created_at']),
    );
  }
}

DateTime? _parseDate(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}
