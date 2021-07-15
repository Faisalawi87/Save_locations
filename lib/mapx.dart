import 'dart:async';
import 'backlocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart' as geoCo;
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapLocation extends StatefulWidget {

  static const String id = "MAPLOCATION";
  final UserCredential user;
  const MapLocation({ Key? key,  required this.user}):super(key: key);
   //const Locationp({Key? key}) : super(key: key);



  @override
  _MapLocationState createState() => _MapLocationState();

}

class _MapLocationState extends State<MapLocation> {



  Completer<GoogleMapController>_controller=Completer();

  Map<MarkerId,Marker> markers =< MarkerId,Marker>{};

  Position? position;
  String? addressLocation;
  String? country;

  void getMarkers(double lat,double long){
    MarkerId markerId = MarkerId(lat.toString()+ long.toString());
    Marker _marker = Marker(
      markerId: markerId,
      position: LatLng(lat,long),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      infoWindow: InfoWindow(snippet: addressLocation!)
    );
    setState(() {
      markers[markerId]=_marker;
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
    super.initState();
    position = new Position(longitude: 26.292506, latitude: 50.216519, timestamp: null, speedAccuracy: 0, heading: 0.00, speed: 0, altitude:0.0, accuracy: 0.0 , );
    addressLocation = 'null';
    country= 'null';
    getCurrentLocation();
      }

  /*static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(26.292506,50.216519),
    zoom: 14.4746,
  );*/
  late Position currentPosition;
  var geolocator = Geolocator();
  double bottomPaddingofMap = 0;

  void locatePosition() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition= position;
    LatLng LatLngPosition = LatLng(position.latitude,position.longitude);
    CameraPosition cameraPosition= new CameraPosition(target: LatLngPosition, zoom: 14.4746,);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

  }

 @override
  void dispose(){
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return
      Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Tap to save Location'),
          ),
          body:
          Container(
            child: Column(
            children: [
              SizedBox(
            height: 600,
                  child: GoogleMap(
                    padding: EdgeInsets.only(bottom: bottomPaddingofMap),
                    onTap: (tapped) async {
                      final coordinated = new geoCo.Coordinates(tapped.latitude, tapped.longitude);
                      var address = await geoCo.Geocoder.local.findAddressesFromCoordinates(coordinated);
                      var firstAddress = address.first;
                      getMarkers(tapped.latitude, tapped.longitude);
                      await FirebaseFirestore.instance.collection('location').add({
                        'from': widget.user.credential,
                        'latitude' : tapped.latitude,
                        'longitude': tapped.longitude,
                        'Address' : firstAddress.addressLine,
                        'Country': firstAddress.countryName,
                        'date': DateTime.now().toIso8601String().toString()
                      });
                      setState(() {
                        country = firstAddress.countryName;
                        addressLocation = firstAddress.addressLine;
                      });
                    },
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(position!.latitude.toDouble(),position!.longitude.toDouble())),
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    markers: Set<Marker>.of(
                        markers.values
                    ),
                  compassEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    locatePosition();
                    setState(() {
                      bottomPaddingofMap = 250.0;
                    });
                  },
                ),

                ),
                  Text('Address: $addressLocation'),
                  Text('Country: $country')
                ],
          ),
          )
          ),
           Positioned(
                  bottom: 50,
                  right: 10,
                child: FlatButton(
                  child: Icon(Icons.pin_drop),
                  color: Colors.cyan,
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> BackLocation(),
                        )
                    );
                  }
                     )
                     ),

    ]
   );
  }

 }



