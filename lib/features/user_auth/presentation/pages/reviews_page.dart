import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Reviews Page')),
        body: Center(child: Text('Please log in to see your reservations')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Reviews Page')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rooms')
            .where('userId', isEqualTo: currentUser.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
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
              bool checkedIn = data['checkedIn'] ?? false;

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    'Reservation for ${data['roomType']} on ${data['date']} at ${data['time']}',
                  ),
                  subtitle: Text(checkedIn ? 'Checked in' : 'Not checked in'),
                  trailing: ElevatedButton(
                    child: Text('Review'),
                    onPressed: checkedIn
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReviewForm(documentId: document.id),
                              ),
                            );
                          }
                        : null,
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class ReviewForm extends StatefulWidget {
  final String documentId;

  ReviewForm({required this.documentId});

  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _formKey = GlobalKey<FormState>();
  String? _review;
  int? _rating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add a Review')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Review',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your review';
                  }
                  return null;
                },
                onSaved: (value) {
                  _review = value;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Rating',
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: 1, child: Text('1 Star - Bad')),
                  DropdownMenuItem(value: 2, child: Text('2 Stars - Not Good')),
                  DropdownMenuItem(value: 3, child: Text('3 Stars - Decent')),
                  DropdownMenuItem(value: 4, child: Text('4 Stars - Good')),
                  DropdownMenuItem(value: 5, child: Text('5 Stars - Perfect')),
                ],
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a rating';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Submit'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Convert rating to text description
                    String ratingText;
                    switch (_rating) {
                      case 1:
                        ratingText = 'Bad';
                        break;
                      case 2:
                        ratingText = 'Not Good';
                        break;
                      case 3:
                        ratingText = 'Decent';
                        break;
                      case 4:
                        ratingText = 'Good';
                        break;
                      case 5:
                        ratingText = 'Perfect';
                        break;
                      default:
                        ratingText = 'Unknown';
                    }

                    try {
                      await FirebaseFirestore.instance
                          .collection('reviews')
                          .add({
                        'reservationId': widget.documentId,
                        'userId': FirebaseAuth.instance.currentUser!.uid,
                        'review': _review,
                        'rating': ratingText,
                        'timestamp': FieldValue.serverTimestamp(),
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Review submitted successfully')),
                      );

                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to submit review')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
