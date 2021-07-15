import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_location/locationp.dart';
import 'dart:ui';

import 'main.dart';
class Locationp extends StatefulWidget {
  static const String id = "LOCATIONP";
  final UserCredential user;
  const Locationp({ Key? key,  required this.user}):super(key: key);
  //const Locationp({Key? key}) : super(key: key);

  @override
  _LocationpState createState() => _LocationpState();
}

class _LocationpState extends State<Locationp> {

  final FirebaseAuth_auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callBack() async {
    //WidgetsFlutterBinding.ensureInitialized();
    //await Firebase.initializeApp();
    if (messageController.text.length > 0) {
      await _firestore.collection("messages").add({
        'text': messageController.text,
        'from': widget.user.credential,//changed from email to credential
        //'date': DateTime.now().toIso8601String().toString()
      });
      messageController.clear();
      scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 3000),
          curve: Curves.easeOut);
    }
  }
  //var _auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Hero(
          tag: 'logo',
          child: Container(
            height: 40,
            child: Image.asset("images/location_icon.png"),
          ),
        ),
        title: Text("My Location Room"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: (){
              //_auth.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
      body:
      //FutureBuilder(
        //future: _firestore.collection("messages").orderBy('date').snapshots(),
        //builder:( BuildContext context ,AsyncSnapshot  snapshot){switch()}
      //)
      SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection("messages").orderBy('date').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                      
                    );

                  }

                  List<DocumentSnapshot> docs = snapshot.data!.docs;

                  List<Widget> messages = docs.map((doc) => Message(
                    from: doc['from'],
                    text: doc['text'],
                    me: widget.user.credential == doc['from'])).toList();

                  return ListView(
                    controller: scrollController,
                    children: <Widget>[
                      ...messages,
                    ],
                  );
                },
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Enter your message ......",
                          border: const OutlineInputBorder()
                      ),
                      onSubmitted: (value) => callBack(),
                    ),
                  ),
                  SendButton(
                    text: 'Send',
                    callback: callBack,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class SendButton extends StatelessWidget {

  final String text;
  final VoidCallback callback;

  const SendButton({ Key? key, required this.text, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlatButton(
      color: Colors.orange,
      onPressed: callback,
      child: Text(text),
    );
  }
}

class Message extends StatelessWidget {

  final  String from;
  final  String text;
  final  bool me;

  const Message({ required this.from, required this.text, required this.me}) : super(key: null);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: me? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(from),
          Material(
            color: me ? Colors.teal : Colors.red,
            borderRadius: BorderRadius.circular(10),
            elevation: 6,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(
                  text
              ),
            ),
          )
        ],
      ),
    );
  }
}


