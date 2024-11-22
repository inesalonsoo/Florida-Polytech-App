import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../shuttle_route.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ShuttleRouteDetailPage extends StatefulWidget {
  final ShuttleRoute route;

  ShuttleRouteDetailPage({required this.route});

  @override
  ShuttleRouteDetailPageState createState() => ShuttleRouteDetailPageState();
}

class ShuttleRouteDetailPageState extends State<ShuttleRouteDetailPage> {
  List<LatLng> polylinePoints = [];

  @override
  void initState() {
    super.initState();
    _fetchRoutePoints();
  }

  Future<void> _fetchRoutePoints() async {
    try {
      LatLng startLatLng = await getLatLngFromAddress(widget.route.startPoint);
      LatLng endLatLng = await getLatLngFromAddress(widget.route.endPoint);

      List<LatLng> points = await getDirections(startLatLng, endLatLng);
      setState(() {
        polylinePoints = points;
      });
    } catch (e) {
      print('Error fetching directions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.route.routeName} Details'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${widget.route.routeName} Schedule',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  widget.route.schedule.map((time) => Text(time)).toList(),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(28.136447, -81.904629),
                zoom: 12.8,
              ),
              polylines: {
                Polyline(
                  polylineId: PolylineId(widget.route.routeName),
                  color: Colors.purple,
                  width: 5,
                  points: polylinePoints,
                ),
              },
              markers: _createRouteMarkers(),
              mapType: MapType.satellite,
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> _createRouteMarkers() {
    return {
      Marker(
        markerId: MarkerId('start'),
        position:
            polylinePoints.isNotEmpty ? polylinePoints.first : LatLng(0, 0),
        infoWindow: InfoWindow(title: widget.route.startPoint),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
      Marker(
        markerId: MarkerId('end'),
        position:
            polylinePoints.isNotEmpty ? polylinePoints.last : LatLng(0, 0),
        infoWindow: InfoWindow(title: widget.route.endPoint),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
    };
  }
}

// Function to get directions from the Google Maps Directions API
Future<List<LatLng>> getDirections(LatLng start, LatLng end) async {
  const apiKey = 'AIzaSyCb4VdQAfrxWlqi23Kdi7VUoTrh1YZ9LCY';

  final String startLatLng = '${start.latitude},${start.longitude}';
  final String endLatLng = '${end.latitude},${end.longitude}';

  final String url =
      'https://maps.googleapis.com/maps/api/directions/json?origin=$startLatLng&destination=$endLatLng&key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    List<LatLng> polylinePoints = [];
    var steps = data['routes'][0]['legs'][0]['steps'];
    for (var step in steps) {
      polylinePoints.add(LatLng(
        step['start_location']['lat'],
        step['start_location']['lng'],
      ));
      polylinePoints.add(LatLng(
        step['end_location']['lat'],
        step['end_location']['lng'],
      ));
    }
    return polylinePoints;
  } else {
    throw Exception('Failed to load directions');
  }
}

Future<LatLng> getLatLngFromAddress(String address) async {
  const apiKey = 'AIzaSyCb4VdQAfrxWlqi23Kdi7VUoTrh1YZ9LCY';
  final String url =
      'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final location = data['results'][0]['geometry']['location'];
    return LatLng(location['lat'], location['lng']);
  } else {
    throw Exception('Failed to geocode address');
  }
}
