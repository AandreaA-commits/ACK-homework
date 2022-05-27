import 'package:flutter/material.dart';
import '../api.dart';

class UI_ClubsResults extends StatefulWidget {
  final String clubsid;
  final String raceid;
  final String clubname;
  const UI_ClubsResults(this.raceid, this.clubsid, this.clubname, {Key? key}) : super(key: key);

  @override
  _ClubsResultsState createState() => _ClubsResultsState();
}

class _ClubsResultsState extends State<UI_ClubsResults> {
  late Future<List<Map<String, dynamic>>> futureClubsResults;

  @override
  void initState() {
    super.initState();
    futureClubsResults = fetchClubsResults(widget.raceid, widget.clubsid);
  }

  @override
  Widget build(BuildContext context) {
    return _getScaffold(futureClubsResults, widget.clubname);
  }
}

Scaffold _getScaffold(Future<List<Map<String, dynamic>>> futureClubsResults, String clubname) {
  return Scaffold(
      appBar: AppBar(
        title: Text('Atleti del club - ' + clubname),
      ),
      body: Center(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: futureClubsResults,
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
