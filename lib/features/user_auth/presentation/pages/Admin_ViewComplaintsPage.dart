import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminComplaintsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AdminComplaintsPage')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('complaints').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text('complaint for:'
                    ' Name: ${data['name']}'
                    '  Email: ${data['email']}'
                    '  Phone: ${data['phone']}'),
                subtitle: Text('Complaint: ${data['complaint']}'),
                trailing: IconButton(
                  icon: Icon(Icons.reply),
                  onPressed: () {
                    _showReplyDialog(context, document.id, data['email']);
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

void _showReplyDialog(
    BuildContext context, String complaintId, String userEmail) {
  TextEditingController replyController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Reply to Complaint'),
        content: TextField(
          controller: replyController,
          decoration: InputDecoration(hintText: "Enter your reply"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _sendReply(context, complaintId, userEmail, replyController.text);
            },
            child: Text('Send'),
          ),
        ],
      );
    },
  );
}

Future<void> _sendReply(BuildContext context, String complaintId,
    String userEmail, String reply) async {
  try {
    // Add reply to Firestore
    await FirebaseFirestore.instance
        .collection('complaints')
        .doc(complaintId)
        .update({
      'reply': reply,
      'repliedAt': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to send reply: $e')),
    );
  }
}
