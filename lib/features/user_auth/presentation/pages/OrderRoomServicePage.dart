import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//this is order room service page
class OrderRoomServicePage extends StatefulWidget {
  @override
  _OrderRoomServicePageState createState() => _OrderRoomServicePageState();
}

class _OrderRoomServicePageState extends State<OrderRoomServicePage> {
  String? _selectedServiceType;
  String _specialRequest = '';
  int _quantity = 1;
  String _roomNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Room Service')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Service type dropdown
            Card(
              child: DropdownButtonFormField<String>(
                value: _selectedServiceType,
                decoration: InputDecoration(
                  labelText: 'Select Service Type',
                ),
                items: <String>['Food', 'Cleaning', 'Laundry']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedServiceType = newValue;
                  });
                },
              ),
            ),

            // Room number text field
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Room Number',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _roomNumber = value;
                    });
                  },
                ),
              ),
            ),

            // Quantity selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Quantity:'),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (_quantity > 1) {
                          setState(() {
                            _quantity--;
                          });
                        }
                      },
                    ),
                    Text('$_quantity'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Special requests text field
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _specialRequest = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Special Requests',
                  ),
                ),
              ),
            ),

            // Submit button
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                // Store the order details in Firestore
                FirebaseFirestore.instance.collection('orders').add({
                  'serviceType': _selectedServiceType,
                  'roomNumber': _roomNumber,
                  'quantity': _quantity,
                  'specialRequest': _specialRequest,
                });

                // Show a confirmation dialog or navigate to a new page if needed
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Order Submitted'),
                      content:
                          Text('Your order has been submitted successfully.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
