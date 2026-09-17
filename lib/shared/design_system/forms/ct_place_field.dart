import 'dart:async';

import 'package:flutter/material.dart';

import 'package:charitask/services/google_places/ct_google_places_service.dart';
import 'package:charitask/shared/models/ct_place.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_constants.dart';

class CTLocationField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<CTPlace>? onChanged;

  const CTLocationField({super.key, required this.controller, this.onChanged});

  @override
  State<CTLocationField> createState() => _CTLocationFieldState();
}

class _CTLocationFieldState extends State<CTLocationField> {
  final CTGooglePlacesService _placesService = CTGooglePlacesService();
  final LayerLink _layerLink = LayerLink();

  Timer? _debounce;
  OverlayEntry? _overlayEntry;

  List<CTPlace> _results = [];

  bool _loading = false;
  bool _suppressSearch = false;
  bool _selectingPlace = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_handleSearch);
    _placesService.startSession();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_handleSearch);
    _removeOverlay();
    _placesService.endSession();
    super.dispose();
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void _handleSearch() {
    if (_suppressSearch || _selectingPlace) return;

    final query = widget.controller.text.trim();

    _debounce?.cancel();

    if (query.length < 3) {
      if (mounted) {
        setState(() {
          _results = [];
          _loading = false;
        });
      }

      _removeOverlay();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () => _search(query));
  }

  Future<void> _search(String query) async {
    if (!mounted || _selectingPlace) return;

    setState(() {
      _loading = true;
    });

    try {
      final predictions = await _placesService.autocomplete(query);

      if (!mounted || _selectingPlace) return;

      final results = predictions.map(_predictionToPlace).toList();

      setState(() {
        _results = results;
        _loading = false;
      });

      if (results.isEmpty) {
        _removeOverlay();
      } else {
        _showOverlay();
      }
    } catch (error) {
      debugPrint('CTLocationField Google Places error: $error');

      if (!mounted) return;

      setState(() {
        _results = [];
        _loading = false;
      });

      _removeOverlay();
    }
  }

  CTPlace _predictionToPlace(CTGooglePlacePrediction prediction) {
    final parts = prediction.description.split(',');

    final primary = parts.isNotEmpty
        ? parts.first.trim()
        : prediction.description;

    final secondary = parts.length > 1 ? parts.skip(1).join(',').trim() : '';

    return CTPlace(
      primary: primary,
      secondary: secondary,
      placeId: prediction.placeId,
    );
  }

  // ============================================================
  // SELECT GOOGLE PLACE
  // ============================================================

  Future<void> _selectPlace(CTPlace place) async {
    if (_selectingPlace) return;

    final placeId = place.placeId;

    if (placeId == null || placeId.isEmpty) {
      debugPrint('CTLocationField: selected place has no placeId.');
      return;
    }

    debugPrint(
      'CTLocationField: selecting place '
      '${place.primary} (${placeId})',
    );

    _selectingPlace = true;
    _debounce?.cancel();

    // Close suggestions immediately.
    _removeOverlay();

    if (mounted) {
      setState(() {
        _results = [];
        _loading = true;
      });
    }

    try {
      final details = await _placesService.getPlaceDetails(placeId);

      debugPrint(
        'CTLocationField: place details received: '
        '${details.formattedAddress}',
      );

      final selectedPlace = CTPlace(
        primary: place.primary,
        secondary: place.secondary,
        placeId: details.placeId,
        latitude: details.latitude,
        longitude: details.longitude,
        streetAddress: details.streetAddress,
        city: details.city,
        state: details.state,
        postalCode: details.postalCode,
        country: details.country,
      );

      // Prevent controller update from triggering another search.
      _suppressSearch = true;

      widget.controller.value = TextEditingValue(
        text: details.formattedAddress,
        selection: TextSelection.collapsed(
          offset: details.formattedAddress.length,
        ),
      );

      _suppressSearch = false;

      // Send structured address data back to AddLocationPage.
      widget.onChanged?.call(selectedPlace);

      debugPrint(
        'CTLocationField: structured address '
        'street="${selectedPlace.streetAddress}", '
        'city="${selectedPlace.city}", '
        'state="${selectedPlace.state}", '
        'zip="${selectedPlace.postalCode}"',
      );

      if (!mounted) return;

      setState(() {
        _results = [];
        _loading = false;
      });

      _removeOverlay();

      // Remove focus after selection.
      FocusManager.instance.primaryFocus?.unfocus();
    } catch (error, stackTrace) {
      debugPrint('CTLocationField place details error: $error');
      debugPrint('$stackTrace');

      _suppressSearch = false;

      if (!mounted) return;

      setState(() {
        _results = [];
        _loading = false;
      });

      _removeOverlay();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'We could not load the details for that address. '
            'Please try selecting it again.',
          ),
        ),
      );
    } finally {
      _suppressSearch = false;
      _selectingPlace = false;
    }
  }

  // ============================================================
  // OVERLAY
  // ============================================================

  void _showOverlay() {
    if (!mounted || _results.isEmpty) return;

    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
      return;
    }

    _overlayEntry = OverlayEntry(
      opaque: false,
      builder: (context) {
        final renderObject = this.context.findRenderObject();

        if (renderObject is! RenderBox) {
          return const SizedBox.shrink();
        }

        final width = renderObject.size.width;
        final height = renderObject.size.height;

        return Positioned.fill(
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, height + 8),
            child: Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: Colors.transparent,
                child: SizedBox(width: width, child: _buildResultsDropdown()),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // ============================================================
  // DROPDOWN
  // ============================================================

  Widget _buildResultsDropdown() {
    return Material(
      color: Colors.white,
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 260),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: _results.length,
          separatorBuilder: (context, index) {
            return const Divider(height: 1, indent: 56, endIndent: 16);
          },
          itemBuilder: (context, index) {
            final place = _results[index];

            return InkWell(
              onTap: () {
                debugPrint(
                  'CTLocationField: suggestion tapped: '
                  '${place.primary}',
                );

                _selectPlace(place);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: CTJourneyColors.purple.withOpacity(.10),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on_outlined,
                        color: CTJourneyColors.purple,
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.primary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: CTJourneyColors.title,
                            ),
                          ),
                          if (place.secondary.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              place.secondary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: CTJourneyColors.subtitle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // FIELD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: widget.controller,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: CTJourneyColors.title,
        ),
        decoration: InputDecoration(
          hintText: 'City, State or ZIP Code',
          hintStyle: const TextStyle(
            color: CTJourneyColors.subtitle,
            fontSize: 17,
          ),
          prefixIcon: const Icon(
            Icons.location_on_outlined,
            color: CTJourneyColors.subtitle,
            size: 22,
          ),
          suffixIcon: _loading
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: CTJourneyColors.purple,
                    ),
                  ),
                )
              : null,
          filled: true,
          fillColor: CTJourneyColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(CTJourneySizes.textFieldRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(CTJourneySizes.textFieldRadius),
            borderSide: const BorderSide(
              color: CTJourneyColors.border,
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(CTJourneySizes.textFieldRadius),
            borderSide: const BorderSide(
              color: CTJourneyColors.purple,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
