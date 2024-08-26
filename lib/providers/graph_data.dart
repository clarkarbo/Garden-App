import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share/share.dart';

class DataPoint {
  DateTime x;
  int y=0;

  DataPoint(this.x, this.y);
}

class GraphData with ChangeNotifier {

  bool isRecording = false;

  bool _connected = false;
  String connectionState = "Connecting...";

  DateTime now = DateTime.now();

  List<DataPoint> data1 = [];
  List<DataPoint> data2 = [];
  List<DataPoint> data3 = [];
  List<DataPoint> data4 = [];
  List<DataPoint> data5 = [];
  List<DataPoint> data6 = [];

  int cm=0;
  int percentage=0;

  GraphData() {

      notifyListeners();
   // });
  }

}