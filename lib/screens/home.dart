import 'package:flutter/material.dart';
import 'package:migraine_app/tabs/calendar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List tabs = <Widget> [
    Calendar(),
    Text("Nodine")
  ];
  int current_index = 0;
  late Widget CurrentScreen = tabs[current_index];
  void _changeScreen(int index){
    setState(() {
      current_index = index;
      CurrentScreen = tabs[index];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              backgroundColor: Colors.green
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Other Home",
              backgroundColor: Colors.green
          ),
        ],
        currentIndex: current_index,
        onTap: _changeScreen,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Migraine App"),
      ),
      body: CurrentScreen,
    );
  }
}