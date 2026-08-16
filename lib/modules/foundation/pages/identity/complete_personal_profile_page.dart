import 'package:flutter/material.dart';

import 'widgets/profile_hero_panel.dart';
import 'widgets/profile_about_you.dart';
import 'widgets/profile_role.dart';
import 'widgets/profile_contact_info.dart';

class CompletePersonalProfilePage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String organizationalRole;

  final VoidCallback onSkip;
  final void Function({String? preferredName, String? pronouns, String? phone})
  onComplete;

  const CompletePersonalProfilePage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.organizationalRole,
    required this.onSkip,
    required this.onComplete,
  });

  @override
  State<CompletePersonalProfilePage> createState() =>
      _CompletePersonalProfilePageState();
}

class _CompletePersonalProfilePageState
    extends State<CompletePersonalProfilePage> {
  int _currentStep = 1;

  late final TextEditingController _preferredNameController;
  late final TextEditingController _phoneController;

  String? _pronouns;

  @override
  void initState() {
    super.initState();

    _preferredNameController = TextEditingController();
    _phoneController = TextEditingController(text: widget.phone ?? '');
  }

  @override
  void dispose() {
    _preferredNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      return;
    }

    widget.onComplete(
      preferredName: _preferredNameController.text.trim().isEmpty
          ? null
          : _preferredNameController.text.trim(),
      pronouns: _pronouns,
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
    );
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    } else {
      widget.onSkip();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400, maxHeight: 900),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: [
                    const Expanded(flex: 38, child: ProfileHeroPanel()),

                    Expanded(flex: 62, child: _buildContent()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          const SizedBox(height: 14),

          _buildStepProgress(),

          const SizedBox(height: 20),

          _buildIntro(),

          const SizedBox(height: 24),

          Expanded(child: _buildCurrentStep()),

          const SizedBox(height: 16),

          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildStepProgress() {
    return Row(
      children: [
        _buildProgressStep(
          number: 1,
          label: 'About You',
          active: _currentStep >= 1,
        ),

        Expanded(
          child: Container(
            height: 2,
            color: _currentStep >= 2
                ? const Color(0xFF6246E5)
                : const Color(0xFFE1E4EC),
          ),
        ),

        _buildProgressStep(
          number: 2,
          label: 'Your Role',
          active: _currentStep >= 2,
        ),

        Expanded(
          child: Container(
            height: 2,
            color: _currentStep >= 3
                ? const Color(0xFF6246E5)
                : const Color(0xFFE1E4EC),
          ),
        ),

        _buildProgressStep(
          number: 3,
          label: 'Contact Info',
          active: _currentStep >= 3,
        ),
      ],
    );
  }

  Widget _buildProgressStep({
    required int number,
    required String label,
    required bool active,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? const Color(0xFF6246E5) : Colors.white,
            border: Border.all(
              color: active ? const Color(0xFF6246E5) : const Color(0xFFD9DDE7),
              width: 2,
            ),
          ),
          child: Center(
            child: active && _currentStep > number
                ? const Icon(Icons.check, color: Colors.white, size: 17)
                : Text(
                    '$number',
                    style: TextStyle(
                      color: active ? Colors.white : const Color(0xFF687286),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          label,
          style: TextStyle(
            color: active ? const Color(0xFF263248) : const Color(0xFF8A93A3),
            fontSize: 12,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: _previousStep,
          icon: const Icon(Icons.arrow_back_rounded),
        ),

        const SizedBox(width: 4),

        const Text(
          'Complete Your Personal Profile',
          style: TextStyle(
            color: Color(0xFF263248),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),

        const Spacer(),

        Text(
          'Step $_currentStep of 3',
          style: const TextStyle(
            color: Color(0xFF687286),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "LET'S PERSONALIZE YOUR EXPERIENCE.",
          style: TextStyle(
            color: Color(0xFF6246E5),
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Complete Your Personal Profile',
          style: TextStyle(
            color: Color(0xFF182238),
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Your profile helps ChariTask tailor tools and permissions to your role.',
          style: TextStyle(color: Color(0xFF687286), fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return _buildStepContainer(
          ProfileAboutYou(
            firstName: widget.firstName,
            lastName: widget.lastName,
            preferredNameController: _preferredNameController,
            pronouns: _pronouns,
            onPronounsChanged: (value) {
              setState(() {
                _pronouns = value;
              });
            },
          ),
        );

      case 2:
        return _buildStepContainer(
          ProfileRole(organizationalRole: widget.organizationalRole),
        );

      case 3:
        return _buildStepContainer(
          ProfileContactInfo(
            email: widget.email,
            phone: widget.phone,
            phoneController: _phoneController,
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStepContainer(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFAFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E0FF)),
      ),
      child: SingleChildScrollView(child: child),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: widget.onSkip,
              child: const Text(
                "I'll do this later",
                style: TextStyle(
                  color: Color(0xFF6246E5),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: _nextStep,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      _currentStep == 3
                          ? 'Save & Complete Profile'
                          : 'Continue',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward_rounded),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
