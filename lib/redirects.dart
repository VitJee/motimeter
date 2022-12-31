import 'package:flutter/material.dart';
import 'package:motimeter/signup.dart';

class Redirects {
  /*static void signOut(context) {
    GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
          return Login();
        }));
  }*/

  static void signUp(context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
      return SignUp();
    }));
  }
}