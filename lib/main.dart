import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tobias/pages/bluetoothAdapterStatus.dart';
import 'package:tobias/pages/home.dart';
import 'package:tobias/providers/graph_data.dart';

void main() {

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<GraphData>(
          create: (context) => GraphData(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final bleObject = FlutterReactiveBle();

  @override
  void initState() {

    checkPermission();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.blueGrey[900],
        ),
        home: StreamBuilder<BleStatus>(
            stream: bleObject.statusStream,
            builder: (c,snapshot){

              if(snapshot.hasData)
              {
                if(snapshot.data!.index==5)
                  {
                    return const Home();
                  }
                else
                  {
                    return const AdapterPage();
                  }
              }
              else
              {
                return const AdapterPage();
              }

            })

    );
  }

  void checkPermission() async
  {
    await Permission.locationWhenInUse.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }


}






