import 'package:flutter/material.dart';
import 'package:hotel/features/user_auth/presentation/pages/Admin_ViewComplaintsPage.dart';
import 'package:hotel/features/user_auth/presentation/pages/Admin_View_Reservation.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({Key? key});
//admin
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Implement sign out functionality
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
            _buildCard('View Reservations', Icons.calendar_today, context, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminReservationsPage()));
            }),
            _buildCard('Complaints', Icons.report_problem, context, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminComplaintsPage()));
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
