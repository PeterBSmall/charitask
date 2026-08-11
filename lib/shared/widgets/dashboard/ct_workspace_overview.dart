import 'package:flutter/material.dart';

import 'package:charitask/shared/widgets/buttons/ct_button.dart';
import 'package:charitask/shared/models/ct_workspace_overview_config.dart';

class CTWorkspaceOverview extends StatelessWidget {
  final CTWorkspaceOverviewConfig config;

  const CTWorkspaceOverview({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
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
      child: Stack(
        children: [
          // Background Watermark
          Positioned(
            right: -40,
            top: -30,
            child: Icon(
              config.icon,
              size: 240,
              color: Colors.white.withOpacity(.06),
            ),
          ),

          // Soft Glow
          Positioned(
            left: -80,
            bottom: -80,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(.08),
              ),
            ),
          ),

          // Main Content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.greeting,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      config.welcomeMessage,
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.15,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      config.organizationName,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 22),

                    Text(
                      config.mission,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ─────────────────────────────────────────
                    // NEXT STEP PANEL
                    // ─────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(28, 22, 28, 24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.09),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withOpacity(.14),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Next step + percentage
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  config.nextStep,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),

                              Text(
                                '${(config.progress * 100).round()}%',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: LinearProgressIndicator(
                              value: config.progress,
                              minHeight: 10,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Actions
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CTButton(
                                    label: config.primaryButtonLabel,
                                    onPressed: config.onPrimaryPressed,
                                  ),

                                  const SizedBox(width: 16),

                                  CTButton(
                                    label: config.secondaryButtonLabel,
                                    onPressed: config.onSecondaryPressed,
                                    isPrimary: false,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    // Save progress and finish later.
                                    // Persistence will be connected later.
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white70,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                  ),
                                  child: const Text(
                                    'Save and finish later',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 56),

              // Workspace identity
              Column(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.white24,
                    child: Icon(config.icon, color: Colors.white, size: 46),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    config.suiteName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white70,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Workspace',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
