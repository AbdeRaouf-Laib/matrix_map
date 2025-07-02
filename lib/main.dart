import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Demo',
      home: Page(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapScreen()),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                child: Text(
                  "New",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MapScreen(pos: LatLng(25.254554, 7.03242)),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                child: Text(
                  "Edit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, this.pos});
  final LatLng? pos;
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng? _selectedPosition; // Default position
  final Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.pos;
   
    // _fetchMarkersFromDB();
  }

  Future<void> _fetchMarkersFromDB() async {
    setState(() => _isLoading = true);

    // final response = await http.get(
    //   Uri.parse('http://yourdomain.com/api/get_markers.php'),
    // );

    // if (response.statusCode == 200) {
    //   final List<dynamic> data = json.decode(response.body);
    // final List data = [
    //   {
    //     "markerId": 4,
    //     "latlag": LatLng(36.7538, 3.0598),
    //     "info": InfoWindow(
    //       title: "9ador", // Display the name as title
    //       snippet: "ybi3 el batata", // Additional info
    //     ),
    //   },
    //   {
    //     "markerId": 3,
    //     "latlag": LatLng(36.7540, 3.0578),
    //     "info": InfoWindow(
    //       title: "bo3lam", // Display the name as title
    //       snippet: "ybi3 el besel", // Additional info
    //     ),
    //   },
    //   {
    //     "markerId": 1,
    //     "latlag": LatLng(36.7539, 3.0588),
    //     "info": InfoWindow(
    //       title: "3adel", // Display the name as title
    //       snippet: "l3ziz lghali ymed free coffes", // Additional info
    //     ),
    //   },
    //   {
    //     "markerId": 2,
    //     "latlag": LatLng(36.75382, 3.0599),
    //     "info": InfoWindow(
    //       title: "matrix", // Display the name as title
    //       snippet: "local", // Additional info
    //     ),
    //   },
    // ];
    // setState(() {
    //   _markers = data
    //       .map(
    //         (marker) => Marker(
    //           markerId: MarkerId(marker["markerId"].toString()),
    //           position: marker["latlag"],
    //           infoWindow: marker['info'],
    //         ),
    //       )
    //       .toSet();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map with DB Markers'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _fetchMarkersFromDB),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: (controller) {
              mapController = controller;
              // Center the map on the initial position
              mapController.animateCamera(
                CameraUpdate.newLatLng(_selectedPosition ?? LatLng(21, 15)),
              );
            },
            initialCameraPosition: CameraPosition(
              target: _selectedPosition ?? LatLng(21, 15),
              zoom: 11.0,
            ),
            // markers: {
            //   Marker(
            //     markerId: MarkerId('selected_location'),
            //     position: _selectedPosition ?? LatLng(21, 12),
            //     draggable: true,
            //     onDragEnd: (newPosition) {
            //       setState(() {
            //         _selectedPosition = newPosition;
            //       });
            //     },
            //     icon: BitmapDescriptor.defaultMarkerWithHue(
            //       BitmapDescriptor.hueRed,
            //     ),
            //   ),
            // },
            onTap: (latLng) {
              setState(() {
                _selectedPosition = latLng;
              });
            },
            myLocationEnabled: false,
            myLocationButtonEnabled: true,

            // Enable these options for place names
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            buildingsEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
          ),
        
          Center(child: Icon(Icons.location_pin, size: 40, color: Colors.red)),
          
        ],
      ),
    );
  }
}
