import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_location/main.dart';
import 'mapx.dart';

class Login extends StatefulWidget {
  static const String id = "LOGIN";
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String email;
  late String password;

  final FirebaseAuth _aut= FirebaseAuth.instance;

  Future<void> loginUser() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    UserCredential user = await _aut.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=> MapLocation(user: user),
    )
    );
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("My Location"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: 'logo',
              child: Container(
                width: 120,
                child: Image.asset("images/location_icon.png"),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => email = value,
            decoration: InputDecoration(
                hintText: "Enter your Email....",
                border: const OutlineInputBorder()
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            obscureText: true,
            onChanged: (value) => password = value,
            decoration: InputDecoration(
                hintText: "Enter your Password....",
                border: const OutlineInputBorder()
            ),
          ),
          SizedBox(
            height: 25,
          ),
          CustomButton(
            text: "Log in",
            callback: () async {
              await loginUser();
            },
          )
        ],
      ),
    );
  }
}
