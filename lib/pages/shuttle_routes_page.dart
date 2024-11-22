import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../shuttle_route.dart';

class ShuttleRoutesPage extends StatefulWidget {
  @override
  ShuttleRoutesPageState createState() => ShuttleRoutesPageState();
}

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

class ShuttleRoutesPageState extends State<ShuttleRoutesPage> {
  DateTime selectedDate = DateTime.now();
  List<ShuttleRoute> routes = [];
  ShuttleRoute? selectedRoute;
  late GoogleMapController mapController;
  List<LatLng> polylinePoints = [];
  LatLng startLatLng = LatLng(0, 0);
  LatLng endLatLng = LatLng(0, 0);

  final LatLng center = const LatLng(28.143506, -81.845);

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2064),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _fetchRoutesForDate(selectedDate);
        selectedRoute = null;
        polylinePoints = [];
      });
    }
  }

  Future<void> onRouteSelected(ShuttleRoute route) async {
    setState(() {
      selectedRoute = route;
      polylinePoints = [];
    });

    try {
      startLatLng = await getLatLngFromAddress(route.startPoint);
      endLatLng = await getLatLngFromAddress(route.endPoint);

      List<LatLng> points = await getDirections(startLatLng, endLatLng);
      setState(() {
        polylinePoints = points;
      });
    } catch (e) {
      print('Error fetching directions: $e');
    }
  }

  Future<void> _fetchRoutesForDate(DateTime date) async {
    // Placeholder for fetching routes from the Florida Poly webpage
    // Update this with actual data fetching logic
    final int dayOfWeek = date.weekday;

    // Mock data for now
    setState(() {
      if (dayOfWeek == 1) {
        routes = [
          ShuttleRoute(
            routeName: 'Lakeland Park Center',
            startPoint: 'Wellness Center',
            endPoint: '3715 Hopewell Ave, Lakeland',
            schedule: ['3:15 PM', '4:35 PM', '5:55 PM', '7:15 PM'],
          ),
          ShuttleRoute(
            routeName: 'Wellness Center',
            startPoint: '3715 Hopewell Ave, Lakeland',
            endPoint: 'Wellness Center',
            schedule: ['3:55 PM', '5:15 PM', '6:35 PM', '7:55 PM'],
          ),
        ];
      } else if (dayOfWeek == 2) {
        routes = [
          ShuttleRoute(
            routeName: 'Walmart',
            startPoint: 'Wellness Center',
            endPoint: '2120 US-92 W, Auburndale, FL 33823',
            schedule: ['3:15 PM', '4:25 PM', '5:35 PM', '6:45 PM'],
          ),
          ShuttleRoute(
            routeName: 'Wellness Center',
            startPoint: '2120 US-92 W, Auburndale, FL 33823',
            endPoint: 'Wellness Center',
            schedule: ['3:50 PM', '5:00 PM', '6:10 PM', '7:20 PM'],
          ),
        ];
      } else if (dayOfWeek == 4) {
        routes = [
          ShuttleRoute(
            routeName: 'Publix',
            startPoint: 'Wellness Center',
            endPoint: '5375 N. Socrum Loop Rd., Lakeland, FL 33809',
            schedule: ['3:15 PM', '4:25 PM', '5:35 PM', '6:45 PM', '7:10 PM'],
          ),
          ShuttleRoute(
            routeName: 'Wellness Center',
            startPoint: '5375 N. Socrum Loop Rd., Lakeland, FL 33809',
            endPoint: 'Wellness Center',
            schedule: ['3:50 PM', '5:00 PM', '6:10 PM', '7:20 PM', '7:40 PM'],
          ),
        ];
      } else {
        String formattedDate = DateFormat('MM-dd').format(date);
        if (formattedDate == '09-06' ||
            formattedDate == '10-04' ||
            formattedDate == '11-01' ||
            formattedDate == '12-06') {
          routes = [
            ShuttleRoute(
              routeName: 'Downtown Lakeland',
              startPoint: 'Wellness Center',
              endPoint: 'E Main St, Lakeland, FL 33801',
              schedule: ['3:45 PM', '5:15 PM', '6:45 PM', '8:15 PM'],
            ),
            ShuttleRoute(
              routeName: 'Wellness Center',
              startPoint: 'E Main St, Lakeland, FL 33801',
              endPoint: 'Wellness Center',
              schedule: ['4:30 PM', '6:00 PM', '7:30 PM', '9:00 PM'],
            ),
          ];
        } else {
          routes = [
            ShuttleRoute(
              routeName: 'No routes for today',
              startPoint: 'N/A',
              endPoint: 'N/A',
              schedule: ['N/A'],
            ),
          ];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shuttle Routes'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16.0),
            child: ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.purple),
              title: Text('Choose a date'),
              onTap: () => _selectDate(context),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: routes.length,
              itemBuilder: (context, index) {
                final route = routes[index];
                return ListTile(
                  title: Text(route.routeName),
                  subtitle:
                      Text('From ${route.startPoint} to ${route.endPoint}'),
                  onTap: () => onRouteSelected(route),
                );
              },
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: onMapCreated,
              initialCameraPosition: CameraPosition(
                target: center,
                zoom: 12.0,
              ),
              polylines: {
                if (selectedRoute != null)
                  Polyline(
                    polylineId: PolylineId(selectedRoute!.routeName),
                    color: Color.fromARGB(255, 143, 94, 250),
                    width: 5,
                    points: polylinePoints,
                  )
              },
              markers: selectedRoute != null
                  ? createRouteMarkers(selectedRoute!)
                  : Set<Marker>(),
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> createRouteMarkers(ShuttleRoute route) {
    return {
      Marker(
        markerId: MarkerId('start'),
        position: startLatLng,
        infoWindow: InfoWindow(title: route.startPoint),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
      Marker(
        markerId: MarkerId('end'),
        position: endLatLng,
        infoWindow: InfoWindow(title: route.endPoint),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
    };
  }
}
