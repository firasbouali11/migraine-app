import 'dart:collection';
import "package:collection/collection.dart";

import 'package:flutter/material.dart';
import 'package:migraine_app/services/Event.dart';
import 'package:table_calendar/table_calendar.dart';


class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<Event> _selectedEvents = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now() ;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  LinkedHashMap<DateTime, List<Event>> groups = LinkedHashMap();
  List<Event> events = [];

  void getEvents() async {
    List<Event> all_events =  await EventHelper.instance.getEvents();
    initData(all_events);
  }

  List<Event> _getEventsForDay(DateTime? day) {
    return groups[day] ?? [];
  }

  void initData(List<Event> all_events){
    setState((){
      events = all_events;
      groups = (events.isNotEmpty ? groupBy(events, (data) =>  DateTime.parse("${data.start_date.split(" ")[0]} 00:00:00.000Z")): <DateTime, List<Event>>{}) as LinkedHashMap<DateTime, List<Event>>;
      _selectedEvents = _getEventsForDay(DateTime.parse("${_selectedDay.toString().split(" ")[0]} 00:00:00.000Z"));
    });
  }

  @override
  void initState(){
    super.initState();
    getEvents();
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
      _selectedEvents = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });
    if (start != null && end != null) {
      _selectedEvents = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    getEvents();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/add");
              },
              child: const Text("Add +"),
            ),
          ),
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
                  itemCount: _selectedEvents.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      color: Colors.blue,
                      shadowColor: Colors.black,
                      elevation: 15,
                      child: ListTile(
                        onTap: () {
                          Event event = _selectedEvents[index];
                          Navigator.pushNamed(context, "/add", arguments: event);
                        },
                        onLongPress: (){
                          Event event = _selectedEvents[index];
                          EventHelper.instance.deleteEvent(event.id!);
                        },
                        title: Text('${index + 1}. ${_selectedEvents[index]}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
            ),
        ],
      );
  }
}