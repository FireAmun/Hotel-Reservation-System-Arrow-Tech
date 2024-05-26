import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MakeComplaintsPage extends StatefulWidget {
  @override
  _MakeComplaintsPageState createState() => _MakeComplaintsPageState();
}

class _MakeComplaintsPageState extends State<MakeComplaintsPage> {
  final _formKey = GlobalKey<FormState>();
  final _complaintController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make a Complaint'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _complaintController,
              decoration: InputDecoration(labelText: 'Complaint'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your complaint';
                }
                return null;
              },
            ),
            ElevatedButton(
   onPressed: () async {
    if (_formKey.currentState?.validate() ?? false) {
      final complaint = _complaintController.text;

      // Get the current user's ID
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;

        // Fetch the user's information from Firestore
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        final username = userDoc['username'];
        final email = userDoc['email'];

        FirebaseFirestore.instance.collection('complaints').add({
          'username': username,
          'email': email,
          'complaint': complaint,
          'timestamp': DateTime.now(),
          'userId': userId,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Complaint submitted')),
        );

        _complaintController.clear();
      }
    }
  },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}