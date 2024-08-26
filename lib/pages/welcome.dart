import 'package:flutter/material.dart';
import 'package:tobias/pages/scanning.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome",
                  style: TextStyle(fontSize: 38),
                ),
              ],
            ),
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
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        height: 40,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Scanning()),
                          );
                        },
                        child: Text("NEXT"),
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
