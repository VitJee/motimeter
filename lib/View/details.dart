import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motimeter/Model/chartdata.dart';
import 'package:motimeter/Controller/redirects.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Details extends StatefulWidget {
  Details({required this.comments, required this.ratings, required this.eventName});
  List<dynamic> comments;
  List<dynamic> ratings;
  String eventName;

  @override
  State<StatefulWidget> createState() => DetailsState(comments: comments, ratings: ratings, eventName: eventName);
}

class DetailsState extends State<Details> {
  DetailsState({required this.comments, required this.ratings, required this.eventName});
  List<dynamic> comments;
  List<dynamic> ratings;
  String eventName;

  @override
  Widget build(BuildContext context) {
    List<int> ratingValues = [];
    List<ChartData> data = [ChartData(0, 0)];

    for (var str in ratings) {
      List<String> strSplit = str.toString().split(":");
      ratingValues.add(int.parse(strSplit[1]));
    }
    for (int index = 0; index < ratingValues.length; index++) {
      data.add(ChartData(index + 1, ratingValues[index]));
    }

    print("ratings: " + ratings.toString());
    print("Comments: " + comments.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("$eventName"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text("Mood History:", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          AspectRatio(
              aspectRatio: 2,
              child: SfCartesianChart(
                series: <ChartSeries>[
                  LineSeries<ChartData, int>(
                    dataSource: data,
                    xValueMapper: (ChartData data, _) => data.index,
                    yValueMapper: (ChartData data, _) => data.rating,
                  )
                ],
                primaryXAxis: NumericAxis(
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  interval: 1,
                ),
                primaryYAxis: NumericAxis(
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    minimum: -10,
                    maximum: 10
                ),
              )
          ),
          const Text("Comments:", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text(comments[index].toString()),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}