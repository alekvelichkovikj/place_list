import 'package:flutter_config/flutter_config.dart';

final apiKey = FlutterConfig.get('GOOGLE_API_KEY');

class LocationHelper {
  static String generateLocationPreviewImage({
    double? latitude,
    double? longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=800x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$apiKey';
  }
}
