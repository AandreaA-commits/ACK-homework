import 'dart:async';
import 'package:flutter/material.dart';
import '../api.dart';
import './ui_classresults.dart';
class UI_RaceClasses extends StatefulWidget {
  final String raceid;
  const UI_RaceClasses(this.raceid, {Key? key}) : super(key: key);

  @override
  _RaceClassesState createState() => _RaceClassesState();
}

class _RaceClassesState extends State<UI_RaceClasses> {
  late Future<List<String>> futureClasses;

  @override
  void initState() {
    super.initState();
    futureClasses = fetchClasses(widget.raceid);
  }

  @override
  Widget build(BuildContext context) {
    return _getScaffold(this, futureClasses, widget.raceid);
  }

  Future<void> refresh() async
  {
    futureClasses = fetchClasses(widget.raceid);
    //await Future.delayed(Duration(seconds: 3));
    super.setState(() {
    });
  }
}

Scaffold _getScaffold(_RaceClassesState parent, Future<List<String>> futureClasses, String raceid)
{
  return Scaffold(
    appBar: AppBar(
      title: const Text('Categorie'),
    ),
    body: RefreshIndicator(
      onRefresh: () async {
        return await parent.refresh();
        },
      child: FutureBuilder<List<String>>(
        future: futureClasses,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> classes = snapshot.data!;
            return ListView.builder(
              itemCount: classes.length,
              itemBuilder: ((context, index) => ElevatedButton( //Text(classes[index])));
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UI_ClassResults(raceid, classes[index]), //HARDCODE  classes[index]["_id"]""),
                    ),
                  );
                },
                child: Text(classes[index]),
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