import 'package:flutter/material.dart';
import 'package:motimeter/View/allevents.dart';
import 'package:motimeter/View/details.dart';
import 'package:motimeter/View/createEvent.dart';
import 'package:motimeter/View/signin.dart';
import 'package:motimeter/View/signup.dart';

class Redirects {
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

  static void allEvents(context, String currentEmail) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
      return AllEvents(currentEmail: currentEmail);
    }));
  }

  static void createEvent(context, String currentEmail) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
      return CreateEvent(currentEmail: currentEmail);
    }));
  }

  static void details(context, List<dynamic> comments, List<dynamic> ratings, String eventName) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return Details(comments: comments, ratings: ratings, eventName: eventName);
    }));
  }
}