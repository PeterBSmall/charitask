import 'package:flutter/material.dart';

import 'package:charitask/modules/locations/data/services/location_service.dart';
import 'package:charitask/shared/design_system/design_system.dart';
import 'package:charitask/shared/widgets/operating_hours/ct_operating_hours_day.dart';
import 'package:charitask/shared/models/ct_place.dart';
import 'package:charitask/modules/locations/widgets/add_location_details_card.dart';
import 'package:charitask/modules/locations/widgets/add_location_address_card.dart';
import 'package:charitask/modules/locations/widgets/add_location_classification_card.dart';
import 'package:charitask/modules/locations/widgets/add_location_contact_card.dart';
import 'package:charitask/modules/locations/widgets/add_location_preview.dart';
import 'package:charitask/modules/locations/widgets/add_location_hero.dart';
import 'package:charitask/modules/locations/data/services/location_operating_hours_service.dart';
import 'package:charitask/shared/widgets/operating_hours/ct_operating_hours_card.dart';

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
  final _operatingHoursService = LocationOperatingHoursService();
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
    'Headquarters',
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
  double? _latitude;
  double? _longitude;

  List<Map<String, dynamic>> _tags = [];
  final Set<String> _selectedTags = {};
  final List<CTOperatingHoursDay> _operatingHours = [];

  bool _loadingTags = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTags();
    _name.addListener(_refreshPreview);
    _description.addListener(_refreshPreview);
    _address.addListener(_refreshPreview);
    _city.addListener(_refreshPreview);
    _state.addListener(_refreshPreview);
    _zip.addListener(_refreshPreview);
    _phone.addListener(_refreshPreview);
    _email.addListener(_refreshPreview);
    _contactName.addListener(_refreshPreview);
    _contactRole.addListener(_refreshPreview);
    _contactPhone.addListener(_refreshPreview);
  }

  @override
  void dispose() {
    _name.removeListener(_refreshPreview);
    _description.removeListener(_refreshPreview);
    _address.removeListener(_refreshPreview);
    _city.removeListener(_refreshPreview);
    _state.removeListener(_refreshPreview);
    _zip.removeListener(_refreshPreview);
    _phone.removeListener(_refreshPreview);
    _email.removeListener(_refreshPreview);
    _contactName.removeListener(_refreshPreview);
    _contactRole.removeListener(_refreshPreview);
    _contactPhone.removeListener(_refreshPreview);

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
      _address.text = place.streetAddress ?? place.primary;
      _city.text = place.city ?? '';
      _state.text = place.state ?? '';
      _zip.text = place.postalCode ?? '';

      _latitude = place.latitude;
      _longitude = place.longitude;

      _error = null;
    });
  }

  String? _validateOperatingHours() {
    for (final day in _operatingHours) {
      if (!day.isOpen) {
        continue;
      }

      if (day.opensAt == null || day.closesAt == null) {
        return '${day.dayName} is marked Open, but both opening and closing times are required.';
      }

      final opensMinutes = day.opensAt!.hour * 60 + day.opensAt!.minute;
      final closesMinutes = day.closesAt!.hour * 60 + day.closesAt!.minute;

      if (closesMinutes <= opensMinutes) {
        return '${day.dayName} closing time must be later than opening time.';
      }
    }

    return null;
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
    final operatingHoursError = _validateOperatingHours();

    if (operatingHoursError != null) {
      setState(() {
        _error = operatingHoursError;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(operatingHoursError)));

      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final location = await _service.createLocation(
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
      for (final day in _operatingHours) {
        await _operatingHoursService.saveDay(
          organizationId: widget.organizationId,
          locationId: location.id,
          dayOfWeek: day.dayOfWeek,
          isClosed: !day.isOpen,
          opensAt: _formatTimeOfDay(day.opensAt),
          closesAt: _formatTimeOfDay(day.closesAt),
        );
      }
      if (!mounted) return;

      widget.onCancel?.call();
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

  void _handleOperatingHoursChanged(CTOperatingHoursDay updatedDay) {
    setState(() {
      final index = _operatingHours.indexWhere(
        (day) => day.dayOfWeek == updatedDay.dayOfWeek,
      );

      if (index == -1) {
        _operatingHours.add(updatedDay);
      } else {
        _operatingHours[index] = updatedDay;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text('Add Location'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AddLocationHero(),
            const SizedBox(height: 24),

            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 1100;

                final form = Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AddLocationDetailsCard(
                        nameController: _name,
                        descriptionController: _description,
                        locationType: _type,
                        locationTypes: _types,
                        isActive: _isActive,
                        onLocationTypeChanged: (value) {
                          setState(() {
                            _type = value;
                          });
                        },
                        onStatusChanged: (value) {
                          setState(() {
                            _isActive = value ?? true;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

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

                      const SizedBox(height: 16),

                      AddLocationAddressCard(
                        addressController: _address,
                        cityController: _city,
                        stateController: _state,
                        zipController: _zip,
                        onPlaceSelected: _handlePlaceSelected,
                      ),

                      const SizedBox(height: 16),

                      AddLocationContactCard(
                        phoneController: _phone,
                        phoneExtensionController: _phoneExtension,
                        emailController: _email,
                        contactNameController: _contactName,
                        contactRoleController: _contactRole,
                        contactPhoneController: _contactPhone,
                        contactPhoneExtensionController: _contactPhoneExtension,
                      ),
                      const SizedBox(height: 16),

                      CTOperatingHoursCard(
                        days: _operatingHours,
                        onDayChanged: _handleOperatingHoursChanged,
                      ),
                    ],
                  ),
                );

                final preview = _buildPreview();

                if (!isWide) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [form, const SizedBox(height: 24), preview],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: form),
                    const SizedBox(width: 24),
                    SizedBox(width: 400, child: preview),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(_saving ? 'Saving...' : 'Save Location'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B4BC4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _previewRefreshScheduled = false;

  void _refreshPreview() {
    if (!mounted || _previewRefreshScheduled) {
      return;
    }

    _previewRefreshScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _previewRefreshScheduled = false;

      if (mounted) {
        setState(() {});
      }
    });
  }

  Widget _buildPreview() {
    final tagNames = _tags
        .where((tag) => _selectedTags.contains(tag['id']?.toString()))
        .map((tag) => tag['name']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    return AddLocationPreview(
      name: _name.text.trim(),
      locationType: _type,
      isActive: _isActive,
      operatingHours: _operatingHours,
      selectedTags: tagNames,
      address: _address.text.trim(),
      city: _city.text.trim(),
      state: _state.text.trim(),
      postalCode: _zip.text.trim(),
      phone: _phone.text.trim(),
      email: _email.text.trim(),
      contactName: _contactName.text.trim(),
      contactRole: _contactRole.text.trim(),
      contactPhone: _contactPhone.text.trim(),
      latitude: _latitude,
      longitude: _longitude,
    );
  }

  String? _formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return null;

    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute:00';
  }
}
