import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart' as geoCo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui';

class BackLocation extends StatefulWidget {

  static const String id = "BLOCATION";
  const BackLocation({Key? key, user}) : super(key: key);

  @override
  _BackLocationState createState() => _BackLocationState();
}

class _BackLocationState extends State<BackLocation> {
  late GoogleMapController _controller;
   Position? position;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initMarker(specify,specifyId) async{
    final String currentUser= FirebaseAuth.instance.currentUser!.uid.toString();
    if (currentUser == specify['from'])  {
    var markerIdval = specifyId;
    final MarkerId markerId = MarkerId(markerIdval);
    final Marker marker = Marker(
        markerId: markerId,
            position: LatLng(specify['latitude'],specify['longitude']),
      infoWindow: InfoWindow(title: 'Address',snippet: specify['Address']),
    );
    setState(() {
      markers[markerId]=marker;
    });
  }}
  getMarkerData(){
    FirebaseFirestore.instance.collection('location').get().then((myDoc) {

      if (myDoc.docs.isNotEmpty) {
          for(int i=0 ; i< myDoc.docs.length;i++){
          initMarker(myDoc.docs[i].data(), myDoc.docs[i].id);
        }
      }
    });
  }
  void getCurrentLocation() async{
    Position currentPosition = await GeolocatorPlatform.instance.getCurrentPosition();
    setState(() {
      position =currentPosition;
    });
  }


  @override
      void  initState(){
    getMarkerData();
    position = new Position(longitude: 26.292506, latitude: 50.216519, timestamp: null, speedAccuracy: 0, heading: 0.00, speed: 0, altitude:0.0, accuracy: 0.0 , );

    getCurrentLocation();
      super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Set<Marker> getMarker(){
      return<Marker>[
        Marker(markerId: MarkerId('AddressSet'),
          position: LatLng(26.292518, 50.216461),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title:'Home')
        )
      ].toSet();
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xffffb838)),
        title: Text('Saved Locations',
          style: TextStyle(fontSize: 30,color: Colors.deepOrangeAccent)),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),

      body: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(position!.latitude.toDouble(),position!.longitude.toDouble()),
              //zoom: 10,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            compassEnabled: true,
            myLocationEnabled: true,
            markers: Set<Marker>.of(markers.values)),
        //SizedBox(
          //height: 26,
    );
  }
}



