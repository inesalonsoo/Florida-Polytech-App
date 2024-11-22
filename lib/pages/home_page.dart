// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import '../widgets/feature_card.dart';
import 'campus_map_page.dart';
import 'shuttle_routes_page.dart';
import 'about_page.dart'; // Import the AboutPage

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var image = Image.asset(
      'assets/images/fpuwallpaper.jpg',
      fit: BoxFit.cover,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: image,
            ),
          ),
          Center(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                FeatureCard(
                  context,
                  Icons.map,
                  "Campus Map",
                  Colors.deepPurple,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CampusMapPage()),
                    );
                  },
                ),
                FeatureCard(
                  context,
                  Icons.directions_bus,
                  "Shuttle Routes",
                  Colors.purple,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShuttleRoutesPage()),
                    );
                  },
                ),
                FeatureCard(
                  context,
                  Icons.class_,
                  "Class Info",
                  Colors.deepPurpleAccent,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Let's explore Class Info!")),
                    );
                  },
                ),
                FeatureCard(
                  context,
                  Icons.info,
                  "About",
                  Colors.purpleAccent,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
