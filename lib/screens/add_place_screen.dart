import 'dart:io';

import 'package:flutter/material.dart';
import 'package:place_list_app/providers/great_places.dart';
import 'package:place_list_app/widgets/image_input.dart';
import 'package:place_list_app/widgets/location_input.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _savePLace() {
    if (_titleController.text.isEmpty || _pickedImage == null) {
      return;
    }
    Provider.of<GreatPlaces>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ImageInput(_selectImage),
                    const SizedBox(
                      height: 10,
                    ),
                    const LocationInput(),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: Platform.isIOS
                ? const EdgeInsets.only(bottom: 10)
                : const EdgeInsets.all(0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.black87,
                elevation: 0,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: _savePLace,
              icon: const Icon(Icons.add),
              label: const Text('Add place'),
            ),
          ),
        ],
      ),
    );
  }
}
