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
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: config.backgroundGradient,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 30,
            offset: Offset(0, 16),
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

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCompletedText(),

          const SizedBox(height: 24),

          _buildCompletedIllustration(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 6, child: _buildCompletedText()),

        const SizedBox(width: 28),

        Expanded(flex: 4, child: _buildCompletedIllustration()),
      ],
    );
  }

  Widget _buildCompletedText() {
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
            fontSize: 30,
            height: 1.18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 14),

        Text(
          config.organizationName,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            height: 1.45,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 24),

        CTButton(
          label: config.primaryButtonLabel,
          onPressed: config.onPrimaryPressed,
        ),
      ],
    );
  }

  Widget _buildCompletedIllustration() {
    return SizedBox(
      height: 190,
      child: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Ground
            Container(
              width: 280,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(100),
              ),
            ),

            // Organization building
            Container(
              width: 180,
              height: 125,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),

                  Icon(
                    Icons.account_balance_rounded,
                    size: 46,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _illustrationWindow(),
                      const SizedBox(width: 10),
                      _illustrationWindow(),
                      const SizedBox(width: 10),
                      _illustrationWindow(),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Container(
                    width: 48,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ],
              ),
            ),

            // Status badge
            Positioned(
              right: 8,
              top: 18,
              child: _illustrationBadge(icon: Icons.check_rounded),
            ),

            // Activity badge
            Positioned(
              left: 14,
              top: 42,
              child: _illustrationBadge(icon: Icons.trending_up_rounded),
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
