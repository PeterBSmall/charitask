class PersonCredentialDocumentRecord {
  final String id;
  final String credentialId;
  final String fileName;
  final String contentType;
  final int fileSize;
  final DateTime? createdAt;

  const PersonCredentialDocumentRecord({
    required this.id,
    required this.credentialId,
    required this.fileName,
    required this.contentType,
    required this.fileSize,
    this.createdAt,
  });

  factory PersonCredentialDocumentRecord.fromMap(Map<String, dynamic> row) {
    return PersonCredentialDocumentRecord(
      id: row['id'].toString(),
      credentialId: row['credential_id'].toString(),
      fileName: row['file_name'] as String? ?? 'Document',
      contentType: row['content_type'] as String? ?? 'application/octet-stream',
      fileSize: (row['file_size'] as num?)?.toInt() ?? 0,
      createdAt: row['created_at'] == null
          ? null
          : DateTime.tryParse(row['created_at'].toString()),
    );
  }
}
