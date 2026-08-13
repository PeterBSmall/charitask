import 'package:flutter/material.dart';

import 'package:charitask/shared/validation/ct_phone_validator.dart';

class CTPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool required;

  const CTPhoneField({
    super.key,
    required this.controller,
    this.labelText = 'Phone number',
    this.hintText = 'Enter your phone number',
    this.required = true,
  });

  @override
  State<CTPhoneField> createState() => _CTPhoneFieldState();
}

class _CTPhoneFieldState extends State<CTPhoneField> {
  bool _formatting = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (_formatting) return;

    final current = widget.controller.text;
    final formatted = CTPhoneValidator.format(current);

    if (formatted == current) return;

    _formatting = true;

    widget.controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );

    _formatting = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
      ),
      validator: (value) {
        return CTPhoneValidator.validate(value, required: widget.required);
      },
    );
  }
}
