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
    return _getScaffold(futureRaces);
  }
}



Scaffold _getScaffold(Future<List<Map<String, dynamic>>> futureRaces)
{
  return Scaffold(
    appBar: AppBar(
      title: const Text('Available races'),
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
                          UI_RaceClasses(classes[index]["_id"]),
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