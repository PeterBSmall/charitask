import 'package:flutter/material.dart';

import 'package:charitask/shared/widgets/buttons/ct_button.dart';
import 'package:charitask/shared/models/ct_workspace_overview_config.dart';

class CTWorkspaceOverview extends StatelessWidget {
  final CTWorkspaceOverviewConfig config;

  const CTWorkspaceOverview({super.key, required this.config});

  bool get _isCompleted => config.progress == null;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (_isCompleted) {
            return _buildCompletedLayout(context, constraints);
          }

          return _buildSetupLayout(context, constraints);
        },
      ),
    );
  }

  // ===========================================================================
  // COMPLETED ORGANIZATION / PERSONAL WORKSPACE
  // ===========================================================================

  Widget _buildCompletedLayout(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final isNarrow = constraints.maxWidth < 850;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 270),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF17142D), Color(0xFF30206F), Color(0xFF4B20D4)],
            stops: [0.0, 0.52, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative purple glow
            Positioned(
              right: -120,
              top: -180,
              child: Container(
                width: 520,
                height: 520,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF8B5CF6).withValues(alpha: 0.65),
                      const Color(0xFF5B21B6).withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Decorative lower-right glow
            Positioned(
              right: -100,
              bottom: -220,
              child: Container(
                width: 600,
                height: 420,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF6D28D9).withValues(alpha: 0.8),
                      const Color(0xFF4C1D95).withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
              child: isNarrow
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCompletedText(),
                        const SizedBox(height: 24),
                        _buildCompletedIllustration(),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 6, child: _buildCompletedText()),
                        const SizedBox(width: 28),
                        Expanded(flex: 4, child: _buildCompletedIllustration()),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedText() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Workspace status pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: Color(0xFF9BE564),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 9),
              const Text(
                'ORGANIZATION WORKSPACE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        Text(
          config.welcomeMessage,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 32,
            height: 1.18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 18),

        Text(
          config.organizationName,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            height: 1.45,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),

        if (config.primaryButtonLabel.isNotEmpty) ...[
          const SizedBox(height: 24),
          CTButton(
            label: config.primaryButtonLabel,
            onPressed: config.onPrimaryPressed,
          ),
        ],
      ],
    );
  }

  Widget _buildCompletedIllustration() {
    return SizedBox(
      height: 190,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Glass organization card
            Container(
              width: 220,
              height: 165,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 30,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_rounded,
                    size: 52,
                    color: Colors.white.withValues(alpha: 0.95),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _illustrationWindow(),
                      const SizedBox(width: 12),
                      _illustrationWindow(),
                      const SizedBox(width: 12),
                      _illustrationWindow(),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Container(
                    width: 62,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),

            // Green completed badge
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Color(0xFF8BCB5A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),

            // Activity badge
            Positioned(
              left: 0,
              top: 78,
              child: _heroFloatingBadge(icon: Icons.trending_up_rounded),
            ),

            // Decorative sparkle
            Positioned(
              right: -8,
              bottom: 42,
              child: Icon(
                Icons.auto_awesome,
                size: 25,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _illustrationWindow() {
    return Container(
      width: 24,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _illustrationBadge({required IconData icon}) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
      ),
      child: Icon(icon, size: 21, color: Colors.white),
    );
  }

  Widget _heroFloatingBadge({required IconData icon}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Icon(icon, size: 23, color: Colors.white),
    );
  }

  // ===========================================================================
  // SETUP STATE
  // ===========================================================================

  Widget _buildSetupLayout(BuildContext context, BoxConstraints constraints) {
    final isNarrow = constraints.maxWidth < 1100;

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSetupText(),

          const SizedBox(height: 24),

          _buildProgressCard(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 6, child: _buildSetupText()),

        const SizedBox(width: 32),

        Expanded(flex: 4, child: _buildProgressCard()),
      ],
    );
  }

  Widget _buildSetupText() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          config.greeting,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          config.welcomeMessage,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 26,
            height: 1.2,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          config.organizationName,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 17,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 14),

        Text(
          config.mission,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            height: 1.4,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard() {
    final progress = config.progress!;
    final nextStep = config.nextStep!;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.white70,
                size: 18,
              ),

              const SizedBox(width: 8),

              const Expanded(
                child: Text(
                  'SETUP PROGRESS',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            nextStep,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: CTButton(
                  label: config.primaryButtonLabel,
                  onPressed: config.onPrimaryPressed,
                ),
              ),

              if (config.secondaryButtonLabel != null) ...[
                const SizedBox(width: 12),

                Expanded(
                  child: CTButton(
                    label: config.secondaryButtonLabel!,
                    onPressed: config.onSecondaryPressed,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
