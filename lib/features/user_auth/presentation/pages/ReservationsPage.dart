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
              bool isCheckedIn = data['checkedIn'] ?? false;
              return ReservationTile(data: data, document: document);
            }).toList(),
          );
        },
      ),
    );
  }
}

class ReservationTile extends StatefulWidget {
  final Map<String, dynamic> data;
  final DocumentSnapshot document;

  const ReservationTile({
    required this.data,
    required this.document,
  });

  @override
  _ReservationTileState createState() => _ReservationTileState();
}

class _ReservationTileState extends State<ReservationTile> {
  bool showQRCode = false;

  @override
  Widget build(BuildContext context) {
    bool isCheckedIn = widget.data['checkedIn'] ?? false;
    return ListTile(
      title: Text(
          'Reservation for ${widget.data['roomType']} on ${widget.data['date']} at ${widget.data['time']}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isCheckedIn ? 'Checked in' : 'Not checked in'),
          if (isCheckedIn)
            Column(
              children: [
                ElevatedButton(
                  child: Text(showQRCode ? 'Hide QR Code' : 'Show QR Code'),
                  onPressed: () {
                    setState(() {
                      showQRCode = !showQRCode;
                    });
                  },
                ),
                if (showQRCode)
                  Image.asset(
                    'lib/features/pics/qr_code.png',
                    height: 300, // Full image size
                    width: 300, // Full image size
                  ),
              ],
            ),
        ],
      ),
      trailing: ElevatedButton(
        child: Text(isCheckedIn ? 'Checked In' : 'Check In'),
        onPressed: isCheckedIn
            ? null
            : () {
                widget.document.reference.update({'checkedIn': true});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Checked in successfully')),
                );
                setState(() {}); // Update the state to reflect the change
              },
      ),
    );
  }
}
