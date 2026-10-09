import 'package:flutter/material.dart';

class FunctionalRoleCategoryIcon {
  const FunctionalRoleCategoryIcon._();

  static IconData forSlug(String slug) {
    switch (slug) {
      case 'administration':
        return Icons.business_center_outlined;

      case 'leadership':
        return Icons.flag_outlined;

      case 'finance':
        return Icons.calculate_outlined;

      case 'fundraising-development':
        return Icons.card_giftcard;

      case 'volunteer-services':
        return Icons.groups_outlined;

      case 'programs-services':
        return Icons.volunteer_activism_outlined;

      case 'retail-operations':
        return Icons.storefront_outlined;

      case 'facilities-operations':
        return Icons.build_outlined;

      case 'human-resources':
        return Icons.people_alt_outlined;

      case 'marketing-communications':
        return Icons.campaign_outlined;

      // Future catalog categories.
      case 'security':
        return Icons.shield_outlined;

      case 'it-technology':
        return Icons.monitor_outlined;

      default:
        return Icons.folder_outlined;
    }
  }
}
