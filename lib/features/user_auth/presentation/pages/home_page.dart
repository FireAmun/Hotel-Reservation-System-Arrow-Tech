import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
              Fluttertoast.showToast(msg: "Successfully signed out");
              Navigator.pushNamed(context, '/login');
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
            _buildCard('Book a Room', Icons.hotel, context),
            _buildCard('View Reservations', Icons.calendar_today, context),
            _buildCard('Room Service', Icons.room_service, context),
            _buildCard('Profile', Icons.person, context),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // Implement onTap functionality based on the title or pass parameters
          Fluttertoast.showToast(msg: "$title clicked");
        },
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
