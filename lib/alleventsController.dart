import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motimeter/redirects.dart';

class AllEventsController {
  static const dbURL = "https://motimeter-98640-default-rtdb.europe-west1.firebasedatabase.app/";

  static Query readAllEvents() {
    final events = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: dbURL
    ).ref("events");
    return events;
  }

  static joinEvent(String eventKey) async {
    late List<dynamic> members = [];
    var membersRef = await FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: dbURL
    ).ref("events/$eventKey");
    await membersRef.child("members").get().then((snapshot) => {
      members = snapshot.value as List<dynamic>
    });
    members.add(FirebaseAuth.instance.currentUser!.email);
    await membersRef.update({
      "members": members
    });
  }

  static detailWidget(context, String eventKey) {
    return TextButton(
      onPressed: () {
        Redirects.details(context, eventKey);
      },
      child: const Text("Detail", style: TextStyle(decoration: TextDecoration.underline)),
    );
  }

  static joinWidget(context, String eventKey, String eventName, String eventPassword) {
    TextEditingController passController = TextEditingController();
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Enter Password for: $eventName"),
            content: Column(
              children: [
                TextField(
                  controller: passController,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (passController.text == eventPassword) {
                      joinEvent(eventKey);
                    }
                  },
                  child: const Text("Enter"),
                )
              ],
            )
          )
        );
      },
      child: const Text("Join"),
    );
  }
}