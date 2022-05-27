import 'dart:convert';
import 'package:http/http.dart' as http;
import '../globals.dart';


Future<List<Map<String, dynamic>>> fetchRaces() async {
  final response = await http.get(Uri.parse('$apiUrl/list_races'));

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


Future<List<String>> fetchClasses(String raceid) async {
  final response = await http.get(Uri.parse('$apiUrl/list_classes?id=$raceid'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return List<String>.from(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load classes');
  }
}

Future<List<Map<String, dynamic>>> fetchClassResults(String raceid, String classid) async {
  final response = await http.get(Uri.parse('$apiUrl/results?id=$raceid&class=$classid'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load classes\'s athletes');
  }
}

Future<List<Map<String, dynamic>>> fetchClubs(String raceid) async {
  final response = await http.get(Uri.parse('$apiUrl/list_organisations?id=$raceid'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load clubs');
  }
}

Future<List<Map<String, dynamic>>> fetchClubsResults(String raceid, String clubsid) async {
  final response = await http.get(Uri.parse('$apiUrl/results?id=$raceid&organisation=$clubsid'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load clubs\'s atheletes' );
  }
}

Future<List<Map<String, dynamic>>> fetchStartList(String raceid, String classid) async {
  final response = await http.get(Uri.parse('$apiUrl/start_list?id=$raceid&class=$classid'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load clubs\'s atheletes' );
  }
}

Future<List<Map<String, dynamic>>> fetchStartClasses(String raceid) async {
  final response = await http.get(Uri.parse('$apiUrl/start_classes?id=$raceid'));

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