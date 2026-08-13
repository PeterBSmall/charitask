import 'package:flutter/material.dart';

import 'password_requirements.dart';
import 'package:charitask/shared/widgets/forms/ct_phone_field.dart';

class AccountForm extends StatefulWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;

  const AccountForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
  });

  @override
  State<AccountForm> createState() => AccountFormState();
}

class AccountFormState extends State<AccountForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    widget.passwordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.passwordController.removeListener(_onPasswordChanged);
    super.dispose();
  }

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.firstNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'First name',
                    hintText: 'Enter your first name',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your first name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  controller: widget.lastNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Last name',
                    hintText: 'Enter your last name',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your last name';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          TextFormField(
            controller: widget.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email address',
              hintText: 'Enter your email address',
            ),
            validator: (value) {
              final email = value?.trim() ?? '';

              if (email.isEmpty) {
                return 'Enter your email address';
              }

              final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

              if (!emailPattern.hasMatch(email)) {
                return 'Enter a valid email address';
              }

              return null;
            },
          ),

          const SizedBox(height: 20),

          CTPhoneField(
            controller: widget.phoneController,
            labelText: 'Phone number',
            hintText: 'Enter your phone number',
            required: true,
          ),

          const SizedBox(height: 20),

          TextFormField(
            controller: widget.passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              hintText: 'Create a password',
            ),
            validator: (value) {
              final password = value ?? '';

              if (password.isEmpty) {
                return 'Create a password';
              }

              if (password.length < 8) {
                return 'Password must be at least 8 characters';
              }

              if (!RegExp(r'\d').hasMatch(password)) {
                return 'Password must contain a number';
              }

              if (!RegExp(r'[A-Z]').hasMatch(password)) {
                return 'Password must contain an uppercase letter';
              }

              return null;
            },
          ),

          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerLeft,
            child: PasswordRequirements(
              password: widget.passwordController.text,
            ),
          ),
        ],
      ),
    );
  }
}
