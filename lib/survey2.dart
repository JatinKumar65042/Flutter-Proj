import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Survey2 extends StatefulWidget {
  Survey2({super.key});

  @override
  _Survey2State createState() => _Survey2State();
}

class _Survey2State extends State<Survey2> {
  String? selectedOption;

  final List<Map<String, String>> transportOptions = [
    {
      "mode": "E-Rickshaw",
      "travel_time": "15 min",
      "access_time": "5 min",
      "cost": "Rs 55 per passenger",
      "crowding": "Seats available in the direction of travel"
    },
    {
      "mode": "Cycle",
      "travel_time": "30 min",
      "access_time": "0 min",
      "cost": "Rs. 0",
      "crowding": "Not Applicable"
    },
    {
      "mode": "Walking",
      "travel_time": "50 min",
      "access_time": "0 min",
      "cost": "Rs. 0",
      "crowding": "Not Applicable"
    },
    {
      "mode": "Own Car",
      "travel_time": "10 min",
      "access_time": "5 min",
      "cost": "Rs 150",
      "crowding": "Not Applicable"
    },
    {
      "mode": "Two-Wheeler",
      "travel_time": "15 min",
      "access_time": "2 min",
      "cost": "Rs 25",
      "crowding": "Not Applicable"
    },
    {
      "mode": "Bus",
      "travel_time": "20 min",
      "access_time": "5 min",
      "cost": "Rs 20 per passenger",
      "crowding": "Sitting"
    }
  ];

  void saveSelection(String surveyField) async {
    if (selectedOption != null) {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null || userId.isEmpty) {
        print("Error: userId is null or empty!");
        return;
      }

      try {
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          surveyField: selectedOption,
          'timestamp': Timestamp.now(),
        }, SetOptions(merge: true)); // ✅ Merge instead of overwriting

        print("Data saved successfully for $surveyField: $selectedOption");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selection saved: $selectedOption')),
        );

        // Navigate to the next survey
        Future.delayed(Duration(seconds: 1), () {
          Get.offNamed('/survey3'); // Change dynamically for each survey
        });
      } catch (e) {
        print("Firestore error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving selection! $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a transport mode!')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome to Survey")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading at the top
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Select Transportation Mode",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: transportOptions.map((option) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(option['mode']!, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Travel Time: ${option['travel_time']}"),
                        Text("Access Time: ${option['access_time']}"),
                        Text("Cost: ${option['cost']}"),
                        Text("Crowding: ${option['crowding']}"),
                      ],
                    ),
                    trailing: Radio<String>(
                      value: option['mode']!,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => saveSelection('survey2_mode'),
        child: Icon(Icons.save),
      ),
    );
  }
}
