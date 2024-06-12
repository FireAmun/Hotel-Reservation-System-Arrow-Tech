import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hotel/features/user_auth/presentation/pages/RoomsPage.dart';

import 'ReservationsPage.dart';

class Hotel {
  final String name;
  final String imageUrl;
  final String location;

  Hotel({required this.name, required this.imageUrl, required this.location});
}

class HotelsPage extends StatefulWidget {
  @override
  _HotelsPageState createState() => _HotelsPageState();
}

class _HotelsPageState extends State<HotelsPage> {
  List<Hotel> hotels = [
    Hotel(
        name: 'The St. Regis Kuala Lumpur',
        imageUrl: 'lib/features/pics/hotel1.png',
        location: 'Kuala Lumpur'),
    Hotel(
        name: 'Shangri-La Hotel, Kuala Lumpur',
        imageUrl: 'lib/features/pics/hotel2.png',
        location: 'Kuala Lumpur'),
    Hotel(
        name: 'Mandarin Oriental, Kuala Lumpur',
        imageUrl: 'lib/features/pics/hotel3.png',
        location: 'Kuala Lumpur'),
    Hotel(
        name: 'The Ritz-Carlton, Kuala Lumpur',
        imageUrl: 'lib/features/pics/hotel4.png',
        location: 'Kuala Lumpur'),
    Hotel(
        name: 'Four Seasons Hotel Kuala Lumpur',
        imageUrl: 'lib/features/pics/hotel5.png',
        location: 'Kuala Lumpur'),
    Hotel(
        name: 'The Datai Langkawi',
        imageUrl: 'lib/features/pics/hotel6.jpg',
        location: 'Langkawi'),
    Hotel(
        name: 'The Andaman, a Luxury Collection Resort, Langkawi',
        imageUrl: 'lib/features/pics/hotel7.jpg',
        location: 'Langkawi'),
    Hotel(
        name: 'Shangri-La’s Rasa Sayang Resort & Spa',
        imageUrl: 'lib/features/pics/hotel8.jpg',
        location: 'Penang'),
    Hotel(
        name: 'Eastern & Oriental Hotel',
        imageUrl: 'lib/features/pics/hotel9.jpg',
        location: 'Penang'),
    Hotel(
        name: 'The Danna Langkawi',
        imageUrl: 'lib/features/pics/hotel10.jpg',
        location: 'Langkawi'),
    // Add more hotels here...
  ];

  List<Hotel> filteredHotels = [];
  String searchQuery = '';
  String selectedLocation = 'All';

  @override
  void initState() {
    super.initState();
    filteredHotels = hotels;
  }

  void filterHotels() {
    setState(() {
      filteredHotels = hotels.where((hotel) {
        return (selectedLocation == 'All' ||
                hotel.location == selectedLocation) &&
            hotel.name.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotels'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  filterHotels();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedLocation,
              items: <String>['All', 'Kuala Lumpur', 'Langkawi', 'Penang']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLocation = newValue!;
                  filterHotels();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredHotels.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 300,
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Image.asset(filteredHotels[index].imageUrl,
                              fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            filteredHotels[index].name,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            filteredHotels[index].location,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RoomsPage()),
                              );
                            },
                            child: Text(
                              'Make a Reservation',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
