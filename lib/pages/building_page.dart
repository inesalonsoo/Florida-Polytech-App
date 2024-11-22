import 'package:flutter/material.dart';

class BuildingPage extends StatelessWidget {
  final String buildingName;

  BuildingPage({required this.buildingName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$buildingName Floor Plans'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text('Display floor plans for $buildingName here'),
      ),
    );
  }
}
