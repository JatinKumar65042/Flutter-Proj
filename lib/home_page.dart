import 'google_maps.dart'; // Import the Google Maps page
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      body: Stack(
        children: [
          // Center content
          Center(
            child: Text(
              "Welcome to Home",
              style: TextStyle(fontSize: 20),
            ),
          ),

          // Button placed at the bottom-right corner
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Add padding for spacing
              child: FloatingActionButton(
                onPressed: () {
                  // Navigate to the Google Maps page
                  Navigator.pushNamed(context, "/maps");
                },
                child: Icon(Icons.map),
                tooltip: "Open Google Maps",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
