import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminViewRoomServicePage extends StatefulWidget {
  @override
  _AdminViewRoomServicePageState createState() =>
      _AdminViewRoomServicePageState();
}

class _AdminViewRoomServicePageState extends State<AdminViewRoomServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Room Service Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              final doc = snapshot.data?.docs[index];
              final serviceType = doc?['serviceType'];
              final roomNumber = doc?['roomNumber'];
              final quantity = doc?['quantity'];
              final specialRequest = doc?['specialRequest'];

              return ListTile(
                title: Text('Service Type: $serviceType'),
                subtitle: Text(
                    'Room Number: $roomNumber\nQuantity: $quantity\nSpecial Request: $specialRequest'),
              );
            },
          );
        },
      ),
    );
  }
}
