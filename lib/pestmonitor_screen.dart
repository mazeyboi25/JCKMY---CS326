import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PestMonitorScreen extends StatefulWidget {
  const PestMonitorScreen({super.key});

  @override
  _PestMonitorScreenState createState() => _PestMonitorScreenState();
}

class _PestMonitorScreenState extends State<PestMonitorScreen> {
  final TextEditingController reportController = TextEditingController();
  final CollectionReference reports = FirebaseFirestore.instance.collection('pest_reports');

  void _submitReport() async {
    if (reportController.text.isNotEmpty) {
      await reports.add({
        'report': reportController.text,
        'timestamp': Timestamp.now(),
      });
      reportController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pest & Disease Monitor")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: reportController,
              decoration: InputDecoration(
                labelText: 'Describe the issue',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _submitReport,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: reports.orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var data = docs[index];
                    return ListTile(
                      title: Text(data['report']),
                      subtitle: Text(data['timestamp'].toDate().toString()),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
