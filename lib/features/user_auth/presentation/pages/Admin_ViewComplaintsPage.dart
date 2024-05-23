import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class AdminViewComplaintsPage extends StatefulWidget {
  @override
  _AdminViewComplaintsPageState createState() =>
      _AdminViewComplaintsPageState();
}

class _AdminViewComplaintsPageState extends State<AdminViewComplaintsPage> {
  final replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Complaints'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('complaints').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              final doc = snapshot.data?.docs[index];
              final complaint = doc?['complaint'];
              final userEmail = doc?['email'];

              return ListTile(
                title: Text(complaint),
                onTap: () => _showReplyDialog(context, doc?.id, userEmail),
              );
            },
          );
        },
      ),
    );
  }

  void _showReplyDialog(
      BuildContext context, String? complaintId, String? userEmail) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reply to Complaint'),
          content: TextField(
            controller: replyController,
            decoration: InputDecoration(hintText: 'Enter your reply here'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _sendReply(
                    context, complaintId, userEmail, replyController.text);
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendReply(BuildContext context, String? complaintId,
      String? userEmail, String reply) async {
    try {
      // Add reply to Firestore
      await FirebaseFirestore.instance
          .collection('complaints')
          .doc(complaintId)
          .update({
        'reply': reply,
        'repliedAt': FieldValue.serverTimestamp(),
      });

      // Send reply via email
      final smtpServer = gmail('arrowtech5563@gmail.com', 'szttvmusygjgjazq');
      final message = Message()
        ..from = Address('arrowtech5563@gmail.com', 'Arrow Tech')
        ..recipients.add(userEmail!)
        ..subject = 'Reply to your complaint'
        ..text = reply;

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } catch (e) {
        print('Message not sent.');
        print(e.toString());
      }
    } catch (e) {
      Navigator.of(context).pop();
    }
  }
}
