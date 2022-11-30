import 'dart:io';
import "package:path/path.dart";
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class User {
  final String name;
  final int? id;

  User(
      {this.id,
      required this.name});

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"]
  );

  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "name": name
    };
  }
}

class UserHelper{

  UserHelper._privateConstructor();
  static final UserHelper instance = UserHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initUser();

  Future _initUser() async {
    Directory doc = await getApplicationDocumentsDirectory();
    String path = join(doc.path, "users.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      "create table users(id integer primary key, name text)"
    );
  }

  Future<int> addUser(User user) async{
    Database db = await instance.database;
    return await db.insert("users", user.toMap());
  }

  Future<User?> getUser() async{
    Database db = await instance.database;
    var users =  await db.query("users");
    User? current_user = users.isNotEmpty ? User.fromMap(users.first) : null;
    return current_user;
  }
}