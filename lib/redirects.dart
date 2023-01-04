import 'package:flutter/material.dart';
import 'package:motimeter/allevents.dart';
import 'package:motimeter/createEvent.dart';
import 'package:motimeter/signin.dart';
import 'package:motimeter/signup.dart';

import 'detail.dart';

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

  static void allEvents(context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
      return AllEvents();
    }));
  }

  static void createEvent(context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
      return CreateEvent();
    }));
  }

  static void details(context, String eventKey) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
      return Detail(eventKey: eventKey);
    }));
  }
}