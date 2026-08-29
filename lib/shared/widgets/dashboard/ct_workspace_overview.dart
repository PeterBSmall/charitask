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
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          // Background watermark
          Positioned(
            right: -20,
            bottom: -35,
            child: Icon(
              config.icon,
              size: 180,
              color: Colors.white.withOpacity(.06),
            ),
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 1100;

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          config.greeting,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          config.welcomeMessage,
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
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          config.mission,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.4,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // RIGHT PROGRESS CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.09),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withOpacity(.14),
                        ),
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
                                '${(config.progress * 100).round()}%',
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
                            config.nextStep,
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
                              value: config.progress,
                              minHeight: 8,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CTButton(
                                label: config.primaryButtonLabel,
                                onPressed: config.onPrimaryPressed,
                              ),

                              const SizedBox(height: 12),

                              CTButton(
                                label: config.secondaryButtonLabel,
                                onPressed: config.onSecondaryPressed,
                                isPrimary: false,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // LEFT
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          config.greeting,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          config.welcomeMessage,
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
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          config.mission,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.4,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 32),

                  // RIGHT PROGRESS CARD
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.09),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withOpacity(.14),
                        ),
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
                                '${(config.progress * 100).round()}%',
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
                            config.nextStep,
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
                              value: config.progress,
                              minHeight: 8,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
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

                              const SizedBox(width: 12),

                              Expanded(
                                child: CTButton(
                                  label: config.secondaryButtonLabel,
                                  onPressed: config.onSecondaryPressed,
                                  isPrimary: false,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
