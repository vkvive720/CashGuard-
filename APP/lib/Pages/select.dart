import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:notecheak/Model/userModel.dart';
import 'package:notecheak/Pages/Home.dart';
import 'package:notecheak/Pages/flask.dart';
import 'package:notecheak/Pages/ip.dart';
import 'package:notecheak/Pages/loginpage.dart';
import 'package:notecheak/Pages/sound.dart';
import 'package:notecheak/helper/card.dart';
import 'package:notecheak/main.dart';

class select extends StatefulWidget {
  final UserModel userModel;

  const select({
    super.key,
    required this.userModel,
  });

  @override
  State<select> createState() => _selectState();
}

class _selectState extends State<select> {
  TextEditingController textEditingController = TextEditingController();
  String wifi = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: const Icon(Icons.logout)),
          )
        ],
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        title: const Text("GupSup"),
        elevation: 100,
        //shadowColor: Color.fromARGB(255, 179, 179, 179),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.wifi),
              title: Text('IP Address'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Ipaddress(),
                  ),
                );
                // Handle the home tap here
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle the settings tap here
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Handle the logout tap here
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageUploadScreen(
                            userModel: UserModel(),
                          ),
                        ),
                      );
                    },
                    child: BeautifulCard(
                      title: "Verify Currency",
                      titleStyle: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      gradientColors: [
                        Colors.purple.shade700,
                        Colors.blue.shade400,
                      ],
                      width: 350,
                      elevation: 20,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageUploadScreen(
                                    userModel: widget.userModel),
                              ),
                            );
                          },
                          child: BeautifulCard(
                            title: "500",
                            titleStyle:
                                TextStyle(fontSize: 20, color: Colors.white),
                            gradientColors: [
                              const Color.fromARGB(255, 51, 166, 217),
                              const Color.fromARGB(255, 51, 166, 217),
                            ],
                            width: 150,
                            height: 150,
                            //elevation: 10,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageUploadScreen(
                                    userModel: widget.userModel),
                              ),
                            );
                          },
                          child: BeautifulCard(
                            title: "2000",
                            gradientColors: [
                              const Color.fromARGB(255, 132, 198, 223),
                              const Color.fromARGB(255, 132, 198, 223),
                            ],
                            width: 150,
                            height: 150,
                            //elevation: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageUploadScreen(
                                    userModel: widget.userModel),
                              ),
                            );
                          },
                          child: BeautifulCard(
                            title: "100",
                            gradientColors: [
                              const Color.fromARGB(255, 148, 139, 224),
                              const Color.fromARGB(255, 148, 139, 224),
                            ],
                            width: 150,
                            height: 150,
                            //elevation: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageUploadScreen(
                                  userModel: widget.userModel,
                                ),
                              ),
                            );
                          },
                          child: BeautifulCard(
                            title: "200",
                            gradientColors: [
                              const Color.fromARGB(255, 66, 116, 219),
                              const Color.fromARGB(255, 66, 116, 219),
                            ],
                            width: 150,
                            height: 150,
                            //elevation: 20,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
