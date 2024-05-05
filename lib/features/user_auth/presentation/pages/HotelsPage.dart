import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hotel/features/user_auth/presentation/pages/RoomsPage.dart';

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
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 4, // Add elevation for shadow effect
              child: ListTile(
                leading: Hero(
                  tag: hotels[index].imageUrl,
                  child: CachedNetworkImage(
                    imageUrl: hotels[index].imageUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                title: Text(hotels[index].name),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    textStyle: TextStyle(color: Colors.white),
                  ),
                  child: Text('Book a Room'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RoomsPage()));
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
