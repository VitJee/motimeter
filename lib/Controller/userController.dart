import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motimeter/Controller/redirects.dart';
import 'package:motimeter/View/signin.dart';
import 'package:motimeter/View/signup.dart';

class UserController {

  static signIn(context, String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim()
      );
      Redirects.allEvents(context);
      SignInPageState.message = "";
    } on FirebaseAuthException catch (e) {
      SignInPageState.message = e.message.toString();
    }
  }

  static signUp(context, String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password
      );
      Redirects.allEvents(context);
      SignUpState.message = "";
    } on FirebaseAuthException catch (e) {
      SignUpState.message = e.message.toString();
      SignUpState.messageColor = Colors.red;
    }
  }

  static signOut(context) {
    FirebaseAuth.instance.signOut();
    Redirects.signIn(context);
  }
}