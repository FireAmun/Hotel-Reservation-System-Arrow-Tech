// OrderRoomServicePage.dart
import 'package:flutter/material.dart';

class OrderRoomServicePage extends StatefulWidget {
  @override
  _OrderRoomServicePageState createState() => _OrderRoomServicePageState();
}

class _OrderRoomServicePageState extends State<OrderRoomServicePage> {
  String? _selectedServiceType;
  String _specialRequest = '';
  int _quantity = 1;

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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: _selectedServiceType,
                  hint: Text('Select Service Type'),
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
                // Create a new Order object and navigate to a confirmation page
                // ...
              },
            ),
          ],
        ),
      ),
    );
  }
}
