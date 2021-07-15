import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_location/login.dart';
import 'package:my_location/register.dart';
import 'dart:ui';

void main()
  async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'Locations Saver',
      theme: ThemeData(),
      initialRoute: MyHomePage.id,
      routes: {
        MyHomePage.id : (context)=> MyHomePage(),
        Registration.id: (context) => Registration(),
        Login.id:(context)=> Login(),
        //backlocation.id:(context)=> backlocation(),
        //Locationp.id : (context)=> Locationp(user: user),

      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  static const String id = "HOMESCREEN";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  width: 100,
                  child: Image.asset("images/location_icon.png"),
                ),
              ),

            ],
          ),
          Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
             Text(
            'My Location',
            style: TextStyle(fontSize: 30),
            ),
           ],
          ),
          SizedBox(
            height: 50,
          ),
          CustomButton(
            text: 'Log In',
            callback: (){
              Navigator.of(context).pushNamed(Login.id);

            },
          ),
          SizedBox(
            height: 10,
          ),
          CustomButton(
            text: 'Register',
            callback: () {
              Navigator.of(context).pushNamed(Registration.id);
            },
          ),
        ],
      ),

    );
  }

}

class CustomButton extends StatelessWidget {
  final VoidCallback callback;

  final String text;

  const CustomButton({Key? key,required this.callback,required this.text}):super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: const EdgeInsets.all(8),
         child: Material(
           color: Colors.white70,
           elevation: 6,
            borderRadius: BorderRadius.circular(30),
           child: MaterialButton(
              onPressed: callback,
               minWidth: 100,
                height: 45,
             child: Text(text),
    ),
         ),
    );
  }
  
}
