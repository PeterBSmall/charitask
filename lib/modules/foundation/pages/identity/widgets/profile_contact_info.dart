import 'package:flutter/material.dart';

class ProfileContactInfo extends StatefulWidget {
  final String email;
  final String? phone;
  final TextEditingController phoneController;

  const ProfileContactInfo({
    super.key,
    required this.email,
    required this.phone,
    required this.phoneController,
  });

  @override
  State<ProfileContactInfo> createState() => _ProfileContactInfoState();
}

class _ProfileContactInfoState extends State<ProfileContactInfo> {
  late final TextEditingController _secondaryEmailController;
  late final TextEditingController _secondaryPhoneController;
  late final TextEditingController _contactNotesController;

  bool _showSecondaryContact = false;

  @override
  void initState() {
    super.initState();

    _secondaryEmailController = TextEditingController();
    _secondaryPhoneController = TextEditingController();
    _contactNotesController = TextEditingController();
  }

  @override
  void dispose() {
    _secondaryEmailController.dispose();
    _secondaryPhoneController.dispose();
    _contactNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Information',
          style: TextStyle(
            color: Color(0xFF263248),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'How we can reach you.',
          style: TextStyle(color: Color(0xFF687286), fontSize: 14, height: 1.4),
        ),

        const SizedBox(height: 24),

        // Primary contact heading
        Row(
          children: [
            const Text(
              'Primary Contact',
              style: TextStyle(
                color: Color(0xFF263248),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF0ECFF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Required',
                style: TextStyle(
                  color: Color(0xFF6246E5),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Primary contact fields
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildField(
                label: 'Email Address',
                icon: Icons.mail_outline_rounded,
                child: TextFormField(
                  initialValue: widget.email,
                  readOnly: true,
                  decoration: _inputDecoration(),
                ),
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: _buildField(
                label: 'Phone Number',
                optional: true,
                icon: Icons.phone_outlined,
                child: TextFormField(
                  controller: widget.phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration(hintText: 'Enter phone number'),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        const Divider(color: Color(0xFFE7E9F0), height: 1),

        // Secondary contact toggle
        InkWell(
          onTap: () {
            setState(() {
              _showSecondaryContact = !_showSecondaryContact;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6246E5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _showSecondaryContact
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.add_rounded,
                    color: Colors.white,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add secondary contact',
                        style: TextStyle(
                          color: Color(0xFF263248),
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Used only if your primary contact is unavailable.',
                        style: TextStyle(
                          color: Color(0xFF687286),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Secondary contact fields
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          crossFadeState: _showSecondaryContact
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: _buildSecondaryContact(),
          secondChild: const SizedBox.shrink(),
        ),

        const SizedBox(height: 18),

        // Privacy message
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F2FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                color: Color(0xFF6246E5),
                size: 18,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Your contact information is private and used only '
                  'to help your organization communicate with you.',
                  style: TextStyle(
                    color: Color(0xFF687286),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryContact() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildField(
                  label: 'Secondary Email',
                  optional: true,
                  icon: Icons.mail_outline_rounded,
                  child: TextFormField(
                    controller: _secondaryEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration(
                      hintText: 'Enter email address',
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: _buildField(
                  label: 'Secondary Phone',
                  optional: true,
                  icon: Icons.phone_outlined,
                  child: TextFormField(
                    controller: _secondaryPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration(
                      hintText: 'Enter phone number',
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _buildField(
            label: 'Contact Notes',
            optional: true,
            icon: Icons.note_alt_outlined,
            child: TextFormField(
              controller: _contactNotesController,
              maxLines: 3,
              decoration: _inputDecoration(
                hintText:
                    'E.g., best way to reach this contact, preferred hours, etc.',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required IconData icon,
    required Widget child,
    bool optional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF6246E5), size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF263248),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (optional) ...[
              const SizedBox(width: 5),
              const Text(
                '(optional)',
                style: TextStyle(
                  color: Color(0xFF8A93A3),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 8),

        child,
      ],
    );
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF9AA2B1), fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDDE1EA)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDDE1EA)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF6246E5), width: 1.5),
      ),
    );
  }
}
