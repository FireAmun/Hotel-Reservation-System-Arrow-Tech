import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminViewReservationPage extends StatefulWidget {
  @override
  _AdminViewReservationPageState createState() =>
      _AdminViewReservationPageState();
}

class _AdminViewReservationPageState extends State<AdminViewReservationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Reservations'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              final doc = snapshot.data?.docs[index];
              final roomType = doc?['roomType'];
              final time = doc?['time'];
              final fullName = doc?['fullName'];
              final passportNumber = doc?['passportNumber'];
              final phoneNumber = doc?['phoneNumber'];
              final specialRequests = doc?['specialRequests'];
              final checkedIn = doc?['checkedIn'] ?? false;

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Reservation for $roomType at $time'),
                  subtitle: Text('Full Name: $fullName\n'
                      'Passport Number: $passportNumber\n'
                      'Phone Number: $phoneNumber\n'
                      'Special Requests: $specialRequests\n'
                      'Status: ${checkedIn ? 'Checked in' : 'Not checked in'}'),
                  trailing: ElevatedButton(
                    child: Text('Check In'),
                    onPressed: checkedIn
                        ? null
                        : () {
                            FirebaseFirestore.instance
                                .collection('rooms')
                                .doc(doc?.id)
                                .update({'checkedIn': true});
                          },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
