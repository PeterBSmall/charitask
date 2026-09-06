import 'package:flutter/material.dart';

import '../widgets/imported_person_details.dart';
import '../widgets/personal_workspace_action_card.dart';

class PersonalDetailsStep extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String organizationalRole;

  final VoidCallback onEditDetails;
  final VoidCallback onConfirm;
  final ValueChanged<bool>? onUseForFutureWorkspaces;

  const PersonalDetailsStep({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.organizationalRole,
    required this.onEditDetails,
    required this.onConfirm,
    this.onUseForFutureWorkspaces,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 900;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1250),
            child: _buildContent(context, isCompact: isCompact),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, {required bool isCompact}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: isCompact ? _buildCompactLayout() : _buildWideLayout(),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: _buildIntroductionPanel()),
        Container(width: 1, color: const Color(0xFFE5E7EB)),
        Expanded(flex: 6, child: _buildDetailsPanel()),
      ],
    );
  }

  Widget _buildCompactLayout() {
    return Column(
      children: [
        _buildIntroductionPanel(),
        Container(height: 1, color: const Color(0xFFE5E7EB)),
        _buildDetailsPanel(),
      ],
    );
  }

  Widget _buildIntroductionPanel() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          _buildPersonIcon(),

          const SizedBox(height: 20),

          const Text(
            "Let's set up your\npersonal workspace",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              height: 1.15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF182230),
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            "We've imported your details from your "
            "organization profile to help you get "
            "started faster.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Color(0xFF667085),
            ),
          ),

          const SizedBox(height: 28),

          _buildIllustration(),

          const SizedBox(height: 28),

          _buildPrivacyNotice(),
        ],
      ),
    );
  }

  Widget _buildPersonIcon() {
    return Container(
      width: 82,
      height: 82,
      decoration: const BoxDecoration(
        color: Color(0xFFF0ECFF),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.person_outline_rounded,
            size: 48,
            color: Color(0xFF6246E5),
          ),
          Positioned(
            right: 7,
            bottom: 7,
            child: Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                color: Color(0xFF6246E5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300, minHeight: 230),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1FF),
        borderRadius: BorderRadius.circular(150),
      ),
      child: const Center(
        child: Icon(Icons.person_rounded, size: 150, color: Color(0xFF6246E5)),
      ),
    );
  }

  Widget _buildPrivacyNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_outline_rounded, color: Color(0xFF6246E5), size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your information is private and secure.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF344054),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'It will only be used to personalize your '
                  'workspace experience.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsPanel() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your details (imported)',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF182230),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "We've imported the following information from your "
            "organization profile. You can review and edit anything "
            "before continuing.",
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF667085),
            ),
          ),

          const SizedBox(height: 24),

          ImportedPersonDetails(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            organizationalRole: organizationalRole,
          ),

          const SizedBox(height: 28),

          const Text(
            "What's next?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF182230),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Confirm your details to set up your personal workspace, "
            "or edit your information if you'd like to make changes.",
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF667085),
            ),
          ),

          const SizedBox(height: 20),

          _buildActions(),

          const SizedBox(height: 20),

          _buildFutureWorkspaceOption(),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stack = constraints.maxWidth < 620;

        if (stack) {
          return Column(
            children: [
              PersonalWorkspaceActionCard(
                icon: Icons.edit_rounded,
                title: 'Edit Details',
                description: 'Make changes to your personal information.',
                buttonLabel: 'Edit Details',
                isPrimary: false,
                onPressed: onEditDetails,
              ),
              const SizedBox(height: 14),
              PersonalWorkspaceActionCard(
                icon: Icons.check_rounded,
                title: 'Confirm & Continue',
                description: 'Use this information to set up your workspace.',
                buttonLabel: 'Confirm & Continue',
                isPrimary: true,
                onPressed: onConfirm,
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PersonalWorkspaceActionCard(
                icon: Icons.edit_rounded,
                title: 'Edit Details',
                description: 'Make changes to your personal information.',
                buttonLabel: 'Edit Details',
                isPrimary: false,
                onPressed: onEditDetails,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PersonalWorkspaceActionCard(
                icon: Icons.check_rounded,
                title: 'Confirm & Continue',
                description: 'Use this information to set up your workspace.',
                buttonLabel: 'Confirm & Continue',
                isPrimary: true,
                onPressed: onConfirm,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFutureWorkspaceOption() {
    return CheckboxListTile(
      value: false,
      onChanged: (value) {
        onUseForFutureWorkspaces?.call(value ?? false);
      },
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      title: const Text(
        'Use this information for future workspaces',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF344054),
        ),
      ),
      subtitle: const Padding(
        padding: EdgeInsets.only(top: 4),
        child: Text(
          'You can always update this later in your settings.',
          style: TextStyle(fontSize: 12, color: Color(0xFF667085)),
        ),
      ),
    );
  }
}
