import 'package:flutter/material.dart';

import 'package:charitask/shared/custom_types/custom_type.dart';

import 'add_person_step_template.dart';
import 'details/details_form.dart';
import 'details/details_help_panel.dart';
import 'details/details_story_panel.dart';

class MembershipStep extends StatelessWidget {
  final String connectionType;
  final String membershipStatus;
  final String roleCategory;
  final String? donorType;
  final TextEditingController joinDateController;

  final ValueChanged<String> onMembershipStatusChanged;
  final ValueChanged<String> onRoleCategoryChanged;
  final ValueChanged<String?> onDonorTypeChanged;

  // Custom donor types.
  final List<CustomType> customTypes;
  final ValueChanged<CustomType> onCustomTypeAdded;

  const MembershipStep({
    super.key,
    required this.connectionType,
    required this.membershipStatus,
    required this.roleCategory,
    required this.donorType,
    required this.joinDateController,
    required this.onMembershipStatusChanged,
    required this.onRoleCategoryChanged,
    required this.onDonorTypeChanged,
    required this.customTypes,
    required this.onCustomTypeAdded,
  });

  @override
  Widget build(BuildContext context) {
    return AddPersonStepTemplate(
      storyContent: const DetailsStoryPanel(),

      title: 'Tell us a little more',
      description:
          'Add details that help define this person’s relationship with your organization.',

      child: DetailsForm(
        connectionType: connectionType,
        roleCategory: roleCategory,
        donorType: donorType,
        onRoleCategoryChanged: onRoleCategoryChanged,
        onDonorTypeChanged: onDonorTypeChanged,

        customTypes: customTypes,
        onCustomTypeAdded: onCustomTypeAdded,
      ),

      sideContent: const DetailsHelpPanel(),
    );
  }
}
