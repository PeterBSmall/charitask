import 'package:flutter/material.dart';

import 'account_form.dart';

class AccountFormPanel extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final GlobalKey<AccountFormState> accountFormKey;
  final VoidCallback onContinue;

  const AccountFormPanel({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.accountFormKey,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(64, 34, 64, 34),
            child: Column(
              children: [
                // Sign in
                Align(
                  alignment: Alignment.topRight,
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: const [
                        TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Sign in',
                          style: TextStyle(
                            color: Color(0xFF5633D8),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // ChariTask mark
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F2FF),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE6E0FF)),
                  ),
                  child: const Center(
                    child: Text(
                      'C',
                      style: TextStyle(
                        color: Color(0xFF4A2AB8),
                        fontSize: 54,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Let’s get started',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF182238),
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Create your ChariTask account to begin\n'
                  'building something amazing.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF596579),
                    fontSize: 16,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 30),

                AccountForm(
                  key: accountFormKey,
                  firstNameController: firstNameController,
                  lastNameController: lastNameController,
                  emailController: emailController,
                  phoneController: phoneController,
                  passwordController: passwordController,
                ),

                const SizedBox(height: 26),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: onContinue,
                    icon: const Icon(Icons.mail_outline_rounded),
                    label: const Text(
                      'Create your ChariTask account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Color(0xFF687286),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton.icon(
                    onPressed: null,
                    icon: const Text(
                      'G',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    label: const Text(
                      'Continue with Google',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Trust indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _TrustItem(
                      icon: Icons.lock_outline_rounded,
                      label: 'Secure & private',
                    ),
                    _divider(),
                    _TrustItem(
                      icon: Icons.verified_user_outlined,
                      label: 'Trusted by nonprofits',
                    ),
                    _divider(),
                    _TrustItem(
                      icon: Icons.people_outline_rounded,
                      label: 'Built for impact',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 18,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      color: Colors.grey.shade300,
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TrustItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF5633D8)),
        const SizedBox(width: 7),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF596579),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
