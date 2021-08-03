import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'AuthService.dart';




class GoogleSingInProvider extends ChangeNotifier {
  final authService = AuthService();
  //static const String id = "GoogleSingIn";
  final googleSignIn = GoogleSignIn();
  Stream <User?> get currentUser => authService.currentUser;
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  OAuthCredential? oAuthCredential;


  Future googleLogin() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    final googleUser= await googleSignIn.signIn();
    if (googleUser == null){
      return;
    }
    _user=googleUser;


    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken : googleAuth.idToken,
    );
    oAuthCredential =credential;



    //final  gUser=  FirebaseAuth.instance.signInWithCredential(credential);
    final resultUser = await authService.signInWithCredential(credential);
    print('${resultUser.user!.displayName}');
        notifyListeners();
   // _GLoginState().googleLoginUser();



  }
  Future googleLogout() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    final googleUser= await googleSignIn.signOut();
    if (googleUser == null){
      return;
    }
    _user=googleUser;


    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken : googleAuth.idToken,
    );

    final resultUser = await authService.signInWithCredential(credential);
    print('${resultUser.user!.displayName}');
    notifyListeners();
  }
  logout(){
    authService.logout();
  }

}

