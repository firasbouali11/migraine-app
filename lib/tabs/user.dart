import 'package:flutter/material.dart';
import 'package:migraine_app/services/User.dart';


class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  TextEditingController name = TextEditingController();
  late Future<User?> future_data;

  Future<User?> getUserFromDB() async {
    User? user = await UserHelper.instance.getUser();
    return user;
  }
  
  Future addUserToDB(User user) async {
    await UserHelper.instance.addUser(user);
  }
  
  @override
  void initState() {
    // TODO: implement initState
    future_data = getUserFromDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: future_data,
        builder: (context, current_user){
          return !current_user.hasData || current_user.connectionState == ConnectionState.none ?
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("You didn't create your account yet !!", style: TextStyle(fontSize: 30),textAlign: TextAlign.center,),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Just put your name", style: TextStyle(fontSize: 20),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                  child: TextFormField(
                    controller: name,
                    decoration: const InputDecoration(labelText: "Your Name"),
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    User user = User(
                        name: name.text
                    );
                    addUserToDB(user).then((value) => setState((){
                      future_data = getUserFromDB();
                    }));
                  }, child: const Text("Create"),
                )
              ],
            ),
          )
              :
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(100)
                  ),
                  alignment: Alignment.center,
                  child: Text(current_user.hasData ? current_user.data!.name[0].toUpperCase() : "", style: TextStyle(fontSize: 45),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 45),
                  child: Text(current_user.hasData ? current_user.data!.name : "", style: const TextStyle(fontSize: 20)),
                ),
              ],
            ),
          );
        }
    );
  }
}
