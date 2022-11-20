import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddMigraine extends StatefulWidget {
  const AddMigraine({Key? key}) : super(key: key);

  @override
  State<AddMigraine> createState() => _AddMigraineState();
}

class _AddMigraineState extends State<AddMigraine> {

  TextEditingController comment = TextEditingController();
  TextEditingController start_date = TextEditingController();
  TextEditingController end_date = TextEditingController();
  @override
  void initState() {
    start_date.text = DateTime.now().toString();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Migraine App"),
      ),
      body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 13),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Comments"
                ),
                controller: comment,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
              child: TextFormField(
                readOnly: true,
                onTap: (){
                  DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    maxTime: DateTime.now().add(Duration(days: 9000)),
                    onChanged: (date) {
                      setState(() {
                        start_date.text = date.toString();
                      });
                    },
                    onConfirm: (date) {
                      setState(() {
                        start_date.text = date.toString();
                      });
                    },
                    currentTime: DateTime.now(),
                    locale: LocaleType.en
                  );
                },
                decoration: const InputDecoration(
                    labelText: "Start Date"
                ),
                controller: start_date,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 13),
              child: TextFormField(
                readOnly: true,
                onTap: (){
                  DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime.now().add(Duration(days: 9000)),
                      onChanged: (date) {
                        setState(() {
                          end_date.text = date.toString();
                        });
                      },
                      onConfirm: (date) {
                        setState(() {
                          end_date.text = date.toString();
                        });
                      },
                      currentTime: DateTime.now().subtract(Duration(days: 2)),
                      locale: LocaleType.en
                  );
                },
                decoration: const InputDecoration(
                    labelText: "End Date"
                ),
                controller: end_date,
              ),
            ),
            ElevatedButton(
              child: Text("Create"),
              onPressed: (){},
            )
          ],
        )
    );
  }
}
