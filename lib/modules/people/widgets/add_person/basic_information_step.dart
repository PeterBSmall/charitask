import 'package:flutter/material.dart';

import 'add_person_step_template.dart';
import 'add_person_story_panel.dart';
import 'basic_information/sections/contact_section.dart';
import 'basic_information/sections/notes_section.dart';
import 'basic_information/sections/name_section.dart';
import 'basic_information/sections/personal_details_section.dart';

class BasicInformationStep extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController preferredNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController dateOfBirthController;
  final TextEditingController providerNameController;
  final TextEditingController providerRelationshipController;
  final TextEditingController notesController;

  final String informationProviderType;
  final ValueChanged<String> onInformationProviderTypeChanged;

  final String? preferredContactMethod;
  final ValueChanged<String?> onPreferredContactMethodChanged;

  const BasicInformationStep({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.preferredNameController,
    required this.emailController,
    required this.phoneController,
    required this.dateOfBirthController,
    required this.providerNameController,
    required this.providerRelationshipController,
    required this.notesController,
    required this.informationProviderType,
    required this.onInformationProviderTypeChanged,
    required this.preferredContactMethod,
    required this.onPreferredContactMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AddPersonStepTemplate(
      storyContent: const AddPersonStoryPanel(
        title: 'People',
        highlightedText: 'power progress.',
        description:
            'Every person brings something valuable to your organization. '
            'Start by getting to know the basics.',
        icon: Icons.person_add_alt_1_rounded,
      ),
      title: 'Basic information',
      description:
          'Add the essential details that help identify and connect with this person.',
      sideContent: const _BasicInformationHelp(),
      child: _BasicInformationForm(
        firstNameController: firstNameController,
        lastNameController: lastNameController,
        preferredNameController: preferredNameController,
        emailController: emailController,
        phoneController: phoneController,
        dateOfBirthController: dateOfBirthController,
        providerNameController: providerNameController,
        providerRelationshipController: providerRelationshipController,
        notesController: notesController,
        informationProviderType: informationProviderType,
        onInformationProviderTypeChanged: onInformationProviderTypeChanged,
        preferredContactMethod: preferredContactMethod,
        onPreferredContactMethodChanged: onPreferredContactMethodChanged,
      ),
    );
  }
}

class _BasicInformationForm extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController preferredNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController dateOfBirthController;
  final TextEditingController providerNameController;
  final TextEditingController providerRelationshipController;
  final TextEditingController notesController;

  final String informationProviderType;
  final ValueChanged<String> onInformationProviderTypeChanged;

  final String? preferredContactMethod;
  final ValueChanged<String?> onPreferredContactMethodChanged;

  const _BasicInformationForm({
    required this.firstNameController,
    required this.lastNameController,
    required this.preferredNameController,
    required this.emailController,
    required this.phoneController,
    required this.dateOfBirthController,
    required this.providerNameController,
    required this.providerRelationshipController,
    required this.notesController,
    required this.informationProviderType,
    required this.onInformationProviderTypeChanged,
    required this.preferredContactMethod,
    required this.onPreferredContactMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NameSection(
            firstNameController: firstNameController,
            lastNameController: lastNameController,
            preferredNameController: preferredNameController,
          ),
          const SizedBox(height: 32),
          PersonalDetailsSection(
            dateOfBirthController: dateOfBirthController,
            providerNameController: providerNameController,
            providerRelationshipController: providerRelationshipController,
            informationProviderType: informationProviderType,
            onInformationProviderTypeChanged: onInformationProviderTypeChanged,
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 28),
          ContactSection(
            emailController: emailController,
            phoneController: phoneController,
            preferredContactMethod: preferredContactMethod,
            onPreferredContactMethodChanged: onPreferredContactMethodChanged,
          ),
          const SizedBox(height: 32),
          NotesSection(controller: notesController),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _BasicInformationHelp extends StatelessWidget {
  const _BasicInformationHelp();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFF5B4BC4),
                    size: 24,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Why we ask',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2F3A4A),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18),
              Text(
                'Basic information helps your team identify the right person, '
                'communicate with them, and keep your organization connected.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F1FF),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF5B4BC4)),
              SizedBox(height: 12),
              Text(
                'Tip',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2F3A4A),
                ),
              ),
              SizedBox(height: 6),
              Text(
                'You can always update this information later.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
