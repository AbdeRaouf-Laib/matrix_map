import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class PositionController extends GetxController {
  Rxn<LatLng> confirmedPosition = Rxn<LatLng>();
}

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

class Page extends StatelessWidget {
  final PositionController posController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                final result = await Get.to(() => MapScreen(
                  addNewMarker: true,
                  initialPosition: null,
                ));
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
                      final result = await Get.to(() => MapScreen(
                        addNewMarker: true,
                        initialPosition: posController.confirmedPosition.value,
                      ));
                      if (result is LatLng) {
                        posController.confirmedPosition.value = result;
                      }
                    },
              child: Container(
                decoration: BoxDecoration(
                  color: posController.confirmedPosition.value == null ? Colors.grey : Colors.green,
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
        )),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  final bool addNewMarker;
  final LatLng? initialPosition;
  const MapScreen({super.key, this.addNewMarker = false, this.initialPosition});

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
  bool _locationError = false;
  String? _locationErrorMsg;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
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
  }

  void _onCameraMove(CameraPosition position) {
    if (_waitingForConfirmation) {
      setState(() {
        _tempMarkerPosition = position.target;
        _tempMarker = Marker(
          markerId: MarkerId('temp'),
          position: _tempMarkerPosition!,
          infoWindow: InfoWindow(title: 'New Marker'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
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
      Get.back(result: _tempMarkerPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map with DB Markers'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: (controller) {
              mapController = controller;
              _mapReady = true;
              if (widget.addNewMarker) {
                _addMarkerAtInitialPosition();
              }
            },
            initialCameraPosition: CameraPosition(
              target: widget.initialPosition ?? _fallbackPosition,
              zoom: 19,
            ),
            markers: _tempMarker != null ? {..._markers, _tempMarker!} : _markers,
            myLocationEnabled: true,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            buildingsEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onCameraMove: _onCameraMove,
          ),
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
                      Text(_locationErrorMsg!, style: TextStyle(color: Colors.red, fontSize: 18), textAlign: TextAlign.center),
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
      floatingActionButton: _waitingForConfirmation && _tempMarker != null && !_isLoading && !_locationError
          ? FloatingActionButton.extended(
              onPressed: _confirmMarker,
              label: Text('Confirm Marker'),
              icon: Icon(Icons.check),
            )
          : null,
    );
  }
}
