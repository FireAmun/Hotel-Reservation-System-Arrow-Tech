import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reservations Page')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
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
