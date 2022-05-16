import 'dart:async';
import 'package:flutter/material.dart';
import '../api.dart';

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
    return _getScaffold(futureClasses);
  }
}


Scaffold _getScaffold(Future<List<String>> futureClasses)
{
  return Scaffold(
    appBar: AppBar(
      title: const Text('Classes 1'),
    ),
    body: Center(
      child: FutureBuilder<List<String>>(
        future: futureClasses,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> classes = snapshot.data!;
            return ListView.builder(
                itemCount: classes.length,
                itemBuilder: ((context, index) => Text(classes[index])));
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