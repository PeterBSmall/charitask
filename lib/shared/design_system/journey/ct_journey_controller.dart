import 'package:flutter/material.dart';
import 'package:charitask/domain/organization/organization.dart';
import 'package:charitask/domain/organization/organization_type.dart';

class CTJourneyController extends ChangeNotifier {
  int currentStep = 0;

  final Organization organization = Organization();

  String organizationLocation = '';
  String firstName = '';

  void updateFirstName(String value) {
    firstName = value;
    notifyListeners();
  }

  void nextStep() {
    currentStep++;
    notifyListeners();
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  void updateOrganizationName(String value) {
    organization.identity.name = value;
    notifyListeners();
  }

  void updateOrganizationType(OrganizationType value) {
    organization.identity.type = value;
    notifyListeners();
  }

  void updateOrganizationLocation(String value) {
    organizationLocation = value;
    notifyListeners();
  }
}
