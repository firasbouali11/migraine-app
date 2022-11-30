import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:migraine_app/services/Event.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import "package:collection/collection.dart";
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Holder{
   late int key;
   late int value;

   Holder({required this.key, required this.value});

   @override
  String toString() {
    // TODO: implement toString
    return "($key, $value)";
  }
}

class Graphic extends StatefulWidget {
  const Graphic({Key? key}) : super(key: key);

  @override
  State<Graphic> createState() => _GraphicState();
}

class _GraphicState extends State<Graphic> {
  List<Event> events = [];
   void getEvents() async {
    List<Event> allEvents =  await EventHelper.instance.getEvents();
    setState((){
      events = allEvents;
    });
  }

  int calculateEventOccurenceByCause(String cause){
    var a = groupBy(events, (data) => data.cause);
    return a[cause]!.length;
  }

  List<String> getExistingCauses(){
    var a = groupBy(events, (data) => data.cause);
    return a.keys.toList();
  }


  List<Holder> calc(){
     var today_year = DateTime.now().year;
     var today_month = DateTime.now().month;
     List<Event> events_by_month = [];
     for(int i= 0; i< events.length; i++) {
       var m = events[i].start_date.split("-")[1];
       var y = events[i].start_date.split("-")[0];
       if(int.parse(m) == today_month && int.parse(y) == today_year) {
         events_by_month.add(events[i]);
       }
     }
     var days = 0;
     if(today_month <=7 && today_month.isEven) {
       days = 30;
     } else if(today_month <=7 && today_month.isOdd) {
       days = 31;
     } else if(today_month.isOdd){
       days = 30;
     } else {
       days = 31;
     }
     List<Holder> tab = [];
     for(int i =1; i<= days; i++) {
       tab.add(Holder(key: i,value: 0));
     }
     for (var e in events_by_month) {
       tab[int.parse(e.start_date.split("-")[2].split(" ")[0])] = Holder(key: int.parse(e.start_date.split("-")[2].split(" ")[0]) - 1,value: int.parse(e.severity));
     }
     return tab;
  }

  List<String> getAllDates(){
    var a = events.map((e) => e.start_date).toList();
    var b = events.map((e) => e.end_date!).toList();
    a.addAll(b);
    return a;
  }

  @override
  void initState() {
    getEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(padding: EdgeInsets.symmetric(vertical: 30),child: Text("Total Migraines: ${events.length}")),
              SfCircularChart(
                title: ChartTitle(text: "Migraines by Cause"),
                series: [
                  PieSeries(
                      explode: true,
                      explodeIndex: 0,
                      dataSource: getExistingCauses(),
                      xValueMapper: (cause, _) => cause ,
                      yValueMapper: (cause, _) => calculateEventOccurenceByCause(cause),
                      dataLabelMapper: (cause, _) => cause,
                      dataLabelSettings: const DataLabelSettings(isVisible: true)
                  )
                ],
              ),
              SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: "Migraines by Severity"),
                series: [
                  LineSeries(
                      dataSource: events,
                      xValueMapper: (event, _) => "${event.title} (${event.id})" ,
                      yValueMapper: (event, _) => int.parse(event.severity)
                  )
                ],
              ),
              SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: "Migraines by Month"),
                series: [
                  ColumnSeries(
                      dataSource: calc(),
                      xValueMapper: (event, _) => event.key ,
                      yValueMapper: (event, _) => event.value
                  )
                ],
              ),
            ],
          ),
        )
    );
  }
}
