

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import 'googleSign.dart';
import 'main.dart';
import 'mapx.dart';

class HomeGoogle extends StatefulWidget {
  const HomeGoogle({Key? key}) : super(key: key);
  static const String id = "HomeGoogle";

  @override
  _HomeGoogleState createState() => _HomeGoogleState();
}

class _HomeGoogleState extends State<HomeGoogle> {

   late StreamSubscription<User> loginStateSubscription;
  @override
  void initState() {

    var provider= Provider.of<GoogleSingInProvider>(context, listen: false);
    loginStateSubscription = provider.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context).pushNamed(MyHomePage.id);
      }
    }) as StreamSubscription<User>;
    super.initState();
      }


  @override
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final provider= Provider.of<GoogleSingInProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Logged In By Google"),
        ),
        body: Center(
        child:StreamBuilder<User?>(
            stream: provider.currentUser,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(snapshot.data!.displayName.toString(), style: TextStyle(fontSize: 35),),
                  SizedBox(
                    height: 10,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data!.photoURL.toString()),
                    radius: 60,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  CustomButton(
                    text: 'Press to Continue',
                    callback: () async{

                        final provider= Provider.of<GoogleSingInProvider>(context, listen: false);
                        //provider.googleLogin();
                        await provider.googleLogin();
                        Navigator.of(context).pushNamed(MapLocation.id);
                        }
                       ),
                  SizedBox(
                    height: 10,
                  ),
                  SignInButton(buttonType: ButtonType.google,
                      btnText: 'Sign Out of Google ',
                      buttonSize: ButtonSize.small,
                      onPressed: () async {
                        await provider.googleLogout();
                        Navigator.of(context).pushNamed(MyHomePage.id);
                      }
                  ),


                ],

              );
            }

        )
    )
    );
  }
}





