import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hotel/features/user_auth/presentation/pages/RoomsPage.dart';

import 'ReservationsPage.dart';

class Hotel {
  final String name;
  final String imageUrl;

  Hotel({required this.name, required this.imageUrl});
}

class HotelsPage extends StatefulWidget {
  @override
  _HotelsPageState createState() => _HotelsPageState();
}

class _HotelsPageState extends State<HotelsPage> {
  List<Hotel> hotels = [
    Hotel(
        name: 'The St. Regis Kuala Lumpur',
        imageUrl: 'lib/features/pics/hotel1.png'),
    Hotel(
        name: 'Shangri-La Hotel, Kuala Lumpur',
        imageUrl: 'lib/features/pics/hotel2.png'),
    Hotel(
        name: 'Mandarin Oriental, Kuala Lumpur',
        imageUrl: 'lib/features/pics/hotel3.png'),
    Hotel(
        name: 'The Ritz-Carlton, Kuala Lumpur',
        imageUrl: 'lib/features/pics/hotel4.png'),
    Hotel(
        name: 'Four Seasons Hotel Kuala Lumpur',
        imageUrl: 'lib/features/pics/hotel5.png'),
    // ...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotels'),
      ),
      body: ListView.builder(
        itemCount: hotels.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 300,
            child: Card(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child:
                        Image.asset(hotels[index].imageUrl, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      hotels[index].name,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RoomsPage()),
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
    );
  }
}
