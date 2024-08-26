import 'package:flutter/material.dart';
import 'package:tobias/pages/real_time_graph_page.dart';
import 'package:tobias/pages/scanning.dart';

class ListDevices extends StatefulWidget {
  const ListDevices({Key? key, required this.bleDevices}) : super(key: key);
  final List<Map<String, String>> bleDevices;

  @override
  State<ListDevices> createState() => _ListDevicesState();
}

class _ListDevicesState extends State<ListDevices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Devices"),actions: [
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Scanning()));
          },
          icon: Icon(Icons.add),
        ),
      ],
      automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: ListView.builder(
            itemCount: widget.bleDevices.length,
            itemBuilder: (context, index) => Card(

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RealTimeGraphPage(
                                deviceID:
                                widget.bleDevices[index]['id']!,
                              )));
                    },
                    child: ListTile(
                      title:
                      Text(widget.bleDevices[index]['name']!),
                      subtitle: Text(widget.bleDevices[index]['id']!),
                      trailing: const Icon(Icons.navigate_next_rounded),
                    ),
                  ),
                ))),

      ),
    );
  }
}
