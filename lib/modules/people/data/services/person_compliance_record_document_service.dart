import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/people/domain/models/person_compliance_record_document.dart';

class PersonComplianceRecordDocumentService {
  PersonComplianceRecordDocumentService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;
  static const String bucketName = 'person-compliance-record-documents';
  static const String _table = 'person_compliance_record_documents';

  Future<List<PersonComplianceRecordDocument>> getForAgreement({
    required String organizationId,
    required String personId,
    required String acknowledgementId,
  }) async {
    final rows = await _supabase
        .from(_table)
        .select()
        .eq('organization_id', organizationId)
        .eq('person_id', personId)
        .eq('agreement_acknowledgement_id', acknowledgementId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(
      rows,
    ).map(PersonComplianceRecordDocument.fromMap).toList(growable: false);
  }

  Future<List<PersonComplianceRecordDocument>> getForMedicalClearance({
    required String organizationId,
    required String personId,
    required String medicalClearanceRecordId,
  }) async {
    final rows = await _supabase
        .from(_table)
        .select()
        .eq('organization_id', organizationId)
        .eq('person_id', personId)
        .eq('medical_clearance_record_id', medicalClearanceRecordId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(
      rows,
    ).map(PersonComplianceRecordDocument.fromMap).toList(growable: false);
  }

  Future<List<PersonComplianceRecordDocument>> uploadForAgreement({
    required String organizationId,
    required String personId,
    required String acknowledgementId,
    required List<PersonComplianceRecordDocumentDraft> documents,
    String? uploadedByPersonId,
  }) => _upload(
    organizationId: organizationId,
    personId: personId,
    recordType: 'agreement',
    recordId: acknowledgementId,
    documents: documents,
    uploadedByPersonId: uploadedByPersonId,
  );

  /// Only clearance evidence is allowed here. Do not upload medical reports,
  /// diagnoses, treatment details, or other clinical records.
  Future<List<PersonComplianceRecordDocument>> uploadClearanceEvidence({
    required String organizationId,
    required String personId,
    required String medicalClearanceRecordId,
    required List<PersonComplianceRecordDocumentDraft> documents,
    String? uploadedByPersonId,
  }) => _upload(
    organizationId: organizationId,
    personId: personId,
    recordType: 'medical-clearance',
    recordId: medicalClearanceRecordId,
    documents: documents,
    uploadedByPersonId: uploadedByPersonId,
  );

  Future<List<PersonComplianceRecordDocument>> _upload({
    required String organizationId,
    required String personId,
    required String recordType,
    required String recordId,
    required List<PersonComplianceRecordDocumentDraft> documents,
    required String? uploadedByPersonId,
  }) async {
    if (documents.isEmpty) return const [];
    final uploadedPaths = <String>[];
    final metadataIds = <String>[];
    final results = <PersonComplianceRecordDocument>[];

    try {
      for (var index = 0; index < documents.length; index++) {
        final document = documents[index];
        _validateDocument(document);
        final safeName = _safeFileName(document.fileName);
        final path =
            '$organizationId/$personId/$recordType/$recordId/'
            '${DateTime.now().microsecondsSinceEpoch}_${index}_$safeName';

        await _supabase.storage
            .from(bucketName)
            .uploadBinary(
              path,
              document.bytes,
              fileOptions: FileOptions(
                contentType: document.contentType,
                upsert: false,
              ),
            );
        uploadedPaths.add(path);

        final rowData = <String, dynamic>{
          'organization_id': organizationId,
          'person_id': personId,
          'storage_path': path,
          'file_name': document.fileName,
          'content_type': document.contentType,
          'file_size': document.sizeInBytes,
          'uploaded_by_person_id': uploadedByPersonId,
        };
        if (recordType == 'agreement') {
          rowData['agreement_acknowledgement_id'] = recordId;
        } else {
          rowData['medical_clearance_record_id'] = recordId;
        }

        final row = await _supabase
            .from(_table)
            .insert(rowData)
            .select()
            .single();
        final metadata = PersonComplianceRecordDocument.fromMap(
          Map<String, dynamic>.from(row),
        );
        metadataIds.add(metadata.id);
        results.add(metadata);
      }
      return results;
    } catch (_) {
      // Best-effort cleanup to avoid orphaned private Storage objects or rows.
      for (final id in metadataIds.reversed) {
        try {
          await _supabase.from(_table).delete().eq('id', id);
        } catch (_) {
          // Preserve the initial upload/metadata error.
        }
      }
      if (uploadedPaths.isNotEmpty) {
        try {
          await _supabase.storage.from(bucketName).remove(uploadedPaths);
        } catch (_) {
          // Preserve the initial upload/metadata error.
        }
      }
      rethrow;
    }
  }

  Future<List<int>> downloadDocument(String storagePath) async {
    return _supabase.storage.from(bucketName).download(storagePath);
  }

  Future<void> deleteDocument(PersonComplianceRecordDocument document) async {
    // Remove metadata first; the storage policy also checks metadata scope.
    await _supabase
        .from(_table)
        .delete()
        .eq('organization_id', document.organizationId)
        .eq('person_id', document.personId)
        .eq('id', document.id);
    await _supabase.storage.from(bucketName).remove([document.storagePath]);
  }

  void _validateDocument(PersonComplianceRecordDocumentDraft document) {
    if (document.fileName.trim().isEmpty) {
      throw StateError('A document file name is required.');
    }
    if (document.sizeInBytes < 1 ||
        document.sizeInBytes > maxComplianceRecordDocumentBytes) {
      throw StateError(
        '${document.fileName} must be between 1 byte and 10 MB.',
      );
    }
    if (!supportedComplianceRecordDocumentTypes.values.contains(
      document.contentType,
    )) {
      throw StateError('${document.fileName} has an unsupported file type.');
    }
  }

  String _safeFileName(String input) => input
      .replaceAll(RegExp(r'[/\\]'), '_')
      .replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '_');
}
