import 'dart:io';

import 'package:flutter/material.dart';
import 'package:place_list_app/helpers/db_helper.dart';
import 'package:place_list_app/helpers/location_helper.dart';
import 'package:place_list_app/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> addPlace(
    String title,
    File image,
    PlaceLocation location,
  ) async {
    // print(items);
    final address = await LocationHelper.getPLaceAddress(
        location.latitude, location.longitude);
    final updatedLocation = PlaceLocation(
        latitude: location.latitude,
        longitude: location.longitude,
        address: address);
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      location: updatedLocation,
      title: title,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address.toString(),
    });
    // print(items);
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    // print(dataList);

    _items = dataList
        .map(
          (item) => Place(
            title: item['title'],
            id: item['id'],
            image: File(item['image']),
            location: PlaceLocation(
              latitude: item['loc_let'],
              longitude: item['loc_lng'],
              address: item['address'],
            ),
          ),
        )
        .toList();
    notifyListeners();
  }

  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> deletePLace(String id) async {
    final db = await DBHelper.database();
    db.rawDelete('DELETE FROM user_places WHERE id = ?', [id]);
    notifyListeners();
  }
}
