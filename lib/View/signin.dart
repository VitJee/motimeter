import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:motimeter/View/allevents.dart';
import 'package:motimeter/firebase_options.dart';
import 'package:motimeter/Controller/redirects.dart';
import 'package:motimeter/Controller/userController.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  @override
  Widget build(BuildContext context) => SignInPage();
}

class SignInPage extends StatefulWidget {
  SignInPage({super.key});

  @override
  State<SignInPage> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final double paddingLeft = 50;
  final double paddingRight = 50;
  final double paddingTop = 50;
  final double paddingBottom = 10;
  static String message = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Motimeter"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(paddingLeft, paddingTop, paddingRight, paddingBottom),
              child: const Text("Login", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(paddingLeft, paddingTop, paddingRight, paddingBottom),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.blue)
                  )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(paddingLeft, 0, paddingRight, paddingBottom),
              child: TextField(
                controller: passController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: "Password",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.blue)
                    )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(paddingLeft, 0, paddingRight, paddingBottom),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: ElevatedButton(
                        onPressed: () async {
                          await UserController.signIn(context, emailController.text, passController.text);
                          setState(() {});
                        },
                        child: const Text("Sign-in"),
                      ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Redirects.signUp(context);
                        message = "";
                      },
                      child: const Text("Sign-up")
                  )
                ],
              )
            ),
            Text(message, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}