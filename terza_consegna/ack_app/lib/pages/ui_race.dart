import 'package:ack_app/pages/ui_raceclasses.dart';
import 'package:ack_app/pages/ui_clubs.dart';
import 'package:ack_app/pages/ui_racestartlists.dart';
import 'package:ack_app/pages/ui_startlist.dart';
import 'package:flutter/material.dart';
import './ui_home.dart';


class UI_Race extends StatefulWidget {
  final String raceId;
  final String raceName;
  const UI_Race(this.raceId, this.raceName, {Key? key}) : super(key: key);

  @override
  _RaceState createState() => _RaceState();
}

class _RaceState extends State<UI_Race> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> routeTitles = [];
    List<StatefulWidget> routeWidgets = [];

    routeWidgets.add(UI_RaceClasses(widget.raceId));
    routeTitles.add("Categorie");

    routeWidgets.add(UI_Clubs(widget.raceId));
    routeTitles.add("Clubs");

    routeWidgets.add(UI_RaceStartLists(widget.raceId));
    routeTitles.add("Start List");

    return _getScaffold(widget.raceName, widget.raceId, routeWidgets, routeTitles);
  }
}

Scaffold _getScaffold(String raceName, String raceId, List<StatefulWidget> routeWidgets, List<String> routeTitles)
{
  return Scaffold(
    appBar: AppBar(
      title: Text(raceId + " - " + raceName),
    ),
    body: Center(
      child: ListView.builder(
        itemCount: routeWidgets.length,
        itemBuilder: ((context, index) => ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                routeWidgets[index],
              ),
            );
          },
          child: Text(routeTitles[index]),
        )),
      )
    ),
  );
}
