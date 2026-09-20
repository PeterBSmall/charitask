import 'package:flutter/material.dart';
import 'package:charitask/shared/validation/ct_email_validator.dart';
import 'package:charitask/shared/validation/ct_phone_validator.dart';

import 'package:charitask/modules/foundation/domain/models/location.dart';
import 'package:charitask/modules/locations/data/services/location_service.dart';
import 'package:charitask/shared/design_system/design_system.dart';
import 'package:charitask/shared/design_system/forms/ct_place_field.dart';
import 'package:charitask/shared/models/ct_place.dart';

class EditLocationPage extends StatefulWidget {
  final String organizationId;
  final Location location;

  const EditLocationPage({
    super.key,
    required this.organizationId,
    required this.location,
  });

  @override
  State<EditLocationPage> createState() => _EditLocationPageState();
}

class _EditLocationPageState extends State<EditLocationPage> {
  final _service = LocationService();
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _description;

  late final TextEditingController _address;
  late final TextEditingController _city;
  late final TextEditingController _state;
  late final TextEditingController _zip;

  late final TextEditingController _contactName;
  late final TextEditingController _contactRole;
  late final TextEditingController _phone;
  late final TextEditingController _phoneExtension;
  late final TextEditingController _email;
  late final TextEditingController _contactPhone;
  late final TextEditingController _contactPhoneExtension;

  static const _types = [
    'Office',
    'Program Site',
    'Community Site',
    'Event Venue',
    'Retail',
    'Warehouse',
    'Service Area',
    'Virtual',
    'Other',
  ];

  late String? _type;

  List<Map<String, dynamic>> _tags = [];
  final Set<String> _selectedTags = {};

  bool _loadingTags = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();

    final location = widget.location;

    _name = TextEditingController(text: location.name);
    _description = TextEditingController(text: location.description ?? '');

    _address = TextEditingController(text: location.addressLine1 ?? '');
    _city = TextEditingController(text: location.city ?? '');
    _state = TextEditingController(text: location.state ?? '');
    _zip = TextEditingController(text: location.postalCode ?? '');

    _contactName = TextEditingController(text: location.contactName ?? '');
    _contactRole = TextEditingController(text: location.contactRole ?? '');
    _phone = TextEditingController(text: location.phone ?? '');
    _phoneExtension = TextEditingController(
      text: location.phoneExtension ?? '',
    );
    _email = TextEditingController(text: location.email ?? '');
    _contactPhone = TextEditingController(text: location.contactPhone ?? '');
    _contactPhoneExtension = TextEditingController(
      text: location.contactPhoneExtension ?? '',
    );

    _type = location.locationType;

    _loadTags();
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();

    _address.dispose();
    _city.dispose();
    _state.dispose();
    _zip.dispose();

    _contactName.dispose();
    _contactRole.dispose();
    _phone.dispose();
    _phoneExtension.dispose();
    _email.dispose();
    _contactPhone.dispose();
    _contactPhoneExtension.dispose();

    super.dispose();
  }

  Future<void> _loadTags() async {
    try {
      final tags = await _service.getLocationCategoryTags(
        organizationId: widget.organizationId,
      );

      final tagIds = await _service.getLocationTagIds(
        locationId: widget.location.id,
        organizationId: widget.organizationId,
      );

      if (!mounted) return;

      setState(() {
        _tags = tags;
        _selectedTags
          ..clear()
          ..addAll(tagIds);
        _loadingTags = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _loadingTags = false;
      });
    }
  }

  void _handlePlaceSelected(CTPlace place) {
    setState(() {
      if (place.streetAddress != null &&
          place.streetAddress!.trim().isNotEmpty) {
        _address.text = place.streetAddress!.trim();
      }

      if (place.city != null && place.city!.trim().isNotEmpty) {
        _city.text = place.city!.trim();
      }

      if (place.state != null && place.state!.trim().isNotEmpty) {
        _state.text = place.state!.trim();
      }

      if (place.postalCode != null && place.postalCode!.trim().isNotEmpty) {
        _zip.text = place.postalCode!.trim();
      }

      _error = null;
    });
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_type == null) {
      setState(() {
        _error = 'Please select a location type.';
      });
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await _service.updateLocation(
        locationId: widget.location.id,
        organizationId: widget.organizationId,
        changes: {
          'name': _name.text.trim(),
          'location_type': _type,
          'description': _value(_description.text),
          'address_line_1': _value(_address.text),
          'city': _value(_city.text),
          'state': _value(_state.text),
          'postal_code': _value(_zip.text),
          'contact_name': _value(_contactName.text),
          'contact_role': _value(_contactRole.text),
          'phone': _value(_phone.text),
          'phone_extension': _value(_phoneExtension.text),
          'email': _value(_email.text),
          'contact_phone': _value(_contactPhone.text),
          'contact_phone_extension': _value(_contactPhoneExtension.text),
        },
        tagIds: _selectedTags.toList(),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _saving = false;
      });
    }
  }

  String? _value(String value) {
    final result = value.trim();
    return result.isEmpty ? null : result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _saving ? null : () => Navigator.pop(context),
        ),
        title: const Text('Edit Location'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Text('Edit location', style: AppTypography.display),
                const SizedBox(height: 6),
                Text(
                  'Update the information for this location.',
                  style: AppTypography.body,
                ),

                const SizedBox(height: AppSpacing.lg),

                _section('Basic Information', Icons.location_on_outlined, [
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    inputFormatters: const [CTPhoneInputFormatter()],
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      return CTPhoneValidator.validate(value, required: false);
                    },
                  ),

                  const SizedBox(height: AppSpacing.md),

                  DropdownButtonFormField<String>(
                    initialValue: _types.contains(_type) ? _type : null,
                    decoration: const InputDecoration(
                      labelText: 'Location Type',
                      border: OutlineInputBorder(),
                    ),
                    items: _types
                        .map(
                          (type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          ),
                        )
                        .toList(),
                    onChanged: _saving
                        ? null
                        : (value) {
                            setState(() {
                              _type = value;
                              _error = null;
                            });
                          },
                  ),

                  const SizedBox(height: AppSpacing.md),

                  TextFormField(
                    controller: _description,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Optional',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ]),

                const SizedBox(height: AppSpacing.lg),

                _section('Location Tags', Icons.local_offer_outlined, [
                  Text(
                    'Select any categories that apply.',
                    style: AppTypography.body,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  if (_loadingTags)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_tags.isEmpty)
                    Text(
                      'No location tags are available.',
                      style: AppTypography.body,
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _tags.map((tag) {
                        final id = tag['id'] as String;
                        final name = tag['name'] as String;
                        final selected = _selectedTags.contains(id);

                        return FilterChip(
                          label: Text(name),
                          selected: selected,
                          onSelected: _saving
                              ? null
                              : (value) {
                                  setState(() {
                                    if (value) {
                                      _selectedTags.add(id);
                                    } else {
                                      _selectedTags.remove(id);
                                    }
                                  });
                                },
                        );
                      }).toList(),
                    ),
                ]),

                const SizedBox(height: AppSpacing.lg),

                _section('Address', Icons.home_work_outlined, [
                  Text(
                    'Start typing an address to search Google Places.',
                    style: AppTypography.body,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  CTLocationField(
                    controller: _address,
                    onChanged: _handlePlaceSelected,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 600) {
                        return Column(
                          children: [
                            TextFormField(
                              controller: _city,
                              decoration: const InputDecoration(
                                labelText: 'City',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextFormField(
                              controller: _state,
                              decoration: const InputDecoration(
                                labelText: 'State',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextFormField(
                              controller: _zip,
                              decoration: const InputDecoration(
                                labelText: 'ZIP',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _city,
                              decoration: const InputDecoration(
                                labelText: 'City',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: TextFormField(
                              controller: _state,
                              decoration: const InputDecoration(
                                labelText: 'State',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: TextFormField(
                              controller: _zip,
                              decoration: const InputDecoration(
                                labelText: 'ZIP',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ]),

                const SizedBox(height: AppSpacing.lg),

                _section('Location Information', Icons.phone_outlined, [
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    inputFormatters: const [CTPhoneInputFormatter()],
                    decoration: const InputDecoration(
                      labelText: 'Location Phone',
                      hintText: 'Optional',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      return CTPhoneValidator.validate(value, required: false);
                    },
                  ),

                  const SizedBox(height: AppSpacing.md),

                  TextFormField(
                    controller: _phoneExtension,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Location Phone Extension',
                      hintText: 'Optional',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Location Email',
                      hintText: 'Optional',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      return CTEmailValidator.validate(value, required: false);
                    },
                  ),
                ]),

                const SizedBox(height: AppSpacing.lg),

                _section('Contact Information', Icons.contact_phone_outlined, [
                  TextFormField(
                    controller: _contactName,
                    decoration: const InputDecoration(
                      labelText: 'Contact Name',
                      hintText: 'Optional',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  TextFormField(
                    controller: _contactRole,
                    decoration: const InputDecoration(
                      labelText: 'Contact Role / Relationship',
                      hintText: 'e.g. Store Manager',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  TextFormField(
                    controller: _contactPhone,
                    keyboardType: TextInputType.phone,
                    inputFormatters: const [CTPhoneInputFormatter()],
                    decoration: const InputDecoration(
                      labelText: 'Contact Phone',
                      hintText: 'Optional',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      return CTPhoneValidator.validate(value, required: false);
                    },
                  ),

                  const SizedBox(height: AppSpacing.md),

                  TextFormField(
                    controller: _contactPhoneExtension,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Contact Phone Extension',
                      hintText: 'Optional',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ]),

                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE8E8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _error!,
                      style: AppTypography.body.copyWith(
                        color: const Color(0xFFB3261E),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: AppSpacing.lg),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: _saving ? null : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    FilledButton.icon(
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check),
                      label: Text(_saving ? 'Saving...' : 'Save Location'),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String title, IconData icon, List<Widget> children) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF5B4BC4)),
                const SizedBox(width: 10),
                Text(title, style: AppTypography.title),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            ...children,
          ],
        ),
      ),
    );
  }
}
