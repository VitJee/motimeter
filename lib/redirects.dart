import 'package:flutter/material.dart';
import 'package:motimeter/allevents.dart';
import 'package:motimeter/signin.dart';
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

  static void signIn(context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
      return SignIn();
    }));
  }

  static void signUp(context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
      return SignUp();
    }));
  }

  static void allEvents(context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
      return AllEvents();
    }));
  }
}