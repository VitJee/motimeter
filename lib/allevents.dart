import 'package:flutter/material.dart';

class AllEvents extends StatefulWidget {
  const AllEvents({super.key});

  @override
  State<AllEvents> createState() => AllEventsState();
}

class AllEventsState extends State<AllEvents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Events")),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Event"),
          ],
        ),
      ),
    );
  }
}