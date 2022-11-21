import 'dart:io';

import 'package:flutter/material.dart';
import 'package:place_list_app/helpers/db_helper.dart';
import 'package:place_list_app/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> addPlace(String title, File image) async {
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      // location: PlaceLocation(latitude: 0.0, longitude: 0.0),
      title: title,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');

    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            image: File(item['image']),
            // location: item['location'],
            title: item['title'],
          ),
        )
        .toList();
    notifyListeners();
  }

  Future<void> deletePLace(String id) async {
    final db = await DBHelper.database();
    db.rawDelete('DELETE FROM user_places WHERE id = ?', [id]);
    notifyListeners();
  }
}
