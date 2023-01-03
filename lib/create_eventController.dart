import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motimeter/create_event.dart';
import 'package:motimeter/redirects.dart';

class CreateEventController {

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
        if (newDate.isAfter(CreateEventState.endDateTime) || newDate.isAtSameMomentAs(CreateEventState.endDateTime)) {
          return;
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
        if (newDate.isBefore(CreateEventState.startDateTime) || newDate.isAtSameMomentAs(CreateEventState.startDateTime)) {
          return;
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

  static createEvent(context, host, eventName, eventPassword, eventStart, eventEnd) {
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
        "end": eventEnd
      });
      Redirects.allEvents(context);
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
    }
  }

  static Future searchImage() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img == null) return;
      CreateEventState.image = File(img.path);
    } on PlatformException catch (e) {
      print(e.message.toString());
    }
  }

  static Future takeImage() async {
    await ImagePicker().pickImage(source: ImageSource.camera);
  }
}