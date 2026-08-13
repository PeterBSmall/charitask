import 'package:flutter/material.dart';

import 'package:charitask/modules/onboarding/controllers/onboarding_controller.dart';

import 'widgets/account_form.dart';
import 'widgets/account_form_panel.dart';
import 'widgets/account_welcome_panel.dart';

class CreateAccountPage extends StatefulWidget {
  final OnboardingController controller;
  final VoidCallback onContinue;

  const CreateAccountPage({
    super.key,
    required this.controller,
    required this.onContinue,
  });

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  final _accountFormKey = GlobalKey<AccountFormState>();

  @override
  void initState() {
    super.initState();

    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1320, maxHeight: 900),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Material(
                  elevation: 8,
                  shadowColor: Colors.black.withValues(alpha: 0.12),
                  child: Row(
                    children: [
                      Expanded(flex: 42, child: AccountWelcomePanel()),
                      Expanded(
                        flex: 58,
                        child: AccountFormPanel(
                          firstNameController: _firstNameController,
                          lastNameController: _lastNameController,
                          emailController: _emailController,
                          phoneController: _phoneController,
                          passwordController: _passwordController,
                          accountFormKey: _accountFormKey,
                          onContinue: () {
                            if (!_accountFormKey.currentState!.validate()) {
                              return;
                            }

                            widget.controller.createPersonDraft(
                              firstName: _firstNameController.text.trim(),
                              lastName: _lastNameController.text.trim(),
                              email: _emailController.text.trim(),
                              phone: _phoneController.text.trim().isEmpty
                                  ? null
                                  : _phoneController.text.trim(),
                            );

                            widget.onContinue();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
