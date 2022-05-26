import 'package:flutter/material.dart';
import '../api.dart';

class UI_StartList extends StatefulWidget {
  final String raceid;
  final String classid;
  const UI_StartList(this.raceid, this.classid, {Key? key}) : super(key: key);

  @override
  _StartListState createState() => _StartListState();
}

class _StartListState extends State<UI_StartList> {
  late Future<List<Map<String, dynamic>>> futureStartList;

  @override
  void initState() {
    super.initState();
    futureStartList = fetchStartList(widget.raceid, widget.classid);
  }

  @override
  Widget build(BuildContext context) {
    return _getScaffold(futureStartList, widget.classid);
  }
}

Scaffold _getScaffold(Future<List<Map<String, dynamic>>> futureStartList, String classid) {
  return Scaffold(
      appBar: AppBar(
        title: Text("Start list - " + classid),
      ),
      body: Center(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: futureStartList,
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
                                child: Text(athletes[index]["name"], style: TextStyle(fontSize: 15),),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(athletes[index]["surname"], style: TextStyle(fontSize: 15),),
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
