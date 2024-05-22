import 'package:flutter/material.dart';
import 'package:hotel/features/user_auth/presentation/pages/HotelsPage.dart';
import 'package:hotel/features/user_auth/presentation/pages/MakeComplaintsPage.dart';
import 'package:hotel/features/user_auth/presentation/pages/OrderRoomServicePage.dart';
import 'ReservationsPage.dart';
import 'user_profile_page.dart'; // Make sure to import the UserProfilePage

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hotel Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Implement sign out functionality
              Navigator.pushNamed(context,
                  '/login'); // Modify as needed for actual sign-out logic
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          padding: const EdgeInsets.all(4.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: <Widget>[
            _buildCard('Book a Room', Icons.hotel, context, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HotelsPage()));
            }),
            _buildCard('View Reservations', Icons.calendar_today, context, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ReservationsPage()));
            }),
            _buildCard('Room Service', Icons.room_service, context, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderRoomServicePage()));
            }),
            _buildCard('Profile', Icons.person, context, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserProfilePage()));
            }),
            _buildCard('Complaints', Icons.report_problem, context, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MakeComplaintsPage()));
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
            Text(title, style: const TextStyle(fontSize: 16.0)),
          ],
        ),
      ),
    );
  }
}
