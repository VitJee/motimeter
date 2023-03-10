import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motimeter/View/createEvent.dart';
import 'package:motimeter/Controller/redirects.dart';

class CreateEventController {
  static const dbURL = "https://motimeter-98640-default-rtdb.europe-west1.firebasedatabase.app/";

  static Future pickDateTime(context, dateTime, startOrEnd) async {
    DateTime? date = await pickDate(context, dateTime);
    if (date == null) return;

    TimeOfDay? time = await pickTime(context, dateTime);
    if (time == null) return;

    switch (startOrEnd) {
      case true:
        var newDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute
        );
        if (newDate.isBefore(DateTime.now())) {
          newDate = DateTime.now();
          if (CreateEventState.endDateTime.isBefore(newDate)) {
            CreateEventState.endDateTime = newDate;
          }
          CreateEventState.message = "You can't start an event in the past!";
        } else if (newDate.isAfter(CreateEventState.endDateTime)) {
          CreateEventState.endDateTime = newDate;
          CreateEventState.message = "Your end date must be after your start date!";
        } else {
          CreateEventState.message = "";
        }
        CreateEventState.startDateTime = newDate;
        break;
      case false:
        var newDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute
        );
        if (newDate.isBefore(CreateEventState.startDateTime)) {
          CreateEventState.message = "Your end date must be after the start date!";
          return;
        } else {
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

  static createEvent(context, host, eventName, eventPassword, eventStart, eventEnd, currentEmail) async {
    DateTime start = DateTime.parse(eventStart);
    if (start.isBefore(DateTime.now().subtract(const Duration(seconds: 1)))) start = DateTime.now();
    try {
      DatabaseReference db = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: dbURL
      ).ref("events").push();
      db.set({
        "host": host,
        "name": eventName,
        "password": eventPassword,
        "start": start.toString(),
        "end": eventEnd,
        "imgid": createImgId(),
        "members": [host],
        "moods": ["0:0"],
        "comments": [""]
      });
      uploadFile();
      Redirects.allEvents(context, currentEmail);
      CreateEventState.image = null;
    } on FirebaseException catch (e) {
      print(e.message.toString());
    }
  }

  static createImgId() {
    List<String> numbers = "1234567890".split("");
    String ret = "";
    for (int i = 0; i < 40; i++) {
      ret += numbers[Random().nextInt(10)];
    }
    return ret;
  }

  static uploadFile() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    if (CreateEventState.image == null) return;
    try {
      await storage.ref("pictures/${createImgId()}.jpg").putFile(CreateEventState.image!);
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