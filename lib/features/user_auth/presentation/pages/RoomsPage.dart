import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomsPage extends StatefulWidget {
  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? _selectedRoomType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rooms Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date picker
            Card(
              child: ListTile(
                title: Text(
                    'Selected Date: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
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
                decoration: InputDecoration(
                  labelText: 'Select Room Type',
                ),
                items: <String>['Single', 'Double', 'Suite']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRoomType = newValue;
                  });
                },
              ),
            ),

            // Submit button
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                // Store the selected date, time, and room type in Firestore
                FirebaseFirestore.instance.collection('rooms').add({
                  'date': _selectedDate,
                  'time': _selectedTime.format(context),
                  'roomType': _selectedRoomType,
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
