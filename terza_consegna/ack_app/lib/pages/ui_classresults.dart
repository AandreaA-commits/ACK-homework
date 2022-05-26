import 'package:flutter/material.dart';
import '../api.dart';

class UI_ClassResults extends StatefulWidget {
  final String classid;
  final String raceid;
  const UI_ClassResults(this.raceid, this.classid, {Key? key}) : super(key: key);

  @override
  _ClassResultsState createState() => _ClassResultsState();
}

class _ClassResultsState extends State<UI_ClassResults> {
  late Future<List<Map<String, dynamic>>> futureClassResults;

  @override
  void initState() {
    super.initState();
    futureClassResults = fetchClassResults(widget.raceid, widget.classid);
  }

  @override
  Widget build(BuildContext context) {
    return _getScaffold(futureClassResults, widget.classid);
  }
}

Scaffold _getScaffold(Future<List<Map<String, dynamic>>> futureClassResults, String classid) {
  return Scaffold(
      appBar: AppBar(
        title: Text('Classifica degli atleti - ' + classid),
      ),
      body: Center(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: futureClassResults,
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
