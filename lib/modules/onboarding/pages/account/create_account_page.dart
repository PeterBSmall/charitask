import 'package:flutter/material.dart';

import 'package:charitask/modules/onboarding/controllers/onboarding_controller.dart';

import 'widgets/account_form.dart';
import 'widgets/account_form_panel.dart';
import 'widgets/account_welcome_panel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  final ScrollController _scrollController = ScrollController();

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
    _scrollController.dispose();

    super.dispose();
  }

  Future<void> _createAccount() async {
    if (!_accountFormKey.currentState!.validate()) {
      return;
    }

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: 'chari-task://auth-callback',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          if (phone.isNotEmpty) 'phone': phone,
        },
      );

      if (!mounted) return;

      final user = response.user;

      if (user == null) {
        throw const AuthException(
          'We could not create your account. Please try again.',
        );
      }

      // Keep the existing ChariTask onboarding draft.
      widget.controller.createPersonDraft(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone.isEmpty ? null : phone,
      );

      // With email confirmation enabled, Supabase normally
      // returns a user but no session.
      if (response.session == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Account created. Please check your email to verify your account.',
            ),
          ),
        );
      }

      widget.onContinue();
    } on AuthException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong creating your account. Please try again.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Scrollbar(
              controller: _scrollController,
              thumbVisibility: false,
              interactive: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 1320,
                      minHeight: (constraints.maxHeight - 40).clamp(
                        0.0,
                        double.infinity,
                      ),
                    ),
                    child: LayoutBuilder(
                      builder: (context, panelConstraints) {
                        final isCompact = panelConstraints.maxWidth < 900;

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Material(
                            elevation: 8,
                            shadowColor: Colors.black.withValues(alpha: 0.12),
                            child: isCompact
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      AccountWelcomePanel(),

                                      AccountFormPanel(
                                        firstNameController:
                                            _firstNameController,
                                        lastNameController: _lastNameController,
                                        emailController: _emailController,
                                        phoneController: _phoneController,
                                        passwordController: _passwordController,
                                        accountFormKey: _accountFormKey,
                                        onContinue: _createAccount,
                                      ),
                                    ],
                                  )
                                : IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          flex: 42,
                                          child: AccountWelcomePanel(),
                                        ),

                                        Expanded(
                                          flex: 58,
                                          child: AccountFormPanel(
                                            firstNameController:
                                                _firstNameController,
                                            lastNameController:
                                                _lastNameController,
                                            emailController: _emailController,
                                            phoneController: _phoneController,
                                            passwordController:
                                                _passwordController,
                                            accountFormKey: _accountFormKey,
                                            onContinue: _createAccount,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
