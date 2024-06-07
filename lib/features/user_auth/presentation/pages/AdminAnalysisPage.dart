import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAnalysisPage extends StatefulWidget {
  @override
  _AdminAnalysisPageState createState() => _AdminAnalysisPageState();
}

class _AdminAnalysisPageState extends State<AdminAnalysisPage> {
  late Future<int> _userCount;
  late Future<int> _orderCount;
  late Future<int> _complaintCount;
  late Future<int> _reservationCount;
  late Future<int> _reviewCount;

  @override
  void initState() {
    super.initState();
    _userCount = _getDocumentCount('users');
    _orderCount = _getDocumentCount('orders');
    _complaintCount = _getDocumentCount('complaints');
    _reservationCount = _getReservationCount();
    _reviewCount = _getDocumentCount('reviews'); // Add this line
  }

  Future<int> _getDocumentCount(String collectionName) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();
    return querySnapshot.docs.length;
  }

  Future<int> _getReservationCount() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .where('checkedIn', isEqualTo: true)
        .get();
    return querySnapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Analysis'),
      ),
      body: FutureBuilder(
        future: Future.wait([
          _userCount,
          _orderCount,
          _complaintCount,
          _reservationCount,
          _reviewCount // Add this line
        ]),
        builder: (context, AsyncSnapshot<List<int>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.people, color: Colors.blue),
                      title: Text('Total Users'),
                      trailing: Text(snapshot.data![0].toString(),
                          style: TextStyle(fontSize: 20.0)),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.shopping_cart, color: Colors.green),
                      title: Text('Total Orders'),
                      trailing: Text(snapshot.data![1].toString(),
                          style: TextStyle(fontSize: 20.0)),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.report_problem, color: Colors.red),
                      title: Text('Total Complaints'),
                      trailing: Text(snapshot.data![2].toString(),
                          style: TextStyle(fontSize: 20.0)),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.hotel, color: Colors.purple),
                      title: Text('Total Reservations'),
                      trailing: Text(snapshot.data![3].toString(),
                          style: TextStyle(fontSize: 20.0)),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.rate_review,
                          color: Colors.orange), // Icon for reviews
                      title: Text('Total Reviews'), // Title for reviews
                      trailing: Text(
                          snapshot.data![4]
                              .toString(), // Display total reviews count
                          style: TextStyle(fontSize: 20.0)),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
