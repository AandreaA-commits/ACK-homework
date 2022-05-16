import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './globals.dart';

Future<List<Map<String, dynamic>>> fetchAthletes(String classid, String raceid) async {
  final response = await http.get(Uri.parse('$apiUrl/results?id=$raceid&class=$classid'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load classes');
  }
}


class AthletesRoute extends StatefulWidget {
  final String classid;
  final String raceid;
  const AthletesRoute(this.classid, this.raceid, {Key? key}) : super(key: key);

  @override
  _AthletesRouteState  createState() => _AthletesRouteState();
}

class _AthletesRouteState extends State<AthletesRoute> {
  late Future<List<Map<String, dynamic>>> futureAthletes;

  @override
  void initState() {
    super.initState();
    futureAthletes = fetchAthletes(widget.classid, widget.raceid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('classifica degli atleti'),
      ),
      body: Center(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: futureAthletes,
          builder: (context, snapshot){
            if (snapshot.hasData) {
              var athletes = snapshot.data!;
              return ListView.builder(
                  itemCount: athletes.length,
                  itemBuilder: ((context, index) => Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color.fromRGBO(37, 7, 107, 1.0),),),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(athletes[index]["position"], style: TextStyle(fontSize: 15),),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(athletes[index]["surname"], style: TextStyle(fontSize: 15),),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(athletes[index]["name"], style: TextStyle(fontSize: 15),),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(athletes[index]["time"], style: TextStyle(fontSize: 15),),
                          ),
                        ]
                    )
                  )
                ));
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        )
      )

    );
  }
}
