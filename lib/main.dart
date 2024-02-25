import 'package:btr_chat/Screens/Splash_Screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

// global object for accessing device screen size
// mq --> media query
// we can only initialise the """media-query""" in a build function of that is a parent of  """MaterialApp"""
late Size mq;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  // // enter full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // fixing orientation; we face glitches in orientation( it is a futre object )so we can run app once orientation is done
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]
  ).then((value) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  });

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home page
      home:Splash()
    );
  }
}

