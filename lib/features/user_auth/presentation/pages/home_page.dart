import 'package:flutter/material.dart';
import 'user_profile_page.dart'; // Make sure to import the UserProfilePage

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hotel Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement sign out functionality
              Navigator.pushNamed(context,
                  '/login'); // Modify as needed for actual sign-out logic
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          padding: EdgeInsets.all(4.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: <Widget>[
            _buildCard('Book a Room', Icons.hotel, context, () {
              // Implement action for Book a Room
            }),
            _buildCard('View Reservations', Icons.calendar_today, context, () {
              // Implement action for View Reservations
            }),
            _buildCard('Room Service', Icons.room_service, context, () {
              // Implement action for Room Service
            }),
            _buildCard('Profile', Icons.person, context, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserProfilePage()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      String title, IconData icon, BuildContext context, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 40.0),
            Text(title, style: TextStyle(fontSize: 16.0)),
          ],
        ),
      ),
    );
  }
}
