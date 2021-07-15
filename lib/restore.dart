import 'dart:async';
import 'dart:html';

//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart' as geoCo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
//import 'package:location/location.dart';
import 'package:my_location/locationp.dart';
import 'dart:ui';
import 'main.dart';
/*
class Restore extends StatefulWidget {
  const Restore({Key? key}) : super(key: key);

  @override
  _RestoreState createState() => _RestoreState();
}

class _RestoreState extends State<Restore> {
  late StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  late Marker marker;
  late Circle circle;
  late GoogleMapController _controller;

  late String location;
  RxList mapList = <OffersModel>[].obs;
  var isLoading = true.obs;

  final allOfferCollection = FirebaseFirestore.instance.collection('all-offers');

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{
  };

  void initState() {
    getMarkerData();
    super.initState();
  }

  void initOffer(specify, specifyId) async
  {
    var p=specify['location'];
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(p['location'].latitude, p['location'].longitutde),
        infoWindow: InfoWindow(title: specify['name'], snippet: specify['location'])
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  Future<DocumentReference> getMarkerData() async {
    try {
      allOfferCollection.get().then((snapshot) {
        print(snapshot);
        if(snapshot.docs.isNotEmpty){
          for(int i= 0; i < snapshot.docs.length; i++)
          {
            initOffer(snapshot.docs[i].data, snapshot.docs[i].id);
          }
        }
        snapshot.docs
            .where((element) => element["location"] == location)
            .forEach((element) {
          if (element.exists) {
            mapList.add(OffersModel.fromJson(element.data(), element.id));
          }
        });
      });
    } finally {
      isLoading(false);
    }
  }

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(36.723062, 3.087800),
    zoom: 14.4746,
    // zoom: 14,

  );

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/marker.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));

    });
  }

  void getCurrentLocation() async {
    try {

      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: 18.00
          )));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }


//class _MapScreenState extends State<MapScreen> {

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: initialLocation,
          markers: Set.of((marker != null) ? [marker] : []),
          // circles: Set.of((circle != null) ? [circle] : []),
          onMapCreated: (GoogleMapController controller) {
            setState(() {
              _controller = controller;
            });
          },
          myLocationEnabled: true,
          compassEnabled: true,

        ),
      ),
    );
  }
}
*/