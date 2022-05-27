import 'dart:async';
import 'package:ack_app/pages/ui_startlist.dart';
import 'package:flutter/material.dart';
import '../api.dart';
import './ui_classresults.dart';
class UI_RaceStartLists extends StatefulWidget {
  final String raceid;
  const UI_RaceStartLists(this.raceid, {Key? key}) : super(key: key);

  @override
  _RaceStartLists createState() => _RaceStartLists();
}

class _RaceStartLists extends State<UI_RaceStartLists> {
  late Future<List<Map<String, dynamic>>> futureClasses;

  @override
  void initState() {
    super.initState();
    futureClasses = fetchStartClasses(widget.raceid);
  }

  @override
  Widget build(BuildContext context) {
    return _getScaffold(this, futureClasses, widget.raceid);
  }

  Future<void> refresh() async
  {
    futureClasses = fetchStartClasses(widget.raceid);
    //await Future.delayed(Duration(seconds: 3));
    super.setState(() {
    });
  }
}

Scaffold _getScaffold(_RaceStartLists parent, Future<List<Map<String, dynamic>>> futureClasses, String raceid)
{
  return Scaffold(
    appBar: AppBar(
      title: const Text('Categorie'),
    ),
    body: RefreshIndicator(
      onRefresh: () async {
        return await parent.refresh();
      },
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureClasses,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Map<String, dynamic>> classes = snapshot.data!;
            return ListView.builder(
              itemCount: classes.length,
              itemBuilder: ((context, index) => ElevatedButton( //Text(classes[index])));
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UI_StartList(raceid, classes[index]["id"], classes[index]["name"]),
                    ),
                  );
                },
                child: Text(classes[index]["name"]),
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