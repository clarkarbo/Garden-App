import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:csvwriter/csvwriter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tobias/const.dart';
import '../providers/graph_data.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class RealTimeGraphPage extends StatefulWidget {
  const RealTimeGraphPage({Key? key, required this.deviceID}) : super(key: key);
  final String deviceID;

  @override
  State<RealTimeGraphPage> createState() => _RealTimeGraphPageState();
}

class _RealTimeGraphPageState extends State<RealTimeGraphPage> {

  final bleObject = FlutterReactiveBle();
  late Stream<ConnectionStateUpdate> _currentConnectionStream;
  late StreamSubscription<ConnectionStateUpdate> _connection;
  late QualifiedCharacteristic _Characteristic0;
  late QualifiedCharacteristic _Characteristic1;
  late QualifiedCharacteristic _Characteristic2;
  late QualifiedCharacteristic _Characteristic3;
  late QualifiedCharacteristic _Characteristic4;
  late QualifiedCharacteristic _Characteristic5;
  late QualifiedCharacteristic _Characteristic6;
  late QualifiedCharacteristic _Characteristic7;
  late QualifiedCharacteristic _Characteristic8;
  late QualifiedCharacteristic _Characteristic9;
  late QualifiedCharacteristic _Characteristic10;
  late QualifiedCharacteristic _Characteristic11;
  late QualifiedCharacteristic _Characteristic12;
  List<double> setValue=[0,0,0,0,0,0,0,0,0,0,0,0];
  List<int> bufferList=[];
  late StreamSubscription<List<int>> _DataStreamSubscription1;
  late Stream<List<int>> DataStream1;
  List<TextEditingController> _controller = List.generate(12, (index) => TextEditingController());

  List<String> _errorMessage= List.generate(12, (index) => "");
  DateTime now = DateTime.now();
  bool isError = false;

  @override
  void initState() {
    // TODO: implement initState
    loadSliderValue();

    onConnectDevice(widget.deviceID);

    GraphData graphData = Provider.of<GraphData>(context, listen: false);

    graphData.data1.clear();
    graphData.data2.clear();
    graphData.data3.clear();
    graphData.data4.clear();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Perform your custom logic here
        // For example, you can show a dialog or prompt the user before allowing the navigation
        bool shouldPop = await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure you want to exit?'),
            actions: [
             MaterialButton(
                child: Text('Yes'),
                onPressed: () {
                  _disconnect();
                  Navigator.of(context).pop(true); // Allow navigation
                },
              ),
              MaterialButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false); // Prevent navigation
                },
              ),
            ],
          ),
        );

        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(

          // actions: [
          //   Consumer<GraphData>(
          //     builder: (context, graphData, _) {
          //       return IconButton(
          //         icon: (!graphData.isRecording)?Icon(Icons.fiber_manual_record):Icon(Icons.stop),
          //         onPressed: () {
          //
          //           if(!graphData.isRecording) {
          //             now = DateTime.now();
          //           }
          //
          //           graphData.isRecording = !graphData.isRecording;
          //
          //           if(!graphData.isRecording)
          //           {
          //             //check if file exists and if yes then share it
          //             shareCSV();
          //           }
          //
          //         },
          //       );
          //     },
          //   ),
          // ],

          title: const Text('Clark Garden'),
actions: [
  IconButton(onPressed: () async
      {

       isError = false;
      _errorMessage = List.generate(12, (index) => "");

        for(int i=0;i<12;i++)
        {
          setValue[i] = double.parse(_controller[i].text);
        }

        for(int i=0;i<12;i++)
          {
            if(setValue[i]<0)
              {
                _errorMessage[i] = "Error! Negative value";
                isError = true;
              }
          }

        if(isError)
         { return;
         }

        await writeData(_Characteristic1, setValue[1]);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setDouble('setValue1', setValue[1]); // Save the value

          await writeData(_Characteristic2, setValue[2]);
          await prefs.setDouble('setValue2', setValue[2]); // Save the value

          await writeData(_Characteristic3, setValue[3]);
          await prefs.setDouble('setValue3', setValue[3]); // Save the value

          await writeData(_Characteristic4, setValue[4]);
          await prefs.setDouble('setValue4', setValue[4]); // Save the value

          await writeData(_Characteristic5, setValue[5]);
          await prefs.setDouble('setValue5', setValue[5]); // S

          await writeData(_Characteristic6, setValue[6]);

          await prefs.setDouble('setValue6', setValue[6]); // S

          await writeData(_Characteristic7, setValue[7]);
          await prefs.setDouble('setValue7', setValue[7]); // S

          await writeData(_Characteristic8, setValue[8]);

          await prefs.setDouble('setValue8', setValue[8]); // S

          await writeData(_Characteristic9, setValue[9]);

          await prefs.setDouble('setValue9', setValue[9]); // S

          await writeData(_Characteristic10, setValue[10]);

          await prefs.setDouble('setValue10', setValue[10]); // S

          await writeData(_Characteristic11, setValue[11]);

          await prefs.setDouble('setValue11', setValue[11]); // S

          await writeData(_Characteristic0, setValue[0]);

          await prefs.setDouble('setValue0', setValue[0]); // S



      }, icon: Icon(Icons.send))
],
        ),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Consumer<GraphData>(
                    builder: (context, graphData, _) {
                      double screenHeight = MediaQuery.of(context).size.height;
                      double plotHeight = screenHeight * 0.5;

                      return Column(
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text("Connection Status: ", style: TextStyle(fontWeight: FontWeight.bold),)
                          ,Text(graphData.connectionState),
                            ],),

                          SizedBox(height: 100,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Distance: ", )
                              ,Text(graphData.cm.toString()),
                              SizedBox(width: 50,),
                              Text("Water level (%): ", )
                              ,Text(graphData.percentage.toString()),
                            ],),

                          SizedBox(height: 50,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Water Level Sensor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),)
                            ],),
                          SizedBox(height: 50,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SfSlider(
                              //   min: 0,
                              //   max: 200,
                              //   value: setValue[1],
                              //   interval: 1,
                              // shouldAlwaysShowTooltip: true,
                              //
                              //   onChanged: (dynamic value){
                              //     setState(() {
                              //       setValue[1] = value;
                              //     });
                              //   },onChangeEnd: (dynamic value) async{
                              //
                              //   await writeData(_Characteristic1, setValue[1]);
                              //
                              //   SharedPreferences prefs = await SharedPreferences.getInstance();
                              //   await prefs.setDouble('setValue1', setValue[1]); // Save the value
                              //
                              // },
                              // ),

                            SizedBox(
                              child: TextField(
                              controller: _controller[1],
                              keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(
                                                  labelText: "Edit value",
                                                  errorText: _errorMessage[1],
                                                  ),
                              ),
                            width: 140,
                            )
                            ],
                          ),

                          SizedBox(height: 20,),

                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("LED brightness", style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),

                          SizedBox(height: 100,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                      //         SfSlider(
                      //           min: 0,
                      //           max: 100,
                      //           value: setValue[2],
                      //           interval: 1,
                      // shouldAlwaysShowTooltip: true,
                      //           enableTooltip: true,
                      //
                      //           onChanged: (dynamic value){
                      //             setState(() {
                      //               setValue[2] = value;
                      //             });
                      //           },onChangeEnd: (dynamic value) async{
                      //
                      //           await writeData(_Characteristic2, setValue[2]);
                      //
                      //           SharedPreferences prefs = await SharedPreferences.getInstance();
                      //           await prefs.setDouble('setValue2', setValue[2]); // Save the value
                      //         },
                      //         ),

                              SizedBox(
                                child: TextField(
                                  controller: _controller[2],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Edit value",
                                    errorText: _errorMessage[2],
                                  ),
                                ),
                               width: 140,
                              )

                            ],
                          ),

                          SizedBox(height: 20,),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Reservoir Depth", style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),

                          SizedBox(height: 100,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                      //         SfSlider(
                      //           min: 0,
                      //           max: 80,
                      //           value: setValue[3],
                      //           interval: 1,
                      // shouldAlwaysShowTooltip: true,
                      //           enableTooltip: true,
                      //
                      //           onChanged: (dynamic value){
                      //             setState(() {
                      //               setValue[3] = value;
                      //             });
                      //           },onChangeEnd: (dynamic value) async{
                      //
                      //           await writeData(_Characteristic3, setValue[3]);
                      //
                      //           SharedPreferences prefs = await SharedPreferences.getInstance();
                      //           await prefs.setDouble('setValue3', setValue[3]); // Save the value
                      //         },
                      //         ),

                              SizedBox(
                                child: TextField(
                                  controller: _controller[3],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Edit value",
                                    errorText: _errorMessage[3],
                                  ),
                                ),
                               width: 140,
                              )


                            ],
                          ),
                          SizedBox(height: 20,),

                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Minimum Refill Depth", style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),

                          SizedBox(height: 100,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Circulation and Cleaning", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),)
                            ],),


                          SizedBox(height: 50,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          //     SfSlider(
                          //       min: 0,
                          //       max: 30,
                          //       value: setValue[4],
                          //       interval: 1,
                          // shouldAlwaysShowTooltip: true,
                          //       enableTooltip: true,
                          //
                          //       onChanged: (dynamic value){
                          //         setState(() {
                          //           setValue[4] = value;
                          //         });
                          //       },onChangeEnd: (dynamic value) async{
                          //
                          //       await writeData(_Characteristic4, setValue[4]);
                          //
                          //       SharedPreferences prefs = await SharedPreferences.getInstance();
                          //       await prefs.setDouble('setValue4', setValue[4]); // Save the value
                          //     },
                          //     ),

                              SizedBox(
                                child: TextField(
                                  controller: _controller[4],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Edit value",
                                    errorText: _errorMessage[4],
                                  ),
                                ),
                               width: 140,
                              )

                            ],
                          ),

                          SizedBox(height: 20,),

                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Circulation Activation Minutes", style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),

                          SizedBox(height: 100,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SfSlider(
                              //   min: 0,
                              //   max: 60,
                              //   value: setValue[5],
                              //   interval: 1,
                              //        shouldAlwaysShowTooltip: true,
                              //   enableTooltip: true,
                              //
                              //   onChanged: (dynamic value){
                              //     setState(() {
                              //       setValue[5] = value;
                              //     });
                              //   },onChangeEnd: (dynamic value) async{
                              //
                              //   await writeData(_Characteristic5, setValue[5]);
                              //
                              //   SharedPreferences prefs = await SharedPreferences.getInstance();
                              //   await prefs.setDouble('setValue5', setValue[5]); // Save the value
                              // },
                              // ),

                              SizedBox(
                                child: TextField(
                                  controller: _controller[5],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Edit value",
                                    errorText: _errorMessage[5],
                                  ),
                                ),
                               width: 140,
                              )

                            ],
                          ),

                          SizedBox(height: 20,),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Circulation Pause Minutes", style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                          SizedBox(height: 100,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SfSlider(
                              //   min: 0,
                              //   max: 50,
                              //   value: setValue[6],
                              //   interval: 1,
                              //   shouldAlwaysShowTooltip: true,
                              //   enableTooltip: true,
                              //
                              //   onChanged: (dynamic value){
                              //     setState(() {
                              //       setValue[6] = value;
                              //     });
                              //   },onChangeEnd: (dynamic value) async{
                              //
                              //   await writeData(_Characteristic6, setValue[6]);
                              //
                              //   SharedPreferences prefs = await SharedPreferences.getInstance();
                              //   await prefs.setDouble('setValue6', setValue[6]); // Save the value
                              // },
                              // ),

                              SizedBox(
                                child: TextField(
                                  controller: _controller[6],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Edit value",
                                    errorText: _errorMessage[6],
                                  ),
                                ),
                               width: 140,
                              )

                            ],
                          ),
                          SizedBox(height: 20,),

                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Cleaner Milliliters Per Activation", style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                          SizedBox(height: 100,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SfSlider(
                              //   min: 0,
                              //   max: 24,
                              //   value: setValue[7],
                              //   interval: 1,
                              //   shouldAlwaysShowTooltip: true,
                              //   enableTooltip: true,
                              //
                              //   onChanged: (dynamic value){
                              //     setState(() {
                              //       setValue[7] = value;
                              //     });
                              //   },onChangeEnd: (dynamic value) async{
                              //
                              //   await writeData(_Characteristic7, setValue[7]);
                              //
                              //   SharedPreferences prefs = await SharedPreferences.getInstance();
                              //   await prefs.setDouble('setValue7', setValue[7]); // Save the value
                              // },
                              // ),

                              SizedBox(
                                child: TextField(
                                  controller: _controller[7],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Edit value",
                                    errorText: _errorMessage[7],
                                  ),
                                ),
                               width: 140,
                              )

                            ],
                          ),

                          SizedBox(height: 20,),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Cleaner Pause Hours", style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),

                          SizedBox(height: 100,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Dosing ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),)
                            ],),

                          SizedBox(height: 50,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SfSlider(
                              //   min: 0,
                              //   max: 25,
                              //   value: setValue[8],
                              //   interval: 1,
                              //  shouldAlwaysShowTooltip: true,
                              //   enableTooltip: true,
                              //
                              //   onChanged: (dynamic value){
                              //     setState(() {
                              //       setValue[8] = value;
                              //     });
                              //   },onChangeEnd: (dynamic value) async{
                              //
                              //   await writeData(_Characteristic8, setValue[8]);
                              //
                              //   SharedPreferences prefs = await SharedPreferences.getInstance();
                              //   await prefs.setDouble('setValue8', setValue[8]); // Save the value
                              // },
                              // ),

                              SizedBox(
                                child: TextField(
                                  controller: _controller[8],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Edit value",
                                    errorText: _errorMessage[8],
                                  ),
                                ),
                               width: 140,
                              )

                            ],
                          ),

                          SizedBox(height: 20,),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Total Gallons Per Refill", style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),

                          SizedBox(height: 100,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                      //         SfSlider(
                      //           min: 0,
                      //           max: 25,
                      //           value: setValue[9],
                      //           interval: 1,
                      // shouldAlwaysShowTooltip: true,
                      //           enableTooltip: true,
                      //
                      //           onChanged: (dynamic value){
                      //             setState(() {
                      //               setValue[9] = value;
                      //             });
                      //           },onChangeEnd: (dynamic value) async{
                      //
                      //           await writeData(_Characteristic9, setValue[9]);
                      //
                      //           SharedPreferences prefs = await SharedPreferences.getInstance();
                      //           await prefs.setDouble('setValue9', setValue[9]); // Save the value
                      //         },
                      //         ),

                              SizedBox(
                                child: TextField(
                                  controller: _controller[9],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Edit value",
                                    errorText: _errorMessage[9],
                                  ),
                                ),
                               width: 140,
                              )

                            ],
                          ),

                          SizedBox(height: 20,),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Nutrient A ml/gal", style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                          SizedBox(height: 100,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                           //    SfSlider(
                           //      min: 0,
                           //      max: 25,
                           //      value: setValue[10],
                           //      interval: 1,
                           // shouldAlwaysShowTooltip: true,
                           //      enableTooltip: true,
                           //      minorTicksPerInterval: 1,
                           //      onChanged: (dynamic value){
                           //        setState(() {
                           //          setValue[10]= value;
                           //        });
                           //      },onChangeEnd: (dynamic value) async{
                           //
                           //      await writeData(_Characteristic10,  setValue[10]);
                           //
                           //      SharedPreferences prefs = await SharedPreferences.getInstance();
                           //      await prefs.setDouble('setValue10', setValue[10]); // Save the value
                           //    },
                           //    ),

                              SizedBox(
                                child: TextField(
                                  controller: _controller[10],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Edit value",
                                    errorText: _errorMessage[10],
                                  ),
                                ),
                               width: 140,
                              )

                            ],
                          ),

                          SizedBox(height: 20,),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Nutrient B ml/gal", style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),

                          SizedBox(height: 100,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              // SfSlider(
                              //   shouldAlwaysShowTooltip: true,
                              //   min: 0,
                              //   max: 20,
                              //   value:  setValue[11],
                              //   interval: 1,
                              //
                              //   enableTooltip: true,
                              //
                              //
                              //   onChanged: (dynamic value){
                              //     setState(() {
                              //       setValue[11] = value;
                              //     });
                              //   },onChangeEnd: (dynamic value) async{
                              //
                              //   await writeData(_Characteristic11, setValue[11]);
                              //
                              //   SharedPreferences prefs = await SharedPreferences.getInstance();
                              //   await prefs.setDouble('setValue11', setValue[11]); // Save the value
                              // },
                              // ),

                              SizedBox(
                                child: TextField(
                                  controller: _controller[11],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Edit value",
                                    errorText: _errorMessage[11],
                                  ),
                                ),
                               width: 140,
                              )

                            ],
                          ),

                          SizedBox(height: 20,),

                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("pH Balance ml/gal", style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),

                          SizedBox(height: 100,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              // SfSlider(
                              //   min: 0,
                              //   max: 10,
                              //   value: setValue[0],
                              //   interval: 1,
                              //
                              //   shouldAlwaysShowTooltip: true,
                              //   enableTooltip: true,
                              //
                              //   onChanged: (dynamic value){
                              //     setState(() {
                              //       setValue[0] = value;
                              //     });
                              //   },onChangeEnd: (dynamic value) async{
                              //
                              //   await writeData(_Characteristic0, setValue[0]);
                              //
                              //   SharedPreferences prefs = await SharedPreferences.getInstance();
                              //   await prefs.setDouble('setValue0', setValue[0]); // Save the value
                              // },
                              // ),
                              SizedBox(
                                child: TextField(
                                  controller: _controller[0],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Edit value",
                                    errorText: _errorMessage[0],
                                  ),
                                ),
                               width: 140,
                              )
                            ],

                          ),

                          SizedBox(height: 20,),

                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Milliliters Per Second", style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),

                          SizedBox(height: 100,),

                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadSliderValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      setValue[0] = prefs.getDouble('setValue0') ?? 0.0;
      setValue[1] = prefs.getDouble('setValue1') ?? 0.0;
      setValue[2] = prefs.getDouble('setValue2') ?? 0.0;
      setValue[3] = prefs.getDouble('setValue3') ?? 0.0;
      setValue[4] = prefs.getDouble('setValue4') ?? 0.0;
      setValue[5] = prefs.getDouble('setValue5') ?? 0.0;
      setValue[6] = prefs.getDouble('setValue6') ?? 0.0;
      setValue[7] = prefs.getDouble('setValue7') ?? 0.0;
      setValue[8] = prefs.getDouble('setValue8') ?? 0.0;
      setValue[9] = prefs.getDouble('setValue9') ?? 0.0;
      setValue[10] = prefs.getDouble('setValue10') ?? 0.0;
      setValue[11] = prefs.getDouble('setValue11') ?? 0.0;

      for(int i=0;i<12;i++)
      {
        _controller[i].text = setValue[i].toString();
      }

    });
  }

  Future<void> writeData(QualifiedCharacteristic charac, double my_value) async
  {
    await bleObject.writeCharacteristicWithResponse(charac, value: my_value.toString().codeUnits);
  }

  void onConnectDevice(String ID) {

    GraphData graphData = Provider.of<GraphData>(context, listen: false);

    _currentConnectionStream = bleObject.connectToAdvertisingDevice(
      id: ID,
      prescanDuration: const Duration(seconds: 1),
      withServices: [SERVICE_UUID],
      connectionTimeout: const Duration(seconds: 2),
    );

    // refreshScreen();

    _connection = _currentConnectionStream.listen((event) {
      var id = event.deviceId.toString();

      switch (event.connectionState) {
        case DeviceConnectionState.connecting:
          {
            print("Connecting to $id\n");

            graphData.connectionState = "Connecting...";

            break;
          }
        case DeviceConnectionState.connected:
          {
            //_connected = true;
            print("Connected to $id\n");

            graphData.connectionState = "Connected";
            graphData.notifyListeners();

            // setState(() {
            //   _connectionState = "Connected";
            // });


                _Characteristic0 = QualifiedCharacteristic(
                    serviceId: SERVICE_UUID,
                    characteristicId: CHARACTERISTICS[0],
                    deviceId: event.deviceId);

            _Characteristic1 = QualifiedCharacteristic(
                serviceId: SERVICE_UUID,
                characteristicId: CHARACTERISTICS[1],
                deviceId: event.deviceId);

            _Characteristic2 = QualifiedCharacteristic(
                serviceId: SERVICE_UUID,
                characteristicId: CHARACTERISTICS[2],
                deviceId: event.deviceId);

            _Characteristic3 = QualifiedCharacteristic(
                serviceId: SERVICE_UUID,
                characteristicId: CHARACTERISTICS[3],
                deviceId: event.deviceId);

            _Characteristic4 = QualifiedCharacteristic(
                serviceId: SERVICE_UUID,
                characteristicId: CHARACTERISTICS[4],
                deviceId: event.deviceId);

            _Characteristic5 = QualifiedCharacteristic(
                serviceId: SERVICE_UUID,
                characteristicId: CHARACTERISTICS[5],
                deviceId: event.deviceId);

            _Characteristic6 = QualifiedCharacteristic(
                serviceId: SERVICE_UUID,
                characteristicId: CHARACTERISTICS[6],
                deviceId: event.deviceId);

            _Characteristic7 = QualifiedCharacteristic(
                serviceId: SERVICE_UUID,
                characteristicId: CHARACTERISTICS[7],
                deviceId: event.deviceId);

            _Characteristic8 = QualifiedCharacteristic(
                serviceId: SERVICE_UUID,
                characteristicId: CHARACTERISTICS[8],
                deviceId: event.deviceId);

            _Characteristic9 = QualifiedCharacteristic(
                serviceId: SERVICE_UUID,
                characteristicId: CHARACTERISTICS[9],
                deviceId: event.deviceId);

            _Characteristic10 = QualifiedCharacteristic(
                serviceId: SERVICE_UUID,
                characteristicId: CHARACTERISTICS[10],
                deviceId: event.deviceId);

            _Characteristic11 = QualifiedCharacteristic(
                serviceId: SERVICE_UUID,
                characteristicId: CHARACTERISTICS[11],
                deviceId: event.deviceId);

            _Characteristic12 = QualifiedCharacteristic(
                serviceId: SERVICE_UUID,
                characteristicId: CHARACTERISTICS[12],
                deviceId: event.deviceId);

            DataStream1 = bleObject.subscribeToCharacteristic(_Characteristic12);

            _DataStreamSubscription1 = DataStream1.listen((data) {
              onNewReceivedData(data);
            }, onError: (dynamic error) {
              print("Error:$error$id\n");
            });


            break;
          }
        case DeviceConnectionState.disconnecting:
          {
            print("Disconnecting from $id\n");

            graphData.connectionState = "Disconnecting...";
            graphData.notifyListeners();
            break;
          }
        case DeviceConnectionState.disconnected:
          {

            //_connected = false;
            print("Disconnected from $id\n");
            // setState(() {
            //   _connectionState = "Disconnected";
            // });

            _disconnect();



            break;
          }
      }
    }, onError: (error) {
      // Handle a possible error
      print(error);
    });
  }

  void _disconnect() async {

    GraphData graphData = Provider.of<GraphData>(context, listen: false);
    graphData.connectionState = "Disconnected";
    graphData.notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      await _DataStreamSubscription1.cancel();
      await _connection.cancel();
    } catch (e) {
      print(e);
    }

   // _connected = false;
    print("_disconnect() called");
  }

  void onNewReceivedData(List<int> data) {

    String sensorData = String.fromCharCodes(data);

    List<String> splitted = sensorData.split(',');

    List<int> splittedInt = splitted.map((str) => int.tryParse(str) ?? 0).toList();

    GraphData graphData = Provider.of<GraphData>(context, listen: false);

    graphData.cm = splittedInt[0];
    graphData.notifyListeners();

    graphData.percentage = splittedInt[1];
    graphData.notifyListeners();

  }

  void recordData(List<int> buffer) async
  {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${now}.csv';
      var numbersFile = File(filePath);

      var numbersCsv;

      try{

        if (!await numbersFile.exists()) {
          numbersCsv = CsvWriter.withHeaders(numbersFile.openWrite(mode: FileMode.write),['Timestamp', 'Finger Left',  'Grip Left',  'Chin',  'Bow/Right']);

          numbersCsv.writeData(data: {'Timestamp', 'Finger Left',  'Grip Left',  'Chin',  'Bow/Right'});

        }

        else{
          numbersCsv = CsvWriter.withHeaders(numbersFile.openWrite(mode: FileMode.append),[ DateTime.now().toString(), buffer[0].toString(), buffer[1].toString(), buffer[2].toString(), buffer[3].toString()]);

        }
      }
      finally {
        await numbersCsv.close();
      }



  }

  void shareCSV() async{

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${now}.csv';

    final csvFile = File(filePath);

    if(await csvFile.exists())    {
      Share.shareFiles([filePath], text: 'Sharing CSV file');
    }
    else{
      print("file not exist");
    }

  }

}

