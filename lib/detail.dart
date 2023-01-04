import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motimeter/detailController.dart';

class Detail extends StatefulWidget {
  Detail({required this.eventKey});
  String eventKey;

  @override
  State<StatefulWidget> createState() => DetailState(eventKey: eventKey);
}

class DetailState extends State<Detail> {
  DetailState({required this.eventKey});
  String eventKey;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Name")
      ),
    );
  }
}