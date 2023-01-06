import 'dart:io';

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:motimeter/Controller/alleventsController.dart';
import 'package:motimeter/Controller/redirects.dart';
import 'package:motimeter/Controller/userController.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AllEvents extends StatefulWidget {
  const AllEvents({super.key, required this.currentEmail});
  final String currentEmail;

  @override
  State<AllEvents> createState() => AllEventsState(currentEmail: currentEmail);
}

class AllEventsState extends State<AllEvents> {
  AllEventsState({required this.currentEmail});
  final double paddingLeft = 50;
  final double paddingRight = 50;
  final double paddingTop = 50;
  final double paddingBottom = 10;
  bool switchMode = false;
  late final img;
  final String currentEmail;

  @override
  initState() {
    img = getPicture("bruh");
    setState(() {});
    super.initState();
  }

  commentWidget(context, String eventKey, DateTime eventStart, DateTime eventEnd) {
    if (DateTime.now().isAfter(eventStart)) {
      return ElevatedButton(
        onPressed: () {
          if (DateTime.now().isAfter(eventEnd)) {
            showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("This event is over."),
                );
              },
            );
            setState(() {});
          } else {
            showDialog(
              context: context,
              builder: (context) {
                TextEditingController comment = TextEditingController();
                double rating = 0;
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: const Text("Comment/Mood"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: comment,
                            decoration: const InputDecoration(labelText: "Comment"),
                          ),
                          Slider(
                            min: -10,
                            max: 10,
                            value: rating,
                            onChanged: (double value) {
                              setState(() {
                                rating = value;
                              });
                            },
                            divisions: 20,
                          ),
                          Text(rating.toString())
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if (comment.text.isNotEmpty) {
                              AllEventsController.addComment(eventKey, comment.text, currentEmail);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("Comment"),
                        ),
                        TextButton(
                          onPressed: () {
                            AllEventsController.addMood(eventKey, rating.toInt(), currentEmail);
                            Navigator.pop(context);
                          },
                          child: const Text("Mood"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          }
        },
        child: const Text("Comment/Mood"),
      );
    } else {
      return const ElevatedButton(
        onPressed: null,
        child: Text("Comment/Mood"),
      );
    }
  }

  finishedWidget(context, List<dynamic> moods, List<dynamic> comments, String eventName) {
    return ElevatedButton(
      onPressed: () {
        Redirects.details(context, comments, moods, eventName);
      },
      child: const Text("Finished"),
    );
  }

  getPicture(String eventImgId) async {
    return await FirebaseStorage.instance.ref("pictures/$eventImgId").getDownloadURL();
  }

  PopupMenuButton getMenuWidget() {
    String eventOrArchive = "";
    if (switchMode == true) {
      eventOrArchive = "Events";
    } else {
      eventOrArchive = "Archive";
    }
    return PopupMenuButton(
      itemBuilder: (context) => [
        const PopupMenuItem(value: 1, child: Text("Refresh")),
        PopupMenuItem(value: 2, child: Text(eventOrArchive)),
        const PopupMenuItem(value: 3, child: Text("Sign-out")),
      ],
      onSelected: (value) {
        switch (value) {
          case 1:
            break;
          case 2:
            switchMode = !switchMode;
            break;
          case 3:
            Redirects.signIn(context);
            break;
        }
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Redirects.createEvent(context, currentEmail);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: switchMode == false ? const Text("Motimeter - Events") : const Text("Motimeter - Archive"),
        centerTitle: true,
        actions: [
          getMenuWidget(),
          const SizedBox(width: 15),
        ],
      ),
      body: Center(
        child: FirebaseAnimatedList(
          query: AllEventsController.readAllEvents(),
          itemBuilder: (context, snapshot, animation, index) {
            var eventKey = snapshot.key.toString();
            var eventStart = DateTime.parse(snapshot.child("start").value.toString());
            var eventEnd = DateTime.parse(snapshot.child("end").value.toString());
            var eventName = snapshot.child("name").value.toString();
            var eventPassword = snapshot.child("password").value.toString();
            var eventImgId = snapshot.child("imgid").value.toString();
            var comments = snapshot.child("comments").value as List<dynamic>;
            var moods = snapshot.child("moods").value as List<dynamic>;
            List<dynamic> members = snapshot.child("members").value as List<dynamic>;

            if (!switchMode) {
              if (DateTime.now().isBefore(eventEnd)) {
                if (members.contains(currentEmail)) {
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      leading: /*img != null ? Image.network(getPicture(eventImgId)) :*/ const Icon(Icons.event),
                      title: Text(snapshot.child("name").value.toString()),
                      subtitle: Text("From ${snapshot.child("start").value.toString()} till ${snapshot.child("end").value.toString()} avg. mood: ${AllEventsController.avgMood(snapshot.child("moods").value as List<dynamic>)}"),
                      trailing: commentWidget(context, eventKey, eventStart, eventEnd),
                    ),
                  );
                } else {
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      leading: /*img != null ? Image.network(getPicture(eventImgId)) :*/ const Icon(Icons.event),
                      title: Text(snapshot.child("name").value.toString()),
                      subtitle: Text("From ${snapshot.child("start").value.toString()} till ${snapshot.child("end").value.toString()} avg. mood: ${AllEventsController.avgMood(snapshot.child("moods").value as List<dynamic>)}"),
                      trailing: AllEventsController.joinWidget(context, eventKey, eventName, eventPassword, currentEmail),
                    ),
                  );
                }
              } else {
                return const SizedBox.shrink();
              }
            } else {
              if (DateTime.now().isAfter(eventEnd)) {
                if (members.contains(currentEmail)) {
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      leading: /*img != null ? Image.network(getPicture(eventImgId)) :*/ const Icon(Icons.event),
                      title: Text(snapshot.child("name").value.toString()),
                      subtitle: Text("From ${snapshot.child("start").value.toString()} till ${snapshot.child("end").value.toString()} avg. mood: ${AllEventsController.avgMood(snapshot.child("moods").value as List<dynamic>)}"),
                      trailing: finishedWidget(context, moods, comments, eventName),
                    ),
                  );
                }
                return const SizedBox.shrink();
              } else {
                return const SizedBox.shrink();
              }
            }
          },
        ),
      ),
    );
  }
}