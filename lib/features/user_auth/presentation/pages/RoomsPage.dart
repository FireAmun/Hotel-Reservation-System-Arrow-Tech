import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

//roomspage
class RoomsPage extends StatefulWidget {
  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedRoomType = 'Single';
  bool _showQRCode = false; // Added state variable
  bool _reservationMade = false; // Added state variable

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
                DocumentReference reservationRef =
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

                // Send reservation details via email
                final smtpServer =
                    gmail('arrowtech5563@gmail.com', 'szttvmusygjgjazq');
                final message = Message()
                  ..from = Address('arrowtech5563@gmail.com', 'Arrow Tech')
                  ..recipients
                      .add(currentUser.email!) // Use currentUser's email
                  ..subject = 'Reservation Details'
                  ..html = '''
                      <h1>Reservation Details</h1>
                      <p>Date: ${_selectedDate.toLocal().toString()}</p>
                      <p>Time: ${_selectedTime.format(context)}</p>
                      <p>Room Type: $_selectedRoomType</p>
                      <p>Full Name: ${_fullNameController.text}</p>
                      <p>Passport Number: ${_passportNumberController.text}</p>
                      <p>Phone Number: ${_phoneNumberController.text}</p>
                      <p>Special Requests: ${_specialRequestsController.text}</p>
                      ''';

                final sendReport = await send(message, smtpServer);
                print('Message sent: ' + sendReport.toString());

                // Show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Room booking submitted successfully!')),
                );

                setState(() {
                  _reservationMade = true; // Set reservationMade to true
                });
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

          // Button to show/hide QR Code
          if (_reservationMade) // Only show the button if reservation is made
            ElevatedButton(
              child: Text(_showQRCode ? 'Hide QR Code' : 'Show QR Code'),
              onPressed: () {
                setState(() {
                  _showQRCode = !_showQRCode;
                });
              },
            ),

          // QR Code Image
          if (_showQRCode)
            Card(
              child: Image.asset('lib/features/pics/qr_code.png'),
            ),
        ],
      ),
    );
  }
}
