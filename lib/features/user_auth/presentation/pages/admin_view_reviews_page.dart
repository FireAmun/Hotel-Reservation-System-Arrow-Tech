import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminViewReviewsPage extends StatefulWidget {
  @override
  _AdminViewReviewsPageState createState() => _AdminViewReviewsPageState();
}

class _AdminViewReviewsPageState extends State<AdminViewReviewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Reviews'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('reviews').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              final doc = snapshot.data?.docs[index];
              final reservationId = doc?['reservationId'];
              final userId = doc?['userId'];
              final review = doc?['review'];
              final rating = doc?['rating'];

              if (userId == null || userId.isEmpty) {
                return ListTile(
                  title: Text('Invalid User ID'),
                );
              }

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return ListTile(
                      title: Text('Loading user data...'),
                    );
                  }

                  final userEmail =
                      userSnapshot.data?['email'] ?? 'Unknown Email';

                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('Review for Reservation ID: $reservationId'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('User Email: $userEmail'),
                          Text('Rating: $rating'),
                          Text('Review: $review'),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
