import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motimeter/usercontroller.dart';

class AllEvents extends StatefulWidget {
  const AllEvents({super.key});

  @override
  State<AllEvents> createState() => AllEventsState();
}

class AllEventsState extends State<AllEvents> {

  onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        UserController.signOut(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Motimeter - All Events"),
          centerTitle: true,
          actions: [
            PopupMenuButton<int>(
                onSelected: (item) => onSelected(context, item),
                itemBuilder: (context) => [
                  const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Sign-out")
                  ),
                ]
            )
          ],
      ),
      body: Center(
        child: Column(
          children: [
            Text("Event"),
          ],
        ),
      ),
    );
  }
}