import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:place_list_app/helpers/location_helper.dart';
import 'package:place_list_app/screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function selectPlace;

  const LocationInput({Key key, this.selectPlace}) : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  var _previewImageUrl = '';

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreview(locData.latitude, locData.longitude);
      widget.selectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      // Do something...
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final LatLng selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: ((context) => const MapScreen(
              isSelecting: true,
            )),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    widget.selectPlace(selectedLocation.latitude, selectedLocation.longitude);
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          height: 178,
          width: double.infinity,
          child: _previewImageUrl.isEmpty
              ?
              // Image.asset(
              //     'lib/assets/images/location_placeholder.png',
              //     fit: BoxFit.cover,
              //     // height: 120,
              //   )
              const Center(
                  child: Text(
                    'No location chosen...',
                    textAlign: TextAlign.center,
                  ),
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(
                Icons.location_on,
              ),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              label: const Text('Current location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(
                Icons.map,
              ),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              label: const Text('Select on map'),
            ),
          ],
        )
      ],
    );
  }
}
