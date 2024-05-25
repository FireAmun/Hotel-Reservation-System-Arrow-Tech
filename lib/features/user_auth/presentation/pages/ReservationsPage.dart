import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReservationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Reservations Page')),
        body: Center(child: Text('Please log in to see your reservations')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Reservations Page')),
      body: StreamBuilder<QuerySnapshot>(
        // Filter the stream to only include reservations for the current user
        stream: FirebaseFirestore.instance
            .collection('rooms')
            .where('userId', isEqualTo: currentUser.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No reservations found'));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(
                    'Reservation for ${data['roomType']} on ${data['date']} at ${data['time']}'),
                subtitle: Text((data['checkedIn'] ?? false)
                    ? 'Checked in'
                    : 'Not checked in'),
                trailing: ElevatedButton(
                  child: Text('Check In'),
                  onPressed: (data['checkedIn'] ?? false)
                      ? null
                      : () {
                          document.reference.update({'checkedIn': true});
                        },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
