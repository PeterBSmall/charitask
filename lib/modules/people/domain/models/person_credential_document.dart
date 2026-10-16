import 'dart:typed_data';

const int maxCredentialDocumentBytes = 10 * 1024 * 1024;

const Map<String, String> supportedCredentialDocumentTypes = {
  'pdf': 'application/pdf',
  'jpg': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'png': 'image/png',
};

/// A document selected locally but not yet uploaded.
class CredentialDocumentDraft {
  final String fileName;
  final String contentType;
  final Uint8List bytes;

  const CredentialDocumentDraft({
    required this.fileName,
    required this.contentType,
    required this.bytes,
  });

  int get sizeInBytes => bytes.lengthInBytes;

  String get formattedSize {
    if (sizeInBytes < 1024 * 1024) {
      final kb = sizeInBytes / 1024;
      return '${kb.toStringAsFixed(0)} KB';
    }

    final mb = sizeInBytes / (1024 * 1024);
    return '${mb.toStringAsFixed(1)} MB';
  }
}
