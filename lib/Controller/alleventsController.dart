import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motimeter/Controller/redirects.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AllEventsController {
  static const dbURL = "https://motimeter-98640-default-rtdb.europe-west1.firebasedatabase.app/";

  static Query readAllEvents() {
    final events = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: dbURL
    ).ref("events");
    return events;
  }

  static bool eventFinished(String eventKey, DateTime eventEnd) {
    if (DateTime.now().isAfter(eventEnd)) {
      return true;
    } else {
      return false;
    }
  }

  static double avgMood(List<dynamic> moods) {
    List<int> moodValues = [];
    double avgMood = 0;

    for (var str in moods) {
      List<String> strSplit = str.toString().split(":");
      moodValues.add(int.parse(strSplit[1]));
    }
    for (int index = 1; index < moodValues.length; index++) {
      avgMood += moodValues[index];
    }
    if (avgMood == 0) return 0;
    avgMood = avgMood / (moodValues.length - 1);
    return avgMood;
  }

  static joinEvent(String eventKey, String currentEmail) async {
    late List<dynamic> members = [];
    var membersRef = await FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: dbURL
    ).ref("events/$eventKey");
    await membersRef.child("members").get().then((snapshot) => {
      members = snapshot.value as List<dynamic>
    });
    members = [...members, currentEmail];
    await membersRef.update({
      "members": members
    });
  }

  static addComment(String eventKey, String comment, String currentEmail) async {
    List<dynamic> comments = [];
    var membersRef = await FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: dbURL
    ).ref("events/$eventKey");
    await membersRef.child("comments").get().then((snapshot) => {
      comments = snapshot.value as List<dynamic>
    });
    comments = [...comments, "$currentEmail:$comment"];
    if (comments[0] == "") {
      comments.removeAt(0);
    }
    await membersRef.update({
      "comments": comments
    });
  }

  static addMood(String eventKey, int moods, String currentEmail) async {
    late List<dynamic> ratings = [];
    var membersRef = await FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: dbURL
    ).ref("events/$eventKey");
    await membersRef.child("moods").get().then((snapshot) => {
      ratings = snapshot.value as List<dynamic>
    });
    ratings = [...ratings, "$currentEmail:$moods"];
    if (ratings[0] == "-100") {
      ratings.removeAt(0);
    }
    await membersRef.update({
      "moods": ratings
    });
  }

  static joinWidget(context, String eventKey, String eventName, String eventPassword, String currentEmail) {
    TextEditingController passController = TextEditingController();
    return ElevatedButton(
      onPressed: () {
        String message = "";
        showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                title: Text("Enter Password for: $eventName"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: passController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 3)
                          )
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (passController.text == eventPassword) {
                          setState(() {
                            message = "";
                          });
                          joinEvent(eventKey, currentEmail);
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            message = "The password is wrong";
                          });
                        }
                      },
                      child: const Text("Enter"),
                    ),
                    Text(message, style: const TextStyle(color: Colors.red))
                  ],
                )
            ),
          )
        );
      },
      child: const Text("Join"),
    );
  }
}