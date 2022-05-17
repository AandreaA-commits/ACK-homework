import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import './globals.dart';
import './pages/ui_raceclasses.dart';
import './pages/ui_home.dart';



void main() {
  runApp( MaterialApp(
    title: 'Ori Live Results',
    theme:  ThemeData(
        primarySwatch: Colors.deepPurple,//Color.fromRGBO(37, 7, 107, 1.0),
    ),
    home: UI_Home(),
  ));
}



