import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tobias/const.dart';
import 'package:tobias/main.dart';

class Scanning extends StatefulWidget {
  const Scanning({Key? key}) : super(key: key);

  @override
  State<Scanning> createState() => _ScanningState();
}

class _ScanningState extends State<Scanning> {
  final bleObject = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> _scanStream;

  //List<DiscoveredDevice> _foundBleDevices = [];
  List<Map<String, String>> _foundBleDevices = [];


  bool isScanning = false;

  late Stream<List<int>> _txDataStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No previously paired devices found\nPlease set the device to pairing mode",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Instructions",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                          ),
                          onPressed: () {
                            if (!isScanning) {
                                  scanDevices();
                                 }
                            _showScanSheet(context);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('SCAN FOR DEVICES'), // <-- Text
                              SizedBox(
                                width: 5,
                              ),
                              Icon( // <-- Icon
                                Icons.search,
                                size: 24.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );

      // body: isScanning
      //     ? Center(child: const CircularProgressIndicator())
      //     : Column(
      //   children: [
      //     SingleChildScrollView(
      //       child: Container(
      //         height: 500,
      //         child: ListView.builder(
      //             itemCount: _foundBleDevices.length,
      //             itemBuilder: (context, index) => Card(
      //                 child: ListTile(
      //                   title:
      //                   Text(_foundBleDevices[index].name.toString()),
      //                   subtitle: Text(_foundBleDevices[index].id),
      //                   trailing: MaterialButton(
      //                     onPressed: () {
      //                       Navigator.push(
      //                           context,
      //                           MaterialPageRoute(
      //                               builder: (context) => DeviceScreen(
      //                                 deviceID:
      //                                 _foundBleDevices[index].id,
      //                               )));
      //                     },
      //                     child: Text(
      //                       "Connect",
      //                       style: TextStyle(color: Colors.white),
      //                     ),
      //                     color: Colors.blue,
      //                   ),
      //                 ))),
      //       ),
      //     ),
      //   ],
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     if (!isScanning) {
      //       scanDevices();
      //     }
      //   },
      //   backgroundColor: (!isScanning) ? Colors.blue : Colors.red,
      //   child:
      //   (!isScanning) ? const Icon(Icons.search) : const Icon(Icons.stop),
      // ),
      //
      //

  }

  void _showScanSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return Container(
            height: 350.0,

            //so you don't have to change MaterialApp canvasColor
            child:  Container(
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius:  BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0))),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 50.0,
                          ),
                        )

                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Looking for devices", style: TextStyle(fontSize: 30, color: Colors.black),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Keep your device in reach", style: TextStyle(fontSize: 16, color: Colors.black),),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(child: Text("Cancel", style: TextStyle(fontSize: 20, color: Colors.black),),
                        onTap: ()=> Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                )),
          );
        }
    );
  }

  void _showFoundSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return Container(
            height: 350.0,

            //so you don't have to change MaterialApp canvasColor
            child:  Container(
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius:  BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0))),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 50.0,
                          ),
                        )

                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("BLE found", style: TextStyle(fontSize: 30, color: Colors.black),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Do you want to pair this device?", style: TextStyle(fontSize: 16, color: Colors.black),),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                  ),
                                  onPressed: () async {

                                    SharedPreferences prefs = await SharedPreferences.getInstance();

                                    List<Map<String, String>> myMaps = (prefs.getStringList('myList') ?? []).map((mapString) {
                                      return Map<String, String>.from(jsonDecode(mapString));
                                    }).toList();


                                    String newDeviceId = _foundBleDevices.last['id']!;
                                    bool deviceExists = myMaps.any((map) => map['id'] == newDeviceId);

                                    if (!deviceExists) {
                                      myMaps.add({
                                        'id': _foundBleDevices.last['id']!,
                                        'name': _foundBleDevices.last['name']!,
                                        // Add other key-value pairs as needed
                                      });

                                      List<String> myStrings = myMaps.map((
                                          map) => jsonEncode(map)).toList();
                                      await prefs.setStringList(
                                          'myList', myStrings);
                                    }

                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) => MyApp()),);
                                    },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('PAIR'), // <-- Text
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon( // <-- Icon
                                        Icons.link,
                                        size: 24.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(child: Text("Dismiss", style: TextStyle(fontSize: 20, color: Colors.black),),
                          onTap: (){
                          Navigator.pop(context);
                          stopScan();
                          },
                        ),
                      ],
                    ),
                  ],
                )),
          );
        }
    );
  }

  void scanDevices() async {
    print("Scanning started");
    isScanning = true;
    _foundBleDevices = [];


    if (Platform.isAndroid)
    {
      if (await Permission.bluetoothConnect
          .request()
    .isGranted==true) {
    print("here----");
    if (await Permission.bluetoothScan
        .request()
        .isGranted) {
    print("=====");


    _scanStream = bleObject.scanForDevices(
    withServices: [SERVICE_UUID],
    ).listen((device) {

    if (_foundBleDevices.every((element) => element['id'] != device.id)) {

    _foundBleDevices.add({
      'name': device.name,
      'id': device.id,
    });
    Navigator.pop(context);
    _showFoundSheet(context);
    setState(() {});

    }
    }, onError: (error) {
    //code for handling error
    print(error);
    });

    final timer = Timer(
    const Duration(seconds: 3),
    () {
    stopScan();
    },
    );


    }
      }

    }

else{

      _scanStream = bleObject.scanForDevices(
        withServices: [SERVICE_UUID],
      ).listen((device) {

        if (_foundBleDevices.every((element) => element['id'] != device.id)) {
          if (device.name.isNotEmpty) {
            _foundBleDevices.add({
              'name': device.name,
              'id': device.id,
            });
            Navigator.pop(context);
            _showFoundSheet(context);
            setState(() {});
          }
        }
      }, onError: (error) {
        //code for handling error
        print(error);
      });

      final timer = Timer(
        const Duration(seconds: 3),
            () {
          stopScan();
        },
      );



    }



  }

  void stopScan() async {
    try {
      await _scanStream.cancel();
    } catch (e) {
      print(e);
    }

    isScanning = false;

    if(mounted)
      {
        setState(() {});
      }

    print("Scanning stopped\n");
  }
}
