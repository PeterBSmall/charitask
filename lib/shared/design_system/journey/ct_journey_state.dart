import 'package:flutter/material.dart';

class CTJourneyState extends ChangeNotifier {
  String firstName = '';

  String organizationName = '';

  String organizationType = '';

  String location = '';

  void setFirstName(String value) {
    firstName = value;
    notifyListeners();
  }

  void setOrganizationName(String value) {
    organizationName = value;
    notifyListeners();
  }

  void setOrganizationType(String value) {
    organizationType = value;
    notifyListeners();
  }

  void setLocation(String value) {
    location = value;
    notifyListeners();
  }
}
