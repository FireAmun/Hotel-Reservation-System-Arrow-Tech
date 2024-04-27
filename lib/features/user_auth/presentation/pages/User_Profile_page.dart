import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // Mock user data - you might want to fetch this from a database or state management solution
  String username = "Amar";
  String email = "amar.doe@example.com";
  String address = "Johor, skudai, Malaysia";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Implement editing functionality
              _editProfile(context);
            },
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          _userInfoTile("Username", username),
          _userInfoTile("Email", email),
          _userInfoTile("Address", address),
        ],
      ),
    );
  }

  Widget _userInfoTile(String label, String value) {
    return ListTile(
      title: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }

  void _editProfile(BuildContext context) {
    // Simple dialog to edit user info
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: "Username"),
                controller: TextEditingController(text: username),
                onChanged: (value) => username = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Email"),
                controller: TextEditingController(text: email),
                onChanged: (value) => email = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Address"),
                controller: TextEditingController(text: address),
                onChanged: (value) => address = value,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Save"),
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
