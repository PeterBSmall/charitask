import 'package:flutter/material.dart';

import 'package:charitask/domain/organization/organization_mission.dart';

class OrganizationMissionOption {
  final OrganizationMission mission;
  final IconData icon;
  final String title;
  final String subtitle;

  const OrganizationMissionOption({
    required this.mission,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

const organizationMissions = [
  OrganizationMissionOption(
    mission: OrganizationMission.communityService,
    icon: Icons.volunteer_activism_outlined,
    title: 'Community Service',
    subtitle: 'Serving and strengthening local communities.',
  ),
  OrganizationMissionOption(
    mission: OrganizationMission.housing,
    icon: Icons.home_outlined,
    title: 'Housing & Shelter',
    subtitle: 'Building homes and creating safe places to live.',
  ),
  OrganizationMissionOption(
    mission: OrganizationMission.foodSecurity,
    icon: Icons.restaurant_outlined,
    title: 'Food Security',
    subtitle: 'Providing meals and reducing hunger.',
  ),
  OrganizationMissionOption(
    mission: OrganizationMission.youthFamily,
    icon: Icons.family_restroom_outlined,
    title: 'Youth & Family',
    subtitle: 'Supporting children, youth and families.',
  ),
  OrganizationMissionOption(
    mission: OrganizationMission.worshipMinistry,
    icon: Icons.church_outlined,
    title: 'Worship & Ministry',
    subtitle: 'Growing faith through worship and service.',
  ),
  OrganizationMissionOption(
    mission: OrganizationMission.education,
    icon: Icons.school_outlined,
    title: 'Education',
    subtitle: 'Learning, teaching and lifelong development.',
  ),
  OrganizationMissionOption(
    mission: OrganizationMission.communityOutreach,
    icon: Icons.public_outlined,
    title: 'Community Outreach',
    subtitle: 'Connecting people through outreach initiatives.',
  ),
  OrganizationMissionOption(
    mission: OrganizationMission.advocacySupport,
    icon: Icons.handshake_outlined,
    title: 'Advocacy & Support',
    subtitle: 'Empowering people through guidance and support.',
  ),
  OrganizationMissionOption(
    mission: OrganizationMission.artsCulture,
    icon: Icons.palette_outlined,
    title: 'Arts & Culture',
    subtitle: 'Celebrating creativity and cultural enrichment.',
  ),
  OrganizationMissionOption(
    mission: OrganizationMission.healthWellness,
    icon: Icons.local_hospital_outlined,
    title: 'Health & Wellness',
    subtitle: 'Promoting healthier individuals and communities.',
  ),
];
