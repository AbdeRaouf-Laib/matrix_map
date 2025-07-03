import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
<<<<<<< HEAD
import 'package:get/get.dart';

class PositionController extends GetxController {
  Rxn<LatLng> confirmedPosition = Rxn<LatLng>();
}
=======
import 'package:google_maps_flutter/google_maps_flutter.dart';
>>>>>>> f4d67078335ce1b668ce7fa200125ee40c833f78

void main() {
  Get.put(PositionController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Google Maps Demo',
      home: Page(),
      debugShowCheckedModeBanner: false,
    );
  }
}

<<<<<<< HEAD
class Page extends StatelessWidget {
  final PositionController posController = Get.find();
=======
class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  LatLng? confirmedPosition;
  LatLng? _initialPosition;
  Future<LatLng?> _getCurrentLocation() async {
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
>>>>>>> f4d67078335ce1b668ce7fa200125ee40c833f78

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
<<<<<<< HEAD
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  final result = await Get.to(
                    () => MapScreen(addNewMarker: true, initialPosition: null),
                  );
                  if (result is LatLng) {
                    posController.confirmedPosition.value = result;
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
                onTap: posController.confirmedPosition.value == null
                    ? null
                    : () async {
                        final result = await Get.to(
                          () => MapScreen(
                            addNewMarker: true,
                            initialPosition:
                                posController.confirmedPosition.value,
                          ),
                        );
                        if (result is LatLng) {
                          posController.confirmedPosition.value = result;
                        }
                      },
                child: Container(
                  decoration: BoxDecoration(
                    color: posController.confirmedPosition.value == null
                        ? Colors.grey
                        : Colors.green,
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
              if (posController.confirmedPosition.value != null) ...[
                SizedBox(height: 30),
                Text(
                  'Confirmed position: (${posController.confirmedPosition.value!.latitude.toStringAsFixed(6)}, ${posController.confirmedPosition.value!.longitude.toStringAsFixed(6)})',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
=======
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                _getCurrentLocation().then((pos) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(pos: pos),
                    ),
                  );
                });
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MapScreen(pos: LatLng(22.2325, 12.22121)),
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
>>>>>>> f4d67078335ce1b668ce7fa200125ee40c833f78
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
<<<<<<< HEAD
  final bool addNewMarker;
  final LatLng? initialPosition;
  const MapScreen({super.key, this.addNewMarker = false, this.initialPosition});
=======
  final LatLng? pos;
  const MapScreen({super.key, this.pos});
>>>>>>> f4d67078335ce1b668ce7fa200125ee40c833f78

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final LatLng _fallbackPosition = const LatLng(36.7538, 3.0598); // Fallback
  Set<Marker> _markers = {};
  bool _isLoading = true;
  Marker? _tempMarker;
  bool _waitingForConfirmation = false;
  LatLng? _tempMarkerPosition;
<<<<<<< HEAD
  bool _locationError = false;
  String? _locationErrorMsg;
  bool _mapReady = false;

=======
  LatLng? _selectedPosition;
>>>>>>> f4d67078335ce1b668ce7fa200125ee40c833f78
  @override
  void initState() async {
    super.initState();
<<<<<<< HEAD
  }

  Future<LatLng?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = true;
          _locationErrorMsg = 'Location services are disabled.';
        });
        return null;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = true;
            _locationErrorMsg = 'Location permissions are denied.';
          });
          return null;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = true;
          _locationErrorMsg = 'Location permissions are permanently denied.';
        });
        return null;
      }
      Position position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _locationError = true;
        _locationErrorMsg = 'Error getting location: $e';
      });
      return null;
    }
  }

  Future<void> _addMarkerAtInitialPosition() async {
    setState(() {
      _waitingForConfirmation = true;
      _isLoading = true;
      _locationError = false;
      _locationErrorMsg = null;
    });
    LatLng? startPosition = widget.initialPosition;
    if (startPosition == null) {
      startPosition = await _getCurrentLocation();
    }
    if (!mounted) return;
    if (startPosition == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    setState(() {
      _tempMarkerPosition = startPosition;
      _tempMarker = Marker(
        markerId: MarkerId('temp'),
        position: _tempMarkerPosition!,
        infoWindow: InfoWindow(title: 'New Marker'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
      _isLoading = false;
    });
    if (_mapReady) {
      mapController.animateCamera(CameraUpdate.newLatLng(_tempMarkerPosition!));
    }
=======
    _selectedPosition =await widget.pos;

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
>>>>>>> f4d67078335ce1b668ce7fa200125ee40c833f78
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

  Future<void> _addMarkerAtCurrentLocation() async {
    LatLng? currentPosition = widget.pos;
    setState(() {
      _tempMarkerPosition = currentPosition;
      _tempMarker = Marker(
        markerId: MarkerId('temp'),
        position: _tempMarkerPosition!,
        infoWindow: InfoWindow(title: 'New Marker'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
    });
    mapController.animateCamera(CameraUpdate.newLatLng(_tempMarkerPosition!));
  }

  void _confirmMarker() {
    if (_tempMarker != null && _tempMarkerPosition != null) {
      setState(() {
        _markers = Set.from(_markers)..add(_tempMarker!);
        _tempMarker = null;
        _waitingForConfirmation = false;
      });
      Get.back(result: _tempMarkerPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(title: Text('Map with DB Markers')),
=======
      appBar: AppBar(
        title: Text('Map with DB Markers'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _fetchMarkersFromDB),
        ],
      ),
>>>>>>> f4d67078335ce1b668ce7fa200125ee40c833f78
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.satellite,
            onMapCreated: (controller) {
              mapController = controller;
<<<<<<< HEAD
              _mapReady = true;
              if (widget.addNewMarker) {
                _addMarkerAtInitialPosition();
              }
=======
>>>>>>> f4d67078335ce1b668ce7fa200125ee40c833f78
            },
            initialCameraPosition: CameraPosition(
              target: widget.initialPosition ?? _fallbackPosition,
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
<<<<<<< HEAD
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (_locationError && _locationErrorMsg != null)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 48),
                      SizedBox(height: 16),
                      Text(
                        _locationErrorMsg!,
                        style: TextStyle(color: Colors.red, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('Back'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton:
          _waitingForConfirmation &&
              _tempMarker != null &&
              !_isLoading &&
              !_locationError
          ? FloatingActionButton.extended(
              onPressed: _confirmMarker,
              label: Text('Confirm Marker'),
              icon: Icon(Icons.check),
            )
          : null,
=======

          Center(child: Icon(Icons.location_pin, size: 40, color: Colors.red)),
        ],
      ),
>>>>>>> f4d67078335ce1b668ce7fa200125ee40c833f78
    );
  }
}
