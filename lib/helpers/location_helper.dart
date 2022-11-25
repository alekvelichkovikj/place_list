import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final apiKey = FlutterConfig.get('GOOGLE_API_KEY');

class LocationHelper {
  static String generateLocationPreviewImage({
    double latitude,
    double longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16&size=800x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$apiKey';
  }

  static Future<String> getPLaceAddress(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey');
    final response = await http.get(url);
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
