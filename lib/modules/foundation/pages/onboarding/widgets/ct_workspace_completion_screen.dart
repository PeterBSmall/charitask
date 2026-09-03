import 'package:flutter/material.dart';

import 'package:charitask/domain/mission_profile/mission_profile.dart';

class CTWorkspaceCompletionScreen extends StatelessWidget {
  final CTMissionProfile profile;
  final VoidCallback onCompleteProfile;
  final VoidCallback onGoToWorkspace;

  const CTWorkspaceCompletionScreen({
    super.key,
    required this.profile,
    required this.onCompleteProfile,
    required this.onGoToWorkspace,
  });
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final compact = height < 760;
        final veryCompact = height < 650;
        final narrow = width < 900;

        final horizontalPadding = narrow ? 16.0 : 28.0;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            compact ? 16 : 24,
            horizontalPadding,
            14,
          ),
          child: Column(
            children: [
              // -------------------------------------------------------------
              // HEADER
              // -------------------------------------------------------------
              _CompletionHeader(compact: compact),

              SizedBox(
                height: veryCompact
                    ? 8
                    : compact
                    ? 12
                    : 18,
              ),

              // -------------------------------------------------------------
              // CARDS
              //
              // The cards now take ONLY the space remaining after the
              // header/footer. No fixed height.
              // -------------------------------------------------------------
              SizedBox(
                height: compact ? 320 : 360,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _ActionCard(
                        icon: Icons.person_outline_rounded,
                        title: 'Create Your Personal Workspace',
                        description:
                            'Set up your personal workspace to organize your work, tasks, and collaborations in one place.',
                        highlights: const [
                          'Personal workspace setup',
                          'Manage your tasks',
                          'Organize your projects',
                          'Customize your workspace',
                        ],
                        buttonLabel: 'Create Workspace',
                        isPrimary: true,
                        onPressed: onCompleteProfile,
                      ),
                    ),
                    SizedBox(width: narrow ? 12 : 18),

                    Expanded(
                      child: _ActionCard(
                        icon: Icons.account_balance_outlined,
                        title: 'Go to Organizational Workspace',
                        description:
                            'Explore your organization and start managing your team.',
                        highlights: const [
                          'Overview & activity',
                          'Groups & teams',
                          'People & roles',
                          'Tasks & initiatives',
                        ],
                        buttonLabel: 'Go to Workspace',
                        isWorkspace: true,
                        onPressed: onGoToWorkspace,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: veryCompact ? 6 : 10),

              // -------------------------------------------------------------
              // FOOTER
              // -------------------------------------------------------------
              const _FooterMessage(),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// HEADER
// =============================================================================

class _CompletionHeader extends StatelessWidget {
  final bool compact;

  const _CompletionHeader({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Your organization is ready!',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: compact ? 28 : 34,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF273247),
            height: 1.15,
          ),
        ),

        SizedBox(height: compact ? 8 : 12),

        Text(
          'You’ve set up your organization and created your personal profile.\n'
          'Here are your next steps.',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: compact ? 13 : 15,
            color: const Color(0xFF718096),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// ACTION CARD
// =============================================================================

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<String> highlights;
  final String buttonLabel;
  final bool isPrimary;
  final bool isWorkspace;
  final VoidCallback onPressed;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.highlights,
    required this.buttonLabel,
    required this.onPressed,
    this.isPrimary = false,
    this.isWorkspace = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;

        final accent = isWorkspace
            ? const Color(0xFF5878D9)
            : const Color(0xFF6547E8);

        final iconBackground = isWorkspace
            ? const Color(0xFFEAF0FF)
            : const Color(0xFFF0EBFF);

        // ---------------------------------------------------------------
        // Determine how aggressively the card should compact itself.
        //
        // We deliberately use a continuous scale rather than several
        // hard breakpoints. This prevents the layout from suddenly
        // changing when the window is resized by a few pixels.
        // ---------------------------------------------------------------
        final widthScale = (availableWidth / 260.0).clamp(0.72, 1.0);
        final heightScale = (availableHeight / 420.0).clamp(0.62, 1.0);

        final contentScale = widthScale < heightScale
            ? widthScale
            : heightScale;

        final horizontalPadding = 18.0 * contentScale;
        final iconSize = 58.0 * contentScale;
        final iconGlyphSize = 29.0 * contentScale;

        final titleSize = 20.0 * contentScale;
        final descriptionSize = 13.0 * contentScale;
        final highlightSize = 13.0 * contentScale;
        final checkSize = 19.0 * contentScale;

        final buttonHeight = (48.0 * contentScale).clamp(34.0, 48.0);
        final buttonTextSize = (13.5 * contentScale).clamp(10.0, 13.5);
        final arrowSize = (18.0 * contentScale).clamp(14.0, 18.0);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2DFEA)),
          ),
          child: Padding(
            padding: EdgeInsets.all(horizontalPadding),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: SizedBox(
                width: availableWidth > 0
                    ? availableWidth - (horizontalPadding * 2)
                    : 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ---------------------------------------------------
                    // ICON
                    // ---------------------------------------------------
                    Center(
                      child: Container(
                        width: iconSize,
                        height: iconSize,
                        decoration: BoxDecoration(
                          color: iconBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: accent, size: iconGlyphSize),
                      ),
                    ),

                    SizedBox(height: 12.0 * contentScale),

                    // ---------------------------------------------------
                    // TITLE
                    // ---------------------------------------------------
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF273247),
                        height: 1.15,
                      ),
                    ),

                    SizedBox(height: 8.0 * contentScale),

                    // ---------------------------------------------------
                    // DESCRIPTION
                    // ---------------------------------------------------
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: descriptionSize,
                        color: const Color(0xFF718096),
                        height: 1.25,
                      ),
                    ),

                    SizedBox(height: 12.0 * contentScale),

                    const Divider(height: 1, color: Color(0xFFEAE7EF)),

                    SizedBox(height: 8.0 * contentScale),

                    // ---------------------------------------------------
                    // HIGHLIGHTS
                    //
                    // IMPORTANT:
                    // No Expanded here.
                    //
                    // The entire card content is allowed to scale as
                    // one unit so it can never push the button outside
                    // the card.
                    // ---------------------------------------------------
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: highlights.map((highlight) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 3.0 * contentScale,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: accent,
                                size: checkSize,
                              ),

                              SizedBox(width: 7.0 * contentScale),

                              Expanded(
                                child: Text(
                                  highlight,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: highlightSize,
                                    color: const Color(0xFF59677D),
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 10.0 * contentScale),

                    // ---------------------------------------------------
                    // BUTTON
                    // ---------------------------------------------------
                    SizedBox(
                      width: double.infinity,
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: onPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0 * contentScale,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              11.0 * contentScale,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              child: Text(
                                buttonLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: buttonTextSize,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            SizedBox(width: 7.0 * contentScale),

                            Icon(Icons.arrow_forward_rounded, size: arrowSize),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// FOOTER
// =============================================================================

class _FooterMessage extends StatelessWidget {
  const _FooterMessage();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lightbulb_outline_rounded,
          size: 16,
          color: Color(0xFF7A8A7A),
        ),

        SizedBox(width: 8),

        Flexible(
          child: Text(
            'You can always access these options later from your dashboard.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFF667085)),
          ),
        ),
      ],
    );
  }
}
