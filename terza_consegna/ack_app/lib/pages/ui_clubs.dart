import 'dart:async';
import 'package:flutter/material.dart';
import '../api.dart';
import './ui_clubsresults.dart';
class UI_Clubs extends StatefulWidget {
  final String raceid;
  const UI_Clubs(this.raceid, {Key? key}) : super(key: key);

  @override
  _ClubsState createState() => _ClubsState();
}

class _ClubsState extends State<UI_Clubs> {
  late Future<List<Map<String, dynamic>>> futureClubs;

  @override
  void initState() {
    super.initState();
    futureClubs = fetchClubs(widget.raceid);
  }

  @override
  Widget build(BuildContext context) {
    return _getScaffold(futureClubs, widget.raceid);
  }
}

Scaffold _getScaffold(Future<List<Map<String, dynamic>>>  futureClubs, String raceid)
{
  return Scaffold(
    appBar: AppBar(
      title: const Text('Clubs'),
    ),
    body: Center(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureClubs,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var clubs = snapshot.data!;
            return ListView.builder(
              itemCount: clubs.length,
              itemBuilder: ((context, index) => ElevatedButton( //Text(classes[index])));
                child: Container(
                    width: double.infinity,
                    //margin: EdgeInsets.all(10),
                    child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(clubs[index]["id"], style: TextStyle(fontSize: 15),),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(clubs[index]["name"], style: TextStyle(fontSize: 15),),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(clubs[index]["country"], style: TextStyle(fontSize: 15),),
                          ),
                        ]
                    )  ,
                ),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                         UI_ClubsResults(raceid, clubs[index]["id"]),
                    ),
                  );
                },
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