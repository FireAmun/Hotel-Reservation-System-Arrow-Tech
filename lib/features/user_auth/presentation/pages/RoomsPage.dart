import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoomsPage extends StatefulWidget {
  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedRoomType = 'Single';

  final _fullNameController = TextEditingController();
  final _passportNumberController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _specialRequestsController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _passportNumberController.dispose();
    _phoneNumberController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rooms'),
      ),
      body: ListView(
        children: <Widget>[
          // Date picker
          Card(
            child: ListTile(
              title: Text('Selected Date: ${_selectedDate.toLocal()}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2025),
                );
                if (picked != null && picked != _selectedDate) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
            ),
          ),

          // Time picker
          Card(
            child: ListTile(
              title: Text('Selected Time: ${_selectedTime.format(context)}'),
              trailing: Icon(Icons.access_time),
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (picked != null && picked != _selectedTime) {
                  setState(() {
                    _selectedTime = picked;
                  });
                }
              },
            ),
          ),

          // Room type dropdown
          Card(
            child: DropdownButtonFormField<String>(
              value: _selectedRoomType,
              items: <String>['Single', 'Double', 'Suite']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRoomType = newValue!;
                });
              },
            ),
          ),

          // Full name field
          Card(
            child: ListTile(
              title: TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                ),
              ),
            ),
          ),

          // Passport number field
          Card(
            child: ListTile(
              title: TextFormField(
                controller: _passportNumberController,
                decoration: InputDecoration(
                  labelText: 'Passport Number',
                ),
              ),
            ),
          ),

          // Phone number field
          Card(
            child: ListTile(
              title: TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
            ),
          ),

          // Special request field
          Card(
            child: ListTile(
              title: TextFormField(
                controller: _specialRequestsController,
                decoration: InputDecoration(
                  labelText: 'Special Requests',
                ),
              ),
            ),
          ),

          ElevatedButton(
            child: Text('Submit'),
            onPressed: () async {
              try {
                // Get the current user
                User? currentUser = FirebaseAuth.instance.currentUser;

                if (currentUser == null) {
                  throw Exception("User is not logged in");
                }

                // Store the selected date, time, room type, and additional information in Firestore
                await FirebaseFirestore.instance.collection('rooms').add({
                  'userId': currentUser.uid,
                  'date': _selectedDate,
                  'time': _selectedTime.format(context),
                  'roomType': _selectedRoomType,
                  'fullName': _fullNameController.text,
                  'passportNumber': _passportNumberController.text,
                  'phoneNumber': _phoneNumberController.text,
                  'specialRequests': _specialRequestsController.text,
                });

                // Show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Room booking submitted successfully!')),
                );
              } catch (e) {
                // Show an error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'An error occurred while submitting the booking.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
