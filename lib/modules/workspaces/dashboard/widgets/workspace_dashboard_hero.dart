import 'package:flutter/material.dart';

import '../models/workspace_dashboard_config.dart';

class WorkspaceDashboardHero extends StatelessWidget {
  final WorkspaceDashboardConfig config;

  const WorkspaceDashboardHero({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [_buildBackground(), _buildOverlay(), _buildContent()],
      ),
    );
  }

  Widget _buildBackground() {
    if (config.heroImagePath != null) {
      return Image.asset(
        config.heroImagePath!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildGradientBackground();
        },
      );
    }

    return _buildGradientBackground();
  }

  Widget _buildGradientBackground() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: config.heroGradient,
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white.withValues(alpha: 0.96),
            Colors.white.withValues(alpha: 0.78),
            Colors.transparent,
          ],
          stops: const [0.0, 0.42, 0.78],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 34, 40, 34),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildWorkspacePill(),
              const SizedBox(height: 22),
              Text(
                config.greeting,
                style: const TextStyle(
                  fontSize: 31,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF18245A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                config.headline,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 27,
                  height: 1.18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF18245A),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                config.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF34416B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkspacePill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: config.accentColor.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.workspaceIcon, size: 18, color: config.accentColor),
          const SizedBox(width: 8),
          Text(
            config.workspaceLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.35,
              color: config.accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
