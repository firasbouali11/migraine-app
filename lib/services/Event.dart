import 'dart:io';
import "package:path/path.dart";
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Event {
  final String title;
  final String? comments;
  final String start_date;
  final String? end_date;
  final String cause;
  final String severity;
  final int? id;

  Event(
      {this.id,
      required this.title,
      required this.start_date,
      this.end_date,
      required this.cause,
      required this.severity,
      this.comments});

  factory Event.fromMap(Map<String, dynamic> json) => Event(
    id: json["id"],
    title: json["title"],
    start_date: json["start_date"],
    end_date: json["end_date"],
    comments: json["comments"],
    cause: json["cause"],
    severity: json["severity"],
  );

  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "title": title,
      "start_date": start_date,
      "end_date": end_date,
      "comments": comments,
      "cause": cause,
      "severity": severity,
    };
  }

  @override
  String toString() {
    return "${title == "" ? 'No name':title}  (Start Time: ${start_date.split(" ")[1]})";
  }
}

class EventHelper{

  EventHelper._privateConstructor();
  static final EventHelper instance = EventHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initEvents();

  Future _initEvents() async {
    Directory doc = await getApplicationDocumentsDirectory();
    String path = join(doc.path, "events.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      "create table events(id integer primary key, title text, start_date text, end_date text, cause text, severity text, comments text)"
    );
  }

  Future<List<Event>> getEvents() async{
    Database db = await instance.database;
    var events = await db.query("events");
    List<Event> eventsList = events.isNotEmpty ? events.map((e) => Event.fromMap(e)).toList() : [];
    return eventsList;
  }

  Future<int> addEvent(Event event) async{
    Database db = await instance.database;
    return await db.insert("events", event.toMap());
  }

  Future<int> deleteEvent(int id) async{
    Database db = await instance.database;
    return await db.delete("events", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateEvent(Event event) async {
    Database db = await instance.database;
    return await db.update("events", event.toMap());
  }


}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

// data
final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year + 9, kToday.month, kToday.day);
