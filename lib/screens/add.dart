import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:migraine_app/services/Event.dart';


class AddMigraine extends StatefulWidget {
  const AddMigraine({Key? key}) : super(key: key);

  @override
  State<AddMigraine> createState() => _AddMigraineState();
}

class _AddMigraineState extends State<AddMigraine> {

  TextEditingController comment = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController start_date = TextEditingController();
  TextEditingController end_date = TextEditingController();
  final List<String> causes = [
    "No Idea", "Cold Air", "Lack of Sleep"
  ];
  late String cause;
  late String severity;
  int? id;
  bool test = true;


  @override
  void initState() {
    start_date.text = DateTime.now().toString().split(".")[0];
    cause = causes.first;
    severity = "1";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Event?;
    if(args != null && test) {
      test = false;
      severity = args.severity;
      cause = args.cause;
      start_date.text = args.start_date;
      end_date.text = args.end_date != null ? args.end_date! : "";
      title.text = args.title;
      comment.text = args.comments != null ? args.comments! : "";
      id = args.id;
    }

      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Migraine App"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: "Title"),
                    controller: title,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: "Comments"),
                    controller: comment,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                  child: TextFormField(
                    readOnly: true,
                    onTap: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime.now().add(const Duration(days: 9000)),
                          onChanged: (date) {
                            setState(() {
                              start_date.text = date.toString().split(".")[0];
                            });
                          }, onConfirm: (date) {
                            setState(() {
                              start_date.text = date.toString().split(".")[0];
                            });
                          }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    decoration: const InputDecoration(labelText: "Start Date"),
                    controller: start_date,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                  child: TextFormField(
                    readOnly: true,
                    onTap: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime.now().add(const Duration(days: 9000)),
                          onChanged: (date) {
                            setState(() {
                              end_date.text = date.toString().split(".")[0];
                            });
                          }, onConfirm: (date) {
                            setState(() {
                              end_date.text = date.toString().split(".")[0];
                            });
                          },
                          currentTime: DateTime.now().subtract(const Duration(days: 2)),
                          locale: LocaleType.en);
                    },
                    decoration: const InputDecoration(
                        labelText: "End Date",
                        labelStyle: TextStyle(color: Colors.black)
                    ),
                    controller: end_date,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Causes of migraine", textAlign: TextAlign.start,),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: cause,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            cause = value!;
                          });
                        },
                        items: causes
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Severity", textAlign: TextAlign.start,),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: severity,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            severity = value!;
                          });
                        },
                        items: ["1","2","3","4","5"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  child: Text(args != null ? "Update" : "Create"),
                  onPressed: () async {
                    if(args == null){
                      Event event = Event(
                          title: title.text,
                          comments: comment.text,
                          start_date: start_date.text,
                          end_date: end_date.text,
                          cause: cause,
                          severity: severity
                      );
                      await EventHelper.instance.addEvent(event).then((value) =>
                      {Navigator.pop(context)});
                    } else {
                      Event event = Event(
                          title: title.text,
                          comments: comment.text,
                          start_date: start_date.text,
                          end_date: end_date.text,
                          cause: cause,
                          severity: severity,
                          id: id
                      );
                      await EventHelper.instance.updateEvent(event).then((value) =>
                      {Navigator.pop(context)});
                    }
                  },
                )
              ],
            ),
          ));
    }
}
