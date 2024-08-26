import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tobias/pages/listdevices.dart';
import 'package:tobias/pages/welcome.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Map<String, String>> _myList = [];
  bool isLoading = false;

  @override
  void initState() {
    print("home() called");
    super.initState();
    _loadList();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading? const CircularProgressIndicator():( _myList.isEmpty? Welcome() : ListDevices(bleDevices: _myList,));
  }

  void _loadList() async {

    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      List<String>? myListStrings = prefs.getStringList('myList');
      _myList = myListStrings?.map((mapString) {
        return Map<String, String>.from(jsonDecode(mapString));
      }).toList() ?? [];
    });


    setState(() {
      isLoading = false;
    });
  }

}
