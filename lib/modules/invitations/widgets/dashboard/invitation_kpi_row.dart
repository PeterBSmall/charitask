import 'package:flutter/material.dart';

import 'invitation_kpi_card.dart';

class InvitationKpiRow extends StatelessWidget {
  const InvitationKpiRow({
    super.key,
    required this.pending,
    required this.accepted,
    required this.expired,
    required this.totalSent,
  });

  final int pending;
  final int accepted;
  final int expired;
  final int totalSent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1050
            ? 4
            : constraints.maxWidth >= 650
            ? 2
            : 1;

        const spacing = 14.0;

        final cardWidth = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            SizedBox(
              width: cardWidth,
              child: InvitationKpiCard(
                icon: Icons.schedule_outlined,
                label: 'Pending',
                value: '$pending',
                description: 'Awaiting response',
                iconBackground: const Color(0xFFE0F2FE),
                iconColor: const Color(0xFF0284C7),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: InvitationKpiCard(
                icon: Icons.check_circle_outline_rounded,
                label: 'Accepted',
                value: '$accepted',
                description: 'Joined successfully',
                iconBackground: const Color(0xFFDCFCE7),
                iconColor: const Color(0xFF16A34A),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: InvitationKpiCard(
                icon: Icons.schedule_rounded,
                label: 'Expired',
                value: '$expired',
                description: 'No response',
                iconBackground: const Color(0xFFF1F5F9),
                iconColor: const Color(0xFF64748B),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: InvitationKpiCard(
                icon: Icons.bar_chart_rounded,
                label: 'Total Sent',
                value: '$totalSent',
                description: 'All invitations issued',
                iconBackground: const Color(0xFFEDE9FE),
                iconColor: const Color(0xFF7C3AED),
              ),
            ),
          ],
        );
      },
    );
  }
}
