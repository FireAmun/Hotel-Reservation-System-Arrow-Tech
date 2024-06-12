import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AdminAnalysisPage extends StatefulWidget {
  @override
  _AdminAnalysisPageState createState() => _AdminAnalysisPageState();
}

class _AdminAnalysisPageState extends State<AdminAnalysisPage> {
  late Future<int> _userCount;
  late Future<int> _orderCount;
  late Future<int> _complaintCount;
  late Future<int> _reservationCount;
  late Future<int> _reviewCount;
  late Future<Map<String, int>> _dailyReservations;
  late Future<Map<String, int>> _weeklyReservations;
  late Future<Map<String, int>> _monthlyReservations;

  @override
  void initState() {
    super.initState();
    _userCount = _getDocumentCount('users');
    _orderCount = _getDocumentCount('orders');
    _complaintCount = _getDocumentCount('complaints');
    _reservationCount = _getReservationCount();
    _reviewCount = _getDocumentCount('reviews');
    _dailyReservations = _getReservationsByPeriod('day');
    _weeklyReservations = _getReservationsByPeriod('week');
    _monthlyReservations = _getReservationsByPeriod('month');
  }

  Future<int> _getDocumentCount(String collectionName) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();
    return querySnapshot.docs.length;
  }

  Future<int> _getReservationCount() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .where('checkedIn', isEqualTo: true)
        .get();
    return querySnapshot.docs.length;
  }

  Future<Map<String, int>> _getReservationsByPeriod(String period) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('rooms').get();
    Map<String, int> reservations = {};

    for (var doc in querySnapshot.docs) {
      var dateField = doc['date'];
      if (dateField is Timestamp) {
        DateTime date = dateField.toDate();
        String key;
        if (period == 'day') {
          key = "${date.year}-${date.month}-${date.day}";
        } else if (period == 'week') {
          int weekNumber = ((date.day - 1) / 7).floor() + 1;
          key = "${date.year}-${date.month}-Week $weekNumber";
        } else if (period == 'month') {
          key = "${date.year}-${date.month}";
        } else {
          continue;
        }

        if (reservations.containsKey(key)) {
          reservations[key] = reservations[key]! + 1;
        } else {
          reservations[key] = 1;
        }
      }
    }

    return reservations;
  }

  List<charts.Series<MapEntry<String, int>, String>> _createSeries(
      Map<String, int> data, String id, charts.Color color) {
    return [
      charts.Series<MapEntry<String, int>, String>(
        id: id,
        colorFn: (_, __) => color,
        domainFn: (MapEntry<String, int> entry, _) => entry.key,
        measureFn: (MapEntry<String, int> entry, _) => entry.value,
        data: data.entries.toList(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Analysis'),
      ),
      body: FutureBuilder(
        future: Future.wait([
          _userCount,
          _orderCount,
          _complaintCount,
          _reservationCount,
          _reviewCount,
          _dailyReservations,
          _weeklyReservations,
          _monthlyReservations,
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Something went wrong: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!.any((data) => data == null)) {
            return Center(child: Text('No data available'));
          } else {
            var userCount = snapshot.data![0] as int;
            var orderCount = snapshot.data![1] as int;
            var complaintCount = snapshot.data![2] as int;
            var reservationCount = snapshot.data![3] as int;
            var reviewCount = snapshot.data![4] as int;
            var dailyReservations = snapshot.data![5] as Map<String, int>;
            var weeklyReservations = snapshot.data![6] as Map<String, int>;
            var monthlyReservations = snapshot.data![7] as Map<String, int>;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.people, color: Colors.blue),
                      title: Text('Total Users'),
                      trailing: Text(userCount.toString(),
                          style: TextStyle(fontSize: 20.0)),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.shopping_cart, color: Colors.green),
                      title: Text('Total Orders'),
                      trailing: Text(orderCount.toString(),
                          style: TextStyle(fontSize: 20.0)),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.report_problem, color: Colors.red),
                      title: Text('Total Complaints'),
                      trailing: Text(complaintCount.toString(),
                          style: TextStyle(fontSize: 20.0)),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.hotel, color: Colors.purple),
                      title: Text('Total Reservations'),
                      trailing: Text(reservationCount.toString(),
                          style: TextStyle(fontSize: 20.0)),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.rate_review, color: Colors.orange),
                      title: Text('Total Reviews'),
                      trailing: Text(reviewCount.toString(),
                          style: TextStyle(fontSize: 20.0)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Daily Reservations', style: TextStyle(fontSize: 18)),
                  SizedBox(
                    height: 200,
                    child: charts.BarChart(
                      _createSeries(dailyReservations, 'Daily',
                          charts.MaterialPalette.blue.shadeDefault),
                      animate: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Weekly Reservations', style: TextStyle(fontSize: 18)),
                  SizedBox(
                    height: 200,
                    child: charts.BarChart(
                      _createSeries(weeklyReservations, 'Weekly',
                          charts.MaterialPalette.green.shadeDefault),
                      animate: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Monthly Reservations', style: TextStyle(fontSize: 18)),
                  SizedBox(
                    height: 200,
                    child: charts.BarChart(
                      _createSeries(monthlyReservations, 'Monthly',
                          charts.MaterialPalette.red.shadeDefault),
                      animate: true,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
