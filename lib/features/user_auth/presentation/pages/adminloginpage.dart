import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel/features/user_auth/presentation/pages/AdminDashboardPage.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _adminIdController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _adminIdController,
              decoration: InputDecoration(labelText: 'Admin ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter admin ID';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  final adminId = _adminIdController.text;
                  final password = _passwordController.text;

                  final adminDoc = await FirebaseFirestore.instance
                      .collection('admins')
                      .doc('admin')
                      .get();

                  if (adminDoc.exists) {
                    if (adminDoc['adminId'] == adminId &&
                        adminDoc['password'] == password) {
                      /* Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminDashboardPage(),
                        ),
                      );*/
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid admin ID or password')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Admin document not found')),
                    );
                  }
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
