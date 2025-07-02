import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

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

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  LatLng? confirmedPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(addNewMarker: true),
                    ),
                  );
                  if (result is LatLng) {
                    setState(() {
                      confirmedPosition = result;
                    });
                  }
                },
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
              if (confirmedPosition != null) ...[
                SizedBox(height: 30),
                Text(
                  'Confirmed position: (${confirmedPosition!.latitude.toStringAsFixed(6)}, ${confirmedPosition!.longitude.toStringAsFixed(6)})',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  final bool addNewMarker;
  const MapScreen({super.key, this.addNewMarker = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final LatLng _initialPosition = const LatLng(
    36.7538,
    3.0598,
  ); // Default position
  Set<Marker> _markers = {};
  bool _isLoading = true;
  Marker? _tempMarker;
  bool _waitingForConfirmation = false;
  LatLng? _tempMarkerPosition;

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

  Future<LatLng> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return _initialPosition;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return _initialPosition;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return _initialPosition;
    }
    Position position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  Future<void> _addMarkerAtCurrentLocation() async {
    setState(() {
      _waitingForConfirmation = true;
    });
    LatLng currentPosition = await _getCurrentLocation();
    setState(() {
      _tempMarkerPosition = currentPosition;
      _tempMarker = Marker(
        markerId: MarkerId('temp'),
        position: _tempMarkerPosition!,
        infoWindow: InfoWindow(title: 'New Marker'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure,
        ),
      );
    });
    mapController.animateCamera(CameraUpdate.newLatLng(_tempMarkerPosition!));
  }

  void _onCameraMove(CameraPosition position) {
    if (_waitingForConfirmation) {
      setState(() {
        _tempMarkerPosition = position.target;
        _tempMarker = Marker(
          markerId: MarkerId('temp'),
          position: _tempMarkerPosition!,
          infoWindow: InfoWindow(title: 'New Marker'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        );
      });
    }
  }

  void _confirmMarker() {
    if (_tempMarker != null && _tempMarkerPosition != null) {
      setState(() {
        _markers = Set.from(_markers)..add(_tempMarker!);
        _tempMarker = null;
        _waitingForConfirmation = false;
      });
      Navigator.pop(context, _tempMarkerPosition);
    }
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
              if (widget.addNewMarker) {
                _addMarkerAtCurrentLocation();
              }
            },
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 19,
            ),
            markers: _tempMarker != null
                ? {..._markers, _tempMarker!}
                : _markers,
            myLocationEnabled: true,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            buildingsEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onCameraMove: _onCameraMove,
          ),
        ],
      ),
      floatingActionButton: _waitingForConfirmation && _tempMarker != null
          ? FloatingActionButton.extended(
              onPressed: _confirmMarker,
              label: Text('Confirm Marker'),
              icon: Icon(Icons.check),
            )
          : null,
    );
  }
}
