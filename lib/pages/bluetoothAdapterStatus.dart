import 'package:flutter/material.dart';

class AdapterPage extends StatelessWidget {
  const AdapterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.bluetooth_disabled, size: 90,color: Colors.white,),
          ),

          Text("Bluetooth Adapter is OFF. Please turn it ON", style: TextStyle(color: Colors.white, fontSize: 18),),
        ],
      )),
    );
  }
}
