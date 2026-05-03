import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CropTrackerScreen extends StatefulWidget {
  const CropTrackerScreen({super.key});

  @override
  _CropTrackerScreenState createState() => _CropTrackerScreenState();
}

class _CropTrackerScreenState extends State<CropTrackerScreen> {
  final TextEditingController _controller = TextEditingController();
  final CollectionReference crops = FirebaseFirestore.instance.collection('crops');

  void _addCrop() async {
    if (_controller.text.trim().isNotEmpty) {
      await crops.add({'name': _controller.text.trim()});
      _controller.clear();
    }
  }

  void _deleteCrop(String id) async {
    await crops.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crop Tracker")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter crop name',
                suffixIcon: IconButton(icon: Icon(Icons.add), onPressed: _addCrop),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: crops.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var data = docs[index];
                    return ListTile(
                      title: Text(data['name']),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteCrop(data.id),
                      ),
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
