import 'package:flutter/material.dart';

import 'package:charitask/shared/widgets/cards/ct_summary_card.dart';

class FoundationActivity extends StatelessWidget {
  const FoundationActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return const CTSummaryCard(
      title: 'Recent Activity',
      subtitle:
          'Recent Foundation updates will appear here as your organization grows.',
    );
  }
}
