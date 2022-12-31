import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motimeter/allevents.dart';
import 'package:motimeter/redirects.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AllEvents();
            } else {
              return MyHomePage();
            }
          },
        ),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final double paddingLeft = 50;
  final double paddingRight = 50;
  final double paddingTop = 50;
  final double paddingBottom = 10;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passController.text.trim()
      );
    } catch (e) {
      print(e);
    }
  }

  signUp() {
    Redirects.signUp(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Motimeter"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: signIn,
                      child: const Text("Sign in")
                  ),
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