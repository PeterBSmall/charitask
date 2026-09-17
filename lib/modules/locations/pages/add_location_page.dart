import 'package:flutter/material.dart';

import 'package:charitask/modules/locations/data/services/location_service.dart';
import 'package:charitask/shared/design_system/design_system.dart';
import 'package:charitask/shared/design_system/forms/ct_place_field.dart';
import 'package:charitask/shared/models/ct_place.dart';

class AddLocationPage extends StatefulWidget {
  final String organizationId;

  const AddLocationPage({super.key, required this.organizationId});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  final _service = LocationService();
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _description = TextEditingController();

  final _address = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _zip = TextEditingController();

  final _contactName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();

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

  String? _type;

  List<Map<String, dynamic>> _tags = [];
  final Set<String> _selectedTags = {};

  bool _loadingTags = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
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
    _phone.dispose();
    _email.dispose();

    super.dispose();
  }

  Future<void> _loadTags() async {
    try {
      final tags = await _service.getLocationCategoryTags(
        organizationId: widget.organizationId,
      );

      if (!mounted) return;

      setState(() {
        _tags = tags;
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

    if (!_formKey.currentState!.validate()) return;

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
      await _service.createLocation(
        organizationId: widget.organizationId,
        name: _name.text.trim(),
        slug: _slug(_name.text),
        locationType: _type,
        description: _value(_description.text),
        addressLine1: _value(_address.text),
        city: _value(_city.text),
        state: _value(_state.text),
        postalCode: _value(_zip.text),
        contactName: _value(_contactName.text),
        phone: _value(_phone.text),
        email: _value(_email.text),
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

  String _slug(String value) {
    final result = value
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');

    return result.isEmpty ? 'location' : result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text('Add Location'),
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
                Text('Create a location', style: AppTypography.display),
                const SizedBox(height: 6),
                Text(
                  'Add a place where your organization operates, serves, or gathers.',
                  style: AppTypography.body,
                ),

                const SizedBox(height: AppSpacing.lg),

                // ----------------------------------------------------------
                // BASIC INFORMATION
                // ----------------------------------------------------------
                _section('Basic Information', Icons.location_on_outlined, [
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                      labelText: 'Location Name',
                      hintText: 'e.g. Falmouth ReStore',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Location name is required.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: AppSpacing.md),

                  DropdownButtonFormField<String>(
                    initialValue: _type,
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
                    onChanged: (value) {
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

                // ----------------------------------------------------------
                // LOCATION TAGS
                // ----------------------------------------------------------
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
                          onSelected: (value) {
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

                // ----------------------------------------------------------
                // ADDRESS
                // ----------------------------------------------------------
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

                            Row(
                              children: [
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

                // ----------------------------------------------------------
                // CONTACT
                // ----------------------------------------------------------
                _section('Contact', Icons.contact_phone_outlined, [
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
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      hintText: 'Optional',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Optional',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ]),

                // ----------------------------------------------------------
                // ERROR
                // ----------------------------------------------------------
                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    _error!,
                    style: const TextStyle(color: Color(0xFFB3261E)),
                  ),
                ],

                const SizedBox(height: AppSpacing.lg),

                // ----------------------------------------------------------
                // ACTIONS
                // ----------------------------------------------------------
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
