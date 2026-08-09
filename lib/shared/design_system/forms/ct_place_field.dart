import 'dart:async';

import 'package:flutter/material.dart';

import 'package:charitask/services/google_places/ct_google_places_service.dart';
import 'package:charitask/shared/design_system/forms/ct_place_result_card.dart';
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

  void _handleSearch() {
    // Do not search when we are setting the field after
    // the user has selected a Google Places result.
    if (_suppressSearch) return;

    final query = widget.controller.text.trim();

    _debounce?.cancel();

    if (query.length < 3) {
      setState(() {
        _results = [];
        _loading = false;
      });

      _removeOverlay();

      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () => _search(query));
  }

  Future<void> _search(String query) async {
    if (!mounted) return;

    setState(() {
      _loading = true;
    });

    try {
      final predictions = await _placesService.autocomplete(query);

      if (!mounted) return;

      setState(() {
        _results = predictions.map(_predictionToPlace).toList();
        _loading = false;
      });

      if (_results.isEmpty) {
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

  Future<void> _selectPlace(CTPlace place) async {
    if (place.placeId == null) return;

    // Stop any pending search.
    _debounce?.cancel();

    // Remove the suggestions immediately.
    _removeOverlay();

    setState(() {
      _results = [];
      _loading = true;
    });

    try {
      final details = await _placesService.getPlaceDetails(place.placeId!);

      final selectedPlace = CTPlace(
        primary: place.primary,
        secondary: place.secondary,
        placeId: details.placeId,
        latitude: details.latitude,
        longitude: details.longitude,
      );

      // Prevent changing the controller text from triggering
      // another Google Places search.
      _suppressSearch = true;

      widget.controller.text = details.formattedAddress;

      widget.controller.selection = TextSelection.collapsed(
        offset: widget.controller.text.length,
      );

      _suppressSearch = false;

      widget.onChanged?.call(selectedPlace);

      if (!mounted) return;

      setState(() {
        _results = [];
        _loading = false;
      });

      // Make absolutely sure the overlay is gone.
      _removeOverlay();

      FocusScope.of(context).unfocus();
    } catch (error) {
      debugPrint('CTLocationField place details error: $error');

      _suppressSearch = false;

      if (!mounted) return;

      setState(() {
        _results = [];
        _loading = false;
      });

      _removeOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final renderBox = this.context.findRenderObject() as RenderBox?;

        if (renderBox == null) {
          return const SizedBox.shrink();
        }

        final width = renderBox.size.width;
        final fieldHeight = renderBox.size.height;

        return CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, fieldHeight + 8),
          child: Material(
            color: Colors.transparent,
            child: SizedBox(width: width, child: _buildResultsDropdown()),
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

  Widget _buildResultsDropdown() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 240),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CTJourneyColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: _results.length,
          itemBuilder: (context, index) {
            final place = _results[index];

            return CTPlaceResultCard(
              place: place,
              onTap: () => _selectPlace(place),
            );
          },
        ),
      ),
    );
  }

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
