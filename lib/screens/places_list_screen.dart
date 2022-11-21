import 'package:flutter/material.dart';
import 'package:place_list_app/providers/great_places.dart';
import 'package:place_list_app/screens/add_place_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const CircularProgressIndicator()
            : Consumer<GreatPlaces>(
                child: const Center(
                  child: Text('Got no places yet, start adding some!'),
                ),
                builder: (context, greatPlaces, child) => greatPlaces
                        .items.isEmpty
                    ? child!
                    : ListView.builder(
                        itemCount: greatPlaces.items.length,
                        itemBuilder: (BuildContext context, int index) => Card(
                          elevation: 6,
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundImage:
                                    FileImage(greatPlaces.items[index].image),
                              ),
                            ),
                            title: Text(greatPlaces.items[index].title),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              onPressed: () {
                                Provider.of<GreatPlaces>(context, listen: false)
                                    .deletePLace(greatPlaces.items[index].id);
                              },
                            ),
                            onTap: () {
                              // go to detail page
                            },
                          ),
                        ),
                      ),
              ),
      ),
    );
  }
}
