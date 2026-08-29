import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PersonTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final String? Function(String value)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool required;

  const PersonTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.prefixIcon,
    this.validator,
    this.inputFormatters,
    this.required = false,
  });

  @override
  State<PersonTextField> createState() => _PersonTextFieldState();
}

class _PersonTextFieldState extends State<PersonTextField> {
  late final FocusNode _focusNode;

  String? _errorText;
  bool _hasBeenFocused = false;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _hasBeenFocused = true;
      } else if (_hasBeenFocused) {
        _validate();
      }
    });

    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_errorText != null) {
      _validate();
    }
  }

  void _validate() {
    final validator = widget.validator;

    if (validator == null) return;

    final error = validator(widget.controller.text);

    if (error != _errorText && mounted) {
      setState(() {
        _errorText = error;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _errorText != null;

    const purple = Color(0xFF5B4BC4);
    const errorColor = Color(0xFFD14343);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),

            if (widget.required) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  color: Color(0xFFD14343),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 8),

        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            hintText: widget.hint,

            prefixIcon: widget.prefixIcon == null
                ? null
                : Icon(
                    widget.prefixIcon,
                    size: 20,
                    color: hasError ? errorColor : const Color(0xFF9CA3AF),
                  ),

            filled: true,
            fillColor: hasError
                ? const Color(0xFFFFFAFA)
                : const Color(0xFFFBFBFC),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? errorColor : const Color(0xFFE5E7EB),
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? errorColor : const Color(0xFFE5E7EB),
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? errorColor : purple,
                width: 2,
              ),
            ),
          ),
        ),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: hasError
              ? Padding(
                  key: ValueKey(_errorText),
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: errorColor,
                      ),

                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          _errorText!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: errorColor,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
