import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:place_list_app/helpers/location_helper.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  var _previewImageUrl = '';

  Future<void> _getCurrentLocation() async {
    final locData = await Location().getLocation();
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: locData.latitude,
      longitude: locData.longitude,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
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
              onPressed: () {},
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
