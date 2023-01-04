import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motimeter/createEvent.dart';
import 'package:motimeter/redirects.dart';

class CreateEventController {
  static const dbURL = "https://motimeter-98640-default-rtdb.europe-west1.firebasedatabase.app/";

  static Future pickDateTime(context, dateTime, startOrEnd) async {
    DateTime? date = await pickDate(context, dateTime);
    if (date == null) return;

    TimeOfDay? time = await pickTime(context, dateTime);
    if (time == null) return;

    switch (startOrEnd) {
      case true:
        final newDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute
        );
        if (newDate.isAtSameMomentAs(CreateEventState.endDateTime) ||
            newDate.isBefore(DateTime.now())) {
          CreateEventState.message = "Your start date must be after now and before the end date!";
          return;
        } else if (newDate.isAfter(CreateEventState.endDateTime)) {
          CreateEventState.startDateTime = newDate;
          CreateEventState.endDateTime = newDate;
          CreateEventState.message = "";
        }
        CreateEventState.startDateTime = newDate;
        break;
      case false:
        final newDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute
        );
        if (newDate.isAtSameMomentAs(CreateEventState.startDateTime) ||
            newDate.isBefore(DateTime.now())) {
          CreateEventState.message = "Your end date must be after now and after the start date!";
          return;
        } else if (newDate.isBefore(CreateEventState.startDateTime)) {
          CreateEventState.startDateTime = newDate;
          CreateEventState.endDateTime = newDate;
          CreateEventState.message = "";
        }
        CreateEventState.endDateTime = newDate;
        break;
    }
  }

  static Future<DateTime?> pickDate(context, dateTime) => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100)
  );

  static Future<TimeOfDay?> pickTime(context, dateTime) => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute)
  );

  static createEvent(context, host, eventName, eventPassword, eventStart, eventEnd) async {
    try {
      DatabaseReference db = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: "https://motimeter-98640-default-rtdb.europe-west1.firebasedatabase.app/"
      ).ref("events").push();
      db.set({
        "host": host,
        "name": eventName,
        "password": eventPassword,
        "start": eventStart,
        "end": eventEnd,
        "imgid": await createImgId(),
        "members": [host],
      });
      uploadFile();
      Redirects.allEvents(context);
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
    }
  }

  static createImgId() async {
    List<String> imgIds = await searchImgIds();
    List<String> numbers = "1234567890".split("");
    String ret;
    do {
      ret = "";
      for (int i = 0; i < 20; i++) {
        ret += numbers[Random().nextInt(10)];
      }
    } while (imgIds.contains(ret));
    return ret;
  }

  static searchImgIds() async {
    late List<DataSnapshot> events = [];
    List<String> imgIds = [];
    await FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: dbURL
    ).ref("events").get().then((value) => {
      events = value.children.toList(),
    });
    for (var snapshot in events) {
      imgIds.add(snapshot.child("imgid").value.toString());
    }
    return imgIds;
  }

  static uploadFile() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    if (CreateEventState.image == null) return;
    try {
      await storage.ref("pictures/bruh").putFile(CreateEventState.image!);
    } on FirebaseException catch (e) {
      print(e.message.toString());
    }
  }

  static searchImage() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img == null) return;
      CreateEventState.image = File(img.path);
    } on PlatformException catch (e) {
      print(e.message.toString());
    }
  }

  static takeImage() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.camera);
      if (img == null) return;
      CreateEventState.image = File(img.path);
    } on PlatformException catch (e) {
      print(e.message.toString());
    }
  }
}