enum ComplianceExpirationMode {
  expires('expires', 'Expires'),
  neverExpires('never_expires', 'Never Expires'),
  optional('optional', 'Optional');

  const ComplianceExpirationMode(this.value, this.label);

  final String value;
  final String label;

  static ComplianceExpirationMode fromValue(Object? value) {
    for (final mode in values) {
      if (mode.value == value) return mode;
    }
    return ComplianceExpirationMode.optional;
  }
}

enum ComplianceRenewalPeriodUnit {
  days('days', 'Days'),
  weeks('weeks', 'Weeks'),
  months('months', 'Months'),
  years('years', 'Years');

  const ComplianceRenewalPeriodUnit(this.value, this.label);

  final String value;
  final String label;

  static ComplianceRenewalPeriodUnit fromValue(Object? value) {
    for (final unit in values) {
      if (unit.value == value) return unit;
    }
    return ComplianceRenewalPeriodUnit.years;
  }
}

enum ComplianceNotificationRecipient {
  person('person', 'Person'),
  supervisor('supervisor', 'Supervisor');

  const ComplianceNotificationRecipient(this.value, this.label);

  final String value;
  final String label;

  static ComplianceNotificationRecipient fromValue(Object? value) {
    for (final recipient in values) {
      if (recipient.value == value) return recipient;
    }
    return ComplianceNotificationRecipient.person;
  }
}

class ComplianceNotificationRule {
  const ComplianceNotificationRule({
    required this.daysBefore,
    required this.recipient,
  });

  final int daysBefore;
  final ComplianceNotificationRecipient recipient;

  factory ComplianceNotificationRule.fromMap(Map<String, dynamic> map) {
    final rawDays = map['days_before'];
    return ComplianceNotificationRule(
      daysBefore: rawDays is num
          ? rawDays.toInt()
          : int.tryParse('$rawDays') ?? 0,
      recipient: ComplianceNotificationRecipient.fromValue(map['recipient']),
    );
  }

  Map<String, dynamic> toMap() => {
    'days_before': daysBefore,
    'recipient': recipient.value,
  };
}

/// Typed representation of the JSONB `rules` field on a requirement.
class ComplianceRuleSettings {
  const ComplianceRuleSettings({
    this.expirationMode = ComplianceExpirationMode.optional,
    this.renewalPeriodValue,
    this.renewalPeriodUnit = ComplianceRenewalPeriodUnit.years,
    this.requireDocumentUpload = false,
    this.requireApproval = false,
    this.trackExpirationDate = false,
    this.notifications = const [],
  });

  final ComplianceExpirationMode expirationMode;
  final int? renewalPeriodValue;
  final ComplianceRenewalPeriodUnit renewalPeriodUnit;
  final bool requireDocumentUpload;
  final bool requireApproval;
  final bool trackExpirationDate;
  final List<ComplianceNotificationRule> notifications;

  factory ComplianceRuleSettings.fromMap(Object? value) {
    if (value is! Map) return const ComplianceRuleSettings();
    final map = Map<String, dynamic>.from(value);
    final rawRenewal = map['renewal_period_value'];
    final rawNotifications = map['notifications'];

    return ComplianceRuleSettings(
      expirationMode: ComplianceExpirationMode.fromValue(
        map['expiration_mode'],
      ),
      renewalPeriodValue: rawRenewal == null
          ? null
          : rawRenewal is num
          ? rawRenewal.toInt()
          : int.tryParse('$rawRenewal'),
      renewalPeriodUnit: ComplianceRenewalPeriodUnit.fromValue(
        map['renewal_period_unit'],
      ),
      requireDocumentUpload: map['require_document_upload'] == true,
      requireApproval: map['require_approval'] == true,
      trackExpirationDate: map['track_expiration_date'] == true,
      notifications: rawNotifications is List
          ? rawNotifications
                .whereType<Map>()
                .map(
                  (item) => ComplianceNotificationRule.fromMap(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList(growable: false)
          : const [],
    );
  }

  Map<String, dynamic> toMap() => {
    'expiration_mode': expirationMode.value,
    'renewal_period_value': renewalPeriodValue,
    'renewal_period_unit': renewalPeriodUnit.value,
    'require_document_upload': requireDocumentUpload,
    'require_approval': requireApproval,
    'track_expiration_date': trackExpirationDate,
    'notifications': notifications.map((item) => item.toMap()).toList(),
  };
}
