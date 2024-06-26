import 'package:flutter/material.dart';
import 'package:hotel/features/user_auth/presentation/pages/HotelsPage.dart';
import 'package:hotel/features/user_auth/presentation/pages/MakeComplaintsPage.dart';
import 'package:hotel/features/user_auth/presentation/pages/OrderRoomServicePage.dart';
import 'package:hotel/features/user_auth/presentation/pages/reviews_page.dart';
import 'ReservationsPage.dart';
import 'user_profile_page.dart'; // Make sure to import the UserProfilePage
import 'package:hotel/features/user_auth/presentation/pages/Admin_ViewComplaintsPage.dart';

// this is home page
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hotel Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => HotelsPage()));
            }),
            _buildCard('View Reservations', Icons.calendar_today, context, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationsPage()));
            }),
            _buildCard('Room Service', Icons.room_service, context, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderRoomServicePage()));
            }),
            _buildCard('Profile', Icons.person, context, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage()));
            }),
            _buildCard('Complaints', Icons.report_problem, context, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MakeComplaintsPage()));
            }),
            _buildCard('Give Us A Review', Icons.reviews, context, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewsPage()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, BuildContext context, VoidCallback onTap) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 40.0, color: Theme.of(context).primaryColor),
            SizedBox(height: 10.0),
            Text(title, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
