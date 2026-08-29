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

            // ------------------------------------------------------------
            // RESPONSIVE LAYOUT
            //
            // On a normal desktop window we keep the two-panel layout.
            // On a narrow window we stack the panels vertically so neither
            // side gets squeezed into an unusably narrow width.
            // ------------------------------------------------------------
            final useTwoPanels = width >= 1000;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1500),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: useTwoPanels
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // ------------------------------------------------
                            // LEFT HERO
                            // ------------------------------------------------
                            Expanded(flex: 9, child: leftPanel),

                            SizedBox(width: panelGap),

                            // ------------------------------------------------
                            // RIGHT JOURNEY CARD
                            //
                            // Give the journey side slightly more width
                            // because its content needs more horizontal room.
                            // ------------------------------------------------
                            Expanded(
                              flex: 11,
                              child: SingleChildScrollView(child: rightPanel),
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // ----------------------------------------------
                              // LEFT HERO
                              // ----------------------------------------------
                              SizedBox(height: 520, child: leftPanel),

                              SizedBox(height: panelGap),

                              // ----------------------------------------------
                              // RIGHT JOURNEY CARD
                              // ----------------------------------------------
                              rightPanel,
                            ],
                          ),
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
