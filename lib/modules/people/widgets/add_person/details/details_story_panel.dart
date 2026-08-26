import 'package:flutter/material.dart';

import '../add_person_story_panel.dart';

class DetailsStoryPanel extends StatelessWidget {
  const DetailsStoryPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const AddPersonStoryPanel(
      title: 'Every person',
      highlightedText: 'has a story.',
      description:
          'Add a little more context to help your organization understand '
          'the person behind the profile.',
      icon: Icons.auto_stories_rounded,
    );
  }
}
