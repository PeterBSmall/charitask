import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';

import 'package:charitask/modules/people/domain/models/person_credential_document.dart';

class CredentialDocumentPicker extends StatefulWidget {
  final List<CredentialDocumentDraft> documents;
  final ValueChanged<List<CredentialDocumentDraft>> onChanged;

  const CredentialDocumentPicker({
    super.key,
    required this.documents,
    required this.onChanged,
  });

  @override
  State<CredentialDocumentPicker> createState() =>
      _CredentialDocumentPickerState();
}

class _CredentialDocumentPickerState extends State<CredentialDocumentPicker> {
  static const _cyan = Color(0xFF0891B2);
  static const _navy = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  late List<CredentialDocumentDraft> _documents;

  bool _isDragging = false;
  bool _isPicking = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _documents = List<CredentialDocumentDraft>.from(widget.documents);
  }

  @override
  void didUpdateWidget(covariant CredentialDocumentPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!listEquals(oldWidget.documents, widget.documents)) {
      _documents = List<CredentialDocumentDraft>.from(widget.documents);
    }
  }

  String? _contentTypeFor(String fileName) {
    final separator = fileName.lastIndexOf('.');
    if (separator < 0) return null;

    final extension = fileName.substring(separator + 1).toLowerCase();

    return supportedCredentialDocumentTypes[extension];
  }

  Future<void> _addFile(
    String fileName,
    Future<Uint8List> Function() readBytes,
  ) async {
    final contentType = _contentTypeFor(fileName);

    if (contentType == null) {
      _showError('$fileName is not supported. Use PDF, JPG, or PNG.');
      return;
    }

    try {
      final bytes = await readBytes();

      if (!mounted) return;

      if (bytes.isEmpty) {
        _showError('$fileName is empty.');
        return;
      }

      if (bytes.lengthInBytes > maxCredentialDocumentBytes) {
        _showError('$fileName exceeds the 10 MB limit.');
        return;
      }

      final isDuplicate = _documents.any(
        (document) =>
            document.fileName == fileName &&
            document.sizeInBytes == bytes.lengthInBytes,
      );

      if (isDuplicate) {
        _showError('$fileName has already been added.');
        return;
      }

      final nextDocuments = [
        ..._documents,
        CredentialDocumentDraft(
          fileName: fileName,
          contentType: contentType,
          bytes: bytes,
        ),
      ];

      _replaceDocuments(nextDocuments);
    } catch (error) {
      if (!mounted) return;
      _showError('Could not read $fileName: $error');
    }
  }

  void _replaceDocuments(List<CredentialDocumentDraft> documents) {
    setState(() {
      _documents = documents;
      _errorMessage = null;
    });

    widget.onChanged(documents);
  }

  void _showError(String message) {
    if (!mounted) return;

    setState(() {
      _errorMessage = message;
    });
  }

  Future<void> _chooseFiles() async {
    setState(() {
      _isPicking = true;
      _errorMessage = null;
    });

    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (!mounted) return;

      for (final file in files) {
        await _addFile(file.name, file.readAsBytes);
        if (!mounted) return;
      }
    } catch (error) {
      if (!mounted) return;
      _showError('Unable to select files: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }

  Future<void> _handleDrop(dynamic details) async {
    setState(() {
      _isDragging = false;
      _errorMessage = null;
    });

    for (final file in details.files) {
      await _addFile(file.name, file.readAsBytes);
      if (!mounted) return;
    }
  }

  void _removeDocument(int index) {
    final nextDocuments = List<CredentialDocumentDraft>.from(_documents)
      ..removeAt(index);

    _replaceDocuments(nextDocuments);
  }

  Widget _dropZone() {
    return DropTarget(
      onDragEntered: (_) {
        setState(() {
          _isDragging = true;
        });
      },
      onDragExited: (_) {
        setState(() {
          _isDragging = false;
        });
      },
      onDragDone: _handleDrop,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: _isDragging ? _cyan : const Color(0xFF94C9D5),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(
            color: _isDragging ? const Color(0xFFE0F7FC) : Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                size: 38,
                color: _isDragging ? _cyan : const Color(0xFF0891B2),
              ),
              const SizedBox(height: 12),
              Text(
                _isDragging ? 'Drop files to add them' : 'Drop files here',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'or choose files from your device',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: _muted),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _isPicking ? null : _chooseFiles,
                icon: _isPicking
                    ? const SizedBox(
                        width: 17,
                        height: 17,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.upload_file_outlined, size: 18),
                label: Text(_isPicking ? 'Selecting files...' : 'Choose Files'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _cyan,
                  side: const BorderSide(color: _cyan),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'PDF, JPG, PNG · Maximum 10 MB per file',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: _muted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _documentRow(CredentialDocumentDraft document, int index) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.description_outlined, color: _cyan, size: 25),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.fileName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  document.formattedSize,
                  style: const TextStyle(fontSize: 11, color: _muted),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Remove file',
            onPressed: () => _removeDocument(index),
            icon: const Icon(Icons.close, color: _muted, size: 20),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          children: [
            Icon(Icons.attach_file, size: 20, color: _cyan),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Supporting Documents',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _navy,
                ),
              ),
            ),
            Text('Optional', style: TextStyle(fontSize: 12, color: _muted)),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Attach proof of this certification, license, or training.',
          style: TextStyle(fontSize: 12, height: 1.5, color: _muted),
        ),
        const SizedBox(height: 14),
        _dropZone(),
        if (_errorMessage != null) ...[
          const SizedBox(height: 10),
          Text(
            _errorMessage!,
            style: const TextStyle(fontSize: 12, color: Color(0xFFB91C1C)),
          ),
        ],
        if (_documents.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            '${_documents.length} file${_documents.length == 1 ? '' : 's'} selected',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _muted,
            ),
          ),
          ..._documents.asMap().entries.map(
            (entry) => _documentRow(entry.value, entry.key),
          ),
        ],
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;

  const _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 1.5;
    const dashLength = 7.0;
    const gapLength = 5.0;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rect = Rect.fromLTWH(
      strokeWidth,
      strokeWidth,
      size.width - strokeWidth * 2,
      size.height - strokeWidth * 2,
    );

    final borderPath = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(14)));

    for (final metric in borderPath.computeMetrics()) {
      var distance = 0.0;

      while (distance < metric.length) {
        final end = (distance + dashLength).clamp(0.0, metric.length);

        canvas.drawPath(metric.extractPath(distance, end), paint);

        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
