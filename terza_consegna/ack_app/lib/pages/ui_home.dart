import 'ui_race.dart';
import 'package:flutter/material.dart';
import 'ui_raceclasses.dart';
import '../api.dart';

class UI_Home extends StatefulWidget {
  const UI_Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<UI_Home> {
  late Future<List<Map<String, dynamic>>> futureRaces;

  @override
  void initState() {
    super.initState();
    futureRaces = fetchRaces();
  }

  @override
  Widget build(BuildContext context) {
    return _getScaffold(futureRaces, context);
  }
}

showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("GRAZIE DAL TEAM ACK"),
    content: Text("Iqbal, Andrea, Fabio"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}



Scaffold _getScaffold(Future<List<Map<String, dynamic>>> futureRaces, BuildContext context)
{
  return Scaffold(
    appBar: AppBar(
      title: const Text('Available races'),
    ),

    drawer: Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Text('PROGETTO TCM', style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          ListTile(
            title: const Text('Credits'),
            onTap: () {
              // Update the state of the app.
              showAlertDialog(context);
              //Navigator.pop(context);
            },
          ),
        ],
      ),
    ),

    body: Center(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureRaces,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var classes = snapshot.data!;
            return ListView.builder(
              itemCount: classes.length,
              itemBuilder: ((context, index) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          //UI_RaceClasses(classes[index]["_id"]),
                          UI_Race(classes[index]["_id"], classes[index]["race_name"]),
                    ),
                  );
                },
                child: Text(classes[index]["race_name"]),
              )),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    ),
  );
}