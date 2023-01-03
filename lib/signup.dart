import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motimeter/redirects.dart';
import 'package:motimeter/userController.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignUpState();
}

class SignUpState extends State<SignUp> {

  final double paddingLeft = 50;
  final double paddingRight = 50;
  final double paddingTop = 50;
  final double paddingBottom = 10;
  static String message = "";
  static Color messageColor = Colors.black;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  signUp() async {
    if (emailController.text.isNotEmpty) {
      if (passController.text.isNotEmpty && confirmPassController.text.isNotEmpty) {
        if (passController.text == confirmPassController.text) {
          if (passController.text.length > 5) {
            await UserController.signUp(context, emailController.text, passController.text);
          } else {
            message = "Your passwords needs to be atleast 6 Characters long!";
            messageColor = Colors.red;
          }
        } else {
          message = "Your passwords need to be identical!";
          messageColor = Colors.red;
        }
      } else {
        message = "You need to enter your password!";
        messageColor = Colors.red;
      }
    } else {
      message = "You need to enter your Email!";
      messageColor = Colors.red;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Redirects.signIn(context);
              message = "";
              setState(() {});
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: const Text("Motimeter"),
          centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(paddingLeft, paddingTop, paddingRight, paddingBottom),
              child: const Text("Create Account", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
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
                        onPressed: () {
                          signUp();
                        },
                        child: const Text("Sign-up")
                    )
                  ],
                )
            ),
            Text(message, style: TextStyle(color: messageColor)),
          ],
        ),
      ),
    );
  }
}