import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MakeComplaintsPage extends StatefulWidget {
  @override
  _MakeComplaintsPageState createState() => _MakeComplaintsPageState();
}

class _MakeComplaintsPageState extends State<MakeComplaintsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
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
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
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
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final name = _nameController.text;
                  final email = _emailController.text;
                  final phone = _phoneController.text;
                  final complaint = _complaintController.text;

                  FirebaseFirestore.instance.collection('complaints').add({
                    'name': name,
                    'email': email,
                    'phone': phone,
                    'complaint': complaint,
                    'timestamp': DateTime.now(),
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Complaint submitted')),
                  );

                  _nameController.clear();
                  _emailController.clear();
                  _phoneController.clear();
                  _complaintController.clear();
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
