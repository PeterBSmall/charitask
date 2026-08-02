import 'package:flutter/material.dart';

class CTJourneyController extends ChangeNotifier {
  int currentStep = 0;

  String organizationName = '';
  String organizationType = '';
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
    organizationName = value;
    notifyListeners();
  }

  void updateOrganizationType(String value) {
    organizationType = value;
    notifyListeners();
  }

  void updateOrganizationLocation(String value) {
    organizationLocation = value;
    notifyListeners();
  }
}
