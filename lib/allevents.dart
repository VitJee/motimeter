import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:motimeter/alleventsController.dart';
import 'package:motimeter/redirects.dart';
import 'package:motimeter/userController.dart';

class AllEvents extends StatefulWidget {
  const AllEvents({super.key});

  @override
  State<AllEvents> createState() => AllEventsState();
}

class AllEventsState extends State<AllEvents> {
  final double paddingLeft = 50;
  final double paddingRight = 50;
  final double paddingTop = 50;
  final double paddingBottom = 10;

  @override
  initState() {
    setState(() {});
    super.initState();
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Redirects.createEvent(context);
        },
        child: const Icon(Icons.add),
      ),
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
        child: FirebaseAnimatedList(
          query: AllEventsController.readAllEvents(),
          itemBuilder: (context, snapshot, animation, index) {
            var alreadyJoined = false;
            late List<dynamic> members = snapshot.child("members").value as List<dynamic>;
            if (snapshot != null) {
              for (var member in members) {
                if (member.toString() == FirebaseAuth.instance.currentUser!.email.toString()) {
                  alreadyJoined = true;
                }
              }
            }
            return Card(
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.event),
                title: Text(snapshot.child("name").value.toString()),
                trailing: alreadyJoined == true 
                    ? AllEventsController.detailWidget(context, snapshot.key.toString())
                    : AllEventsController.joinWidget(
                  context,
                  snapshot.key.toString(),
                  snapshot.child("name").value.toString(),
                  snapshot.child("password").value.toString()
                ),
              ),
            );
          },
        )
      ),
    );
  }
}