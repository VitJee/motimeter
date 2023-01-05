import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motimeter/createEventController.dart';
import 'package:motimeter/redirects.dart';

class CreateEvent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateEventState();
}

class CreateEventState extends State<CreateEvent> {
  final double paddingLeft = 50;
  final double paddingRight = 50;
  final double paddingTop = 50;
  final double paddingBottom = 10;
  static DateTime startDateTime = DateTime.now();
  static DateTime endDateTime = DateTime.now();
  static String message = "";
  static File? image;

  TextEditingController eventName = TextEditingController();
  TextEditingController eventPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    printImgId();
  }

  printImgId() async {
    print(await CreateEventController.createImgId());
  }

  @override
  Widget build(BuildContext context) {
    final startHours = startDateTime.hour.toString().padLeft(2, "0");
    final startMinutes = startDateTime.minute.toString().padLeft(2, "0");
    final startDays = startDateTime.day.toString().padLeft(2, "0");
    final startMonths = startDateTime.month.toString().padLeft(2, "0");
    final startYears = startDateTime.year.toString().padLeft(2, "0");

    final endHours = endDateTime.hour.toString().padLeft(2, "0");
    final endMinutes = endDateTime.minute.toString().padLeft(2, "0");
    final endDays = endDateTime.day.toString().padLeft(2, "0");
    final endMonths = endDateTime.month.toString().padLeft(2, "0");
    final endYears = endDateTime.year.toString().padLeft(2, "0");

    createEvent() {
      if (eventName.text.isNotEmpty && eventPassword.text.isNotEmpty) {
        if (eventPassword.text.length > 5) {
          CreateEventController.createEvent(
              context,
              FirebaseAuth.instance.currentUser?.email,
              eventName.text,
              eventPassword.text,
              startDateTime.toString(),
              endDateTime.toString());
        } else {
          message = "Your password needs to be atleast 6 characters long!";
        }
      } else {
        message = "You need a Name and a password for your event!";
      }
      setState(() {});
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createEvent();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Redirects.allEvents(context);
          },
        ),
        title: const Text("Motimeter - Create Group"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(paddingLeft, paddingTop, paddingRight, paddingBottom),
                child: image != null ? Image.file(image!, height: 160, width: 160) : FlutterLogo(size: 160),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, paddingTop, 2.5, paddingBottom),
                    child: ElevatedButton(
                      onPressed: () async {
                        await CreateEventController.searchImage();
                        setState(() {});
                      },
                      child: const Text("Search Image"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(2.5, paddingTop, 0, paddingBottom),
                    child: ElevatedButton(
                      onPressed: () async {
                        await CreateEventController.takeImage();
                        setState(() {});
                      },
                      child: const Text("Take Image"),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(paddingLeft, paddingTop, paddingRight, 5),
                child: TextField(
                  controller: eventName,
                  decoration: const InputDecoration(
                      labelText: "Event name",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.blue)
                      )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(paddingLeft, 5, paddingRight, 5),
                child: TextField(
                  controller: eventPassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: "Event Password",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.blue)
                      )
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: paddingLeft),
                    child: Text("Start:"),
                  ),
                  TextButton(
                    onPressed: () async {
                      await CreateEventController.pickDateTime(context, startDateTime, true);
                      setState(() {});
                    },
                    child: Text("$startDays/$startMonths/$startYears $startHours:$startMinutes"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: paddingLeft),
                      child: Text("End:")
                  ),
                  TextButton(
                    onPressed: () async {
                      await CreateEventController.pickDateTime(context, endDateTime, false);
                      setState(() {});
                    },
                    child: Text("$endDays/$endMonths/$endYears $endHours:$endMinutes"),
                  ),
                ],
              ),
              Text(message, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
            ],
          ),
        ),
      )
    );
  }
}