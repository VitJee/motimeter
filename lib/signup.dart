import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignUpState();
}

class SignUpState extends State<SignUp> {

  final double paddingLeft = 50;
  final double paddingRight = 50;
  final double paddingTop = 50;
  final double paddingBottom = 10;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  signUp() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Center(
        child: Column(
          children: [
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
              child: TextField(
                controller: confirmPassController,
                decoration: const InputDecoration(
                    labelText: "Confirm Password",
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
                    ElevatedButton(
                        onPressed: signUp,
                        child: const Text("Sign up")
                    )
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}