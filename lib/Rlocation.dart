import 'dart:async';

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
class Rlocation extends StatefulWidget {
  const Rlocation({Key? key}) : super(key: key);
  static const String id = "RLOCATION";


  @override
  _RlocationState createState() => _RlocationState();
}

class _RlocationState extends State<Rlocation> {
  Map<MarkerId,Marker> client =< MarkerId,Marker>{};
  Position? position;

  bool mapToggle = false;
  bool clientsToggle = false;
  bool resetToggle = false;

  var currentLocation;

  var clients = [];

  var currentClient;
  var currentBearing;

  late GoogleMapController mapController;

  void initState() {
    super.initState();
    Geolocator.getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
        populateClients();
        position = new Position(longitude: 26.292506, latitude: 50.216519, timestamp: null, speedAccuracy: 0, heading: 0.00, speed: 0, altitude:0.0, accuracy: 0.0 , );
      });
    });
  }


  populateClients() {
    clients = [];
    FirebaseFirestore.instance.collection('location').get().then((value) {
      if (value.docs.isNotEmpty) {
        setState(() {
          clientsToggle = true;
        });
        for (int i = 0; i < value.docs.length; ++i) {
          clients.add(value.docs[i].data);
          //print(clients);
          initMarker(value.docs[i].data, value.docs[i].id);
        }
      }
    });
  }
  /////////////////////////
  /*void getMarkers(double lat,double long){
    MarkerId markerId = MarkerId(lat.toString()+ long.toString());
    Marker _marker = Marker(
        markerId: markerId,
        position: LatLng(lat,long),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        //infoWindow: InfoWindow(snippet: addressLocation!)
    );
    setState(() {
      markers[markerId]=_marker;
    });
  }*/
  ///////////////

  initMarker(client,clientID) {
    var markerIdVal = clientID;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
          position:
          LatLng(client['latitude'].latitude, client['longitude'].longitude),
          draggable: false,
          //infoWindow: InfoWindow(snippet: client['Address'])
          );
    setState(() {
      client[clientID]=marker;
    });
    }
  

  Widget clientCard(client) {
    return Padding(
        padding: EdgeInsets.only(left: 2.0, top: 10.0),
        child: InkWell(
            onTap: () {
              setState(() {
                currentClient = client;
                currentBearing = 90.0;
              });
              zoomInMarker(client);
            },
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                  height: 100.0,
                  width: 125.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white),
                  //child: Center(child: Text(client['Address']))
    ),
            )));
  }

  zoomInMarker(client) {
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            client['latitude'].latitude, client['longitude'].longitude),
        zoom: 17.0,
        bearing: 90.0,
        tilt: 45.0)))
        .then((val) {
      setState(() {
        resetToggle = true;
      });
    });
  }

  resetCamera() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 10.0))).then((val) {
      setState(() {
        resetToggle = false;
      });
    });
  }

  addBearing() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(currentClient['latitude'].latitude,
                currentClient['longitude'].longitude
            ),
            bearing: currentBearing == 360.0 ? currentBearing : currentBearing + 90.0,
            zoom: 17.0,
            tilt: 45.0
        )
    )
    ).then((val) {
      setState(() {
        if(currentBearing == 360.0) {}
        else {
          currentBearing = currentBearing + 90.0;
        }
      });
    });
  }

  removeBearing() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(currentClient['latitude'].latitude,
                currentClient['longitude'].longitude
            ),
            bearing: currentBearing == 0.0 ? currentBearing : currentBearing - 90.0,
            zoom: 17.0,
            tilt: 45.0
        )
    )
    ).then((val) {
      setState(() {
        if(currentBearing == 0.0) {}
        else {
          currentBearing = currentBearing - 90.0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Map Demo'),
        ),
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height - 80.0,
                    width: double.infinity,
                    child: 
                    mapToggle? 
                    GoogleMap(
                      onMapCreated: onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(position!.latitude.toDouble(),position!.longitude.toDouble())),
                      markers: Set<Marker>.of(
                          client.values
                      ),
                    )
                        : Center(
                          child: Text(
                          'Loading.. Please wait..',
                          style: TextStyle(fontSize: 20.0),
                        ))),
                Positioned(
                    top: MediaQuery.of(context).size.height - 250.0,
                    left: 10.0,
                    child: Container(
                        height: 125.0,
                        width: MediaQuery.of(context).size.width,
                        child: clientsToggle
                            ? ListView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(8.0),
                          children: clients.map((element) {
                            return clientCard(element);
                          }).toList(),
                        )
                            : Container(height: 1.0, width: 1.0))),
                resetToggle
                    ? Positioned(
                    top: MediaQuery.of(context).size.height -
                        (MediaQuery.of(context).size.height -
                            50.0),
                    right: 15.0,
                    child: FloatingActionButton(
                      onPressed: resetCamera,
                      mini: true,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.refresh),
                    ))
                    : Container(),
                resetToggle
                    ? Positioned(
                    top: MediaQuery.of(context).size.height -
                        (MediaQuery.of(context).size.height -
                            50.0),
                    right: 60.0,
                    child: FloatingActionButton(
                        onPressed: addBearing,
                        mini: true,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.rotate_left
                        ))
                )
                    : Container(),
                resetToggle
                    ? Positioned(
                    top: MediaQuery.of(context).size.height -
                        (MediaQuery.of(context).size.height -
                            50.0),
                    right: 110.0,
                    child: FloatingActionButton(
                        onPressed: removeBearing,
                        mini: true,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.rotate_right)
                    ))
                    : Container()
              ],
            )
          ],
        ));
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}
  @override
  Widget build(BuildContext context) {
    return Container();
  }

*/