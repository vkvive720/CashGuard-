import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notecheak/main.dart';

class Ipaddress extends StatefulWidget {
  const Ipaddress({super.key});

  @override
  State<Ipaddress> createState() => _IpaddressState();
}

class _IpaddressState extends State<Ipaddress> {
  TextEditingController textEditingController = TextEditingController();
  Audio audio = Audio.load('assets/audio/500.mp3');
  String wifi = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                children: [
                  Text("$uri"),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'ip address',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CupertinoButton(
                    child: Text("change url "),
                    onPressed: () {
                      // Play a sound as a one-shot, releasing its resources when it finishes playing.
                      // Audio.load('assets/audio/500.mp3')
                      //   ..play()
                      //   ..dispose();
                      setState(
                        () {
                          print(
                              "bi--------------------------------------------------------");
                          wifi = textEditingController.text;
                          s = "http://" + "$wifi" + "/upload";
                          uri = Uri.parse('$s');
                          print(uri);
                        },
                      );
                    },
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
