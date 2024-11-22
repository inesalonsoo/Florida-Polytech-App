import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'building_page.dart';

class CampusMapPage extends StatefulWidget {
  @override
  CampusMapPageState createState() => CampusMapPageState();
}

class CampusMapPageState extends State<CampusMapPage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(28.148256, -81.848737);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Map'),
        backgroundColor: Colors.deepPurple,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 16.0,
        ),
        mapType: MapType.satellite,
        markers: _createMarkers(),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return <Marker>{
      Marker(
        markerId: MarkerId('Innovation, Science, & Technology Building (IST)'),
        position: LatLng(28.150415, -81.850978),
        infoWindow: InfoWindow(
          title: 'Innovation, Science, & Technology Building (IST)',
          snippet: 'Click to expand',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BuildingPage(
                      buildingName:
                          'Innovation, Science, & Technology Building (IST)')),
            );
          },
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
      Marker(
        markerId: MarkerId('Barnett Applied Research Center'),
        position: LatLng(28.149499, -81.851778),
        infoWindow: InfoWindow(
          title: 'Barnett Applied Research Center',
          snippet: 'Click to expand',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BuildingPage(
                      buildingName: 'Barnett Applied Research Center')),
            );
          },
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
      Marker(
        markerId: MarkerId('Florida Polytechnic University Student Living'),
        position: LatLng(28.150479, -81.848216),
        infoWindow: InfoWindow(
          title: 'Florida Polytechnic University Student Living',
          snippet: 'Click to expand',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BuildingPage(
                      buildingName:
                          'Florida Polytechnic University Student Living')),
            );
          },
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
    };
  }
}
