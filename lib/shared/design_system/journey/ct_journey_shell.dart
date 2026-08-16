import 'package:flutter/material.dart';

class CTJourneyShell extends StatelessWidget {
  final Widget leftPanel;
  final Widget rightPanel;

  const CTJourneyShell({
    super.key,
    required this.leftPanel,
    required this.rightPanel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            // ------------------------------------------------------------
            // RESPONSIVE SHELL SIZING
            // ------------------------------------------------------------
            final horizontalPadding = width >= 1200
                ? 48.0
                : width >= 900
                ? 28.0
                : 18.0;

            final verticalPadding = height >= 800
                ? 48.0
                : height >= 650
                ? 28.0
                : 18.0;

            final panelGap = width >= 1200
                ? 48.0
                : width >= 900
                ? 28.0
                : 18.0;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1500),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --------------------------------------------------
                      // LEFT HERO
                      // --------------------------------------------------
                      Expanded(flex: 1, child: leftPanel),

                      SizedBox(width: panelGap),

                      // --------------------------------------------------
                      // RIGHT JOURNEY CARD
                      // --------------------------------------------------
                      Expanded(flex: 1, child: rightPanel),
                    ],
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
