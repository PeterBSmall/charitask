import 'package:flutter/material.dart';

import 'package:charitask/modules/locations/data/services/location_service.dart';
import 'package:charitask/shared/design_system/design_system.dart';
import 'package:charitask/shared/design_system/forms/ct_place_field.dart';
import 'package:charitask/shared/models/ct_place.dart';
import 'package:charitask/modules/locations/widgets/add_location_details_card.dart';

import 'package:charitask/modules/locations/widgets/add_location_classification_card.dart';
import 'package:charitask/modules/locations/widgets/add_location_contact_card.dart';

class AddLocationPage extends StatefulWidget {
  final String organizationId;
  final VoidCallback? onCancel;

  const AddLocationPage({
    super.key,
    required this.organizationId,
    this.onCancel,
  });

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
  final _contactRole = TextEditingController();
  final _phone = TextEditingController();
  final _phoneExtension = TextEditingController();
  final _email = TextEditingController();
  final _contactPhone = TextEditingController();
  final _contactPhoneExtension = TextEditingController();

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
  bool _isActive = true;

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
        isActive: _isActive,
        slug: _slug(_name.text),
        locationType: _type,
        description: _value(_description.text),
        addressLine1: _value(_address.text),
        city: _value(_city.text),
        state: _value(_state.text),
        postalCode: _value(_zip.text),
        contactName: _value(_contactName.text),
        contactRole: _value(_contactRole.text),
        phone: _value(_phone.text),
        phoneExtension: _value(_phoneExtension.text),
        email: _value(_email.text),
        contactPhone: _value(_contactPhone.text),
        contactPhoneExtension: _value(_contactPhoneExtension.text),
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

  Widget _heroFeature(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 22, color: Colors.white),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTypography.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF047857), Color(0xFF10B981)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ------------------------------------------------------------
                  // LOCATION ICON
                  // ------------------------------------------------------------
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF047857),
                      size: 42,
                    ),
                  ),

                  const SizedBox(width: AppSpacing.lg),

                  // ------------------------------------------------------------
                  // HERO CONTENT
                  // ------------------------------------------------------------
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create a Location',
                          style: AppTypography.title.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Add a physical or service location where your organization '
                          'operates, serves, or gathers.',
                          style: AppTypography.body.copyWith(
                            color: Colors.white.withValues(alpha: 0.92),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // --------------------------------------------------------
                        // LOCATION TYPES
                        // --------------------------------------------------------
                        Wrap(
                          spacing: AppSpacing.lg,
                          runSpacing: AppSpacing.sm,
                          children: [
                            _heroFeature(Icons.business_outlined, 'Offices'),
                            _heroFeature(
                              Icons.groups_outlined,
                              'Program Sites',
                            ),
                            _heroFeature(
                              Icons.storefront_outlined,
                              'Retail Stores',
                            ),
                            _heroFeature(
                              Icons.favorite_border,
                              'Community Spaces',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: AppSpacing.xl),

                  // ------------------------------------------------------------
                  // MISSION MESSAGE
                  // ------------------------------------------------------------
                  Container(
                    width: 1,
                    height: 92,
                    color: Colors.white.withValues(alpha: 0.35),
                  ),

                  const SizedBox(width: AppSpacing.xl),

                  SizedBox(
                    width: 245,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Stronger Communities',
                                style: AppTypography.body.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Greater Impact',
                                style: AppTypography.body.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Brighter Tomorrows',
                                style: AppTypography.body.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: AppSpacing.md),

                        Icon(
                          Icons.eco_outlined,
                          size: 76,
                          color: Colors.white.withValues(alpha: 0.22),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ----------------------------------------------------------
            // BASIC INFORMATION
            // ----------------------------------------------------------
            AddLocationDetailsCard(
              nameController: _name,
              descriptionController: _description,
              locationType: _type,
              locationTypes: _types,
              onLocationTypeChanged: (value) {
                setState(() {
                  _type = value;
                  _error = null;
                });
              },
              isActive: _isActive,
              onStatusChanged: (value) {
                if (value == null) return;

                setState(() {
                  _isActive = value;
                });
              },
            ),

            const SizedBox(height: AppSpacing.lg),

            AddLocationClassificationCard(
              tags: _tags,
              selectedTagIds: _selectedTags,
              loading: _loadingTags,
              onTagSelected: (tagId) {
                setState(() {
                  if (_selectedTags.contains(tagId)) {
                    _selectedTags.remove(tagId);
                  } else {
                    _selectedTags.add(tagId);
                  }
                });
              },
            ),

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
            // CONTACT INFORMATION
            // ----------------------------------------------------------
            AddLocationContactCard(
              phoneController: _phone,
              phoneExtensionController: _phoneExtension,
              emailController: _email,
              contactNameController: _contactName,
              contactRoleController: _contactRole,
              contactPhoneController: _contactPhone,
              contactPhoneExtensionController: _contactPhoneExtension,
            ),

            const SizedBox(height: AppSpacing.lg),

            // ----------------------------------------------------------
            // ERROR
            // ----------------------------------------------------------
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(_error!, style: const TextStyle(color: Color(0xFFB3261E))),
            ],

            const SizedBox(height: AppSpacing.lg),

            // ----------------------------------------------------------
            // ACTIONS
            // ----------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: _saving ? null : widget.onCancel,
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
