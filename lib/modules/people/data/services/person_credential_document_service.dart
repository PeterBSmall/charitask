import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/people/domain/models/person_credential.dart';
import 'package:charitask/modules/people/domain/models/person_credential_document.dart';

class PersonCredentialDocumentService {
  final SupabaseClient _supabase;

  PersonCredentialDocumentService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  static const String bucketName = 'person-credential-documents';

  /// Uploads supporting documents and records their metadata.
  ///
  /// Objects remain in a private bucket; this method never creates
  /// public URLs. Background-check attachments are always rejected.
  Future<void> uploadDocuments({
    required String organizationId,
    required String personId,
    required String credentialId,
    required CredentialCategory category,
    required List<CredentialDocumentDraft> documents,
  }) async {
    if (documents.isEmpty) return;

    if (category.isBackgroundCheck) {
      throw StateError(
        'Supporting documents are not permitted for background checks.',
      );
    }

    final uploadedPaths = <String>[];
    final metadataPaths = <String>[];

    try {
      for (var index = 0; index < documents.length; index++) {
        final document = documents[index];

        if (document.sizeInBytes == 0 ||
            document.sizeInBytes > maxCredentialDocumentBytes) {
          throw StateError(
            '${document.fileName} must be between 1 byte and 10 MB.',
          );
        }

        if (!supportedCredentialDocumentTypes.containsValue(
          document.contentType,
        )) {
          throw StateError(
            '${document.fileName} has an unsupported file type.',
          );
        }

        final safeName = document.fileName
            .replaceAll(RegExp(r'[/\\]'), '_')
            .replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '_');

        final uniquePrefix = '${DateTime.now().microsecondsSinceEpoch}_$index';

        final storagePath =
            '$organizationId/$personId/$credentialId/'
            '${uniquePrefix}_$safeName';

        await _supabase.storage
            .from(bucketName)
            .uploadBinary(
              storagePath,
              document.bytes,
              fileOptions: FileOptions(
                contentType: document.contentType,
                upsert: false,
              ),
            );

        uploadedPaths.add(storagePath);

        await _supabase.from('person_credential_documents').insert({
          'organization_id': organizationId,
          'person_id': personId,
          'credential_id': credentialId,
          'storage_path': storagePath,
          'file_name': document.fileName,
          'content_type': document.contentType,
          'file_size': document.sizeInBytes,
        });

        metadataPaths.add(storagePath);
      }
    } catch (error) {
      // Best-effort cleanup if one of several document uploads fails.
      for (final storagePath in metadataPaths.reversed) {
        try {
          await _supabase
              .from('person_credential_documents')
              .delete()
              .eq('organization_id', organizationId)
              .eq('person_id', personId)
              .eq('credential_id', credentialId)
              .eq('storage_path', storagePath);
        } catch (_) {
          // Preserve the original error; cleanup can be retried later.
        }
      }

      for (final storagePath in uploadedPaths.reversed) {
        try {
          await _supabase.storage.from(bucketName).remove([storagePath]);
        } catch (_) {
          // Preserve the original error.
        }
      }

      rethrow;
    }
  }

  Future<List<String>> getStoragePathsForCredential({
    required String organizationId,
    required String personId,
    required String credentialId,
  }) async {
    final rows = await _supabase
        .from('person_credential_documents')
        .select('storage_path')
        .eq('organization_id', organizationId)
        .eq('person_id', personId)
        .eq('credential_id', credentialId);

    return List<Map<String, dynamic>>.from(
      rows,
    ).map((row) => row['storage_path'] as String).toList();
  }

  Future<void> removeStorageObjects(List<String> storagePaths) async {
    if (storagePaths.isEmpty) return;

    await _supabase.storage.from(bucketName).remove(storagePaths);
  }

  Future<void> deleteDocumentMetadataForCredential({
    required String organizationId,
    required String personId,
    required String credentialId,
  }) async {
    await _supabase
        .from('person_credential_documents')
        .delete()
        .eq('organization_id', organizationId)
        .eq('person_id', personId)
        .eq('credential_id', credentialId);
  }
}
