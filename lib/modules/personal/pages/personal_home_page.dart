import 'package:flutter/material.dart';

import 'package:charitask/modules/personal/widgets/home/personal_home_action_center.dart';
import 'package:charitask/modules/personal/widgets/home/personal_home_activity.dart';
import 'package:charitask/modules/personal/widgets/home/personal_home_header.dart';
import 'package:charitask/modules/personal/widgets/home/personal_home_hero.dart';
import 'package:charitask/modules/personal/widgets/home/personal_home_organizations.dart';
import 'package:charitask/modules/personal/widgets/home/personal_home_right_rail.dart';
import 'package:charitask/modules/personal/widgets/home/personal_home_sidebar.dart';
import 'package:charitask/modules/personal/widgets/home/personal_home_stats.dart';
import 'package:charitask/modules/personal/widgets/home/personal_home_workspaces.dart';

class PersonalHomePage extends StatelessWidget {
  const PersonalHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      body: Row(
        children: [
          const PersonalHomeSidebar(),

          Expanded(
            child: Column(
              children: [
                const PersonalHomeHeader(),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // =================================================
                        // MAIN DASHBOARD
                        // =================================================
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: const [
                              PersonalHomeHero(),
                              SizedBox(height: 20),
                              PersonalHomeStats(),
                              SizedBox(height: 28),
                              PersonalHomeWorkspaces(),
                              SizedBox(height: 28),
                              PersonalHomeOrganizations(),
                              SizedBox(height: 28),
                              PersonalHomeActionCenter(),
                              SizedBox(height: 28),
                              PersonalHomeActivity(),
                              SizedBox(height: 24),
                            ],
                          ),
                        ),

                        const SizedBox(width: 24),

                        // =================================================
                        // RIGHT RAIL
                        // =================================================
                        const SizedBox(
                          width: 300,
                          child: PersonalHomeRightRail(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
