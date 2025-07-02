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
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  child: Text(
                    "Obtine",
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
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final LatLng _initialPosition = const LatLng(0, 0); // Default position
  final Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMarkersFromDB();
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
            onMapCreated: (controller) => mapController = controller,
            initialCameraPosition: CameraPosition(
              target: LatLng(36.7538, 3.0598),
              zoom: 19,
            ),
            markers: _markers,
            myLocationEnabled: true,
            // Enable these options for place names
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            buildingsEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
          ),
          Container(decoration: BoxDecoration(color: Colors.white)),
        ],
      ),
    );
  }
}
