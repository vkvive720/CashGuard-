import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notecheak/Model/userModel.dart';
import 'package:notecheak/Pages/Home.dart';
import 'package:notecheak/Pages/select.dart';
import 'package:notecheak/Pages/signuppage.dart';
import 'package:notecheak/firebase_options.dart';
import 'package:notecheak/helper/Firebase_helper.dart';

//late List<CameraDescription> _cameras;

String s = 'http://192.168.134.99:4000/upload';
var uri = Uri.parse('$s');
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // _cameras = await availableCameras();
  // print("___________________________________");
  // print(_cameras[0]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //runApp(const MyApp());
  var currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    UserModel? thisUserModel =
        await FirebaseHelper.getUserModelByID(currentUser.uid);
    if (thisUserModel != null) {
      print("___________________________________");
      print(currentUser.email);
      print("___________________________________");
      runApp(MyAppLoggindIn(
        //firebaseUser: currentUser,
        userModel: thisUserModel,
      ));
    }
  } else {
    //Not logged in
    runApp(const MyApp());
  }
}

class User {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        colorScheme: ColorScheme.light(),
        useMaterial3: true,
      ),
      home: SignUpPage(),
    );
  }
}

//Loggg in
class MyAppLoggindIn extends StatelessWidget {
  final UserModel userModel;
  //final User firebaseUser;

  const MyAppLoggindIn({
    super.key,
    required this.userModel,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'Flutter Demo',
      theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(
          //     seedColor: Colors.blue,
          //     primary: Colors.blue[500], // Set primary color (darker shade)
          //     secondary: Colors.teal[300]),
          // useMaterial3: true,
          ),
      home: select(userModel: userModel),
    );
  }
}
