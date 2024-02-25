import 'dart:developer';

import 'package:btr_chat/Screens/auth/loginScreen.dart';
import 'package:btr_chat/api/api.dart';
import 'package:flutter/material.dart';
import 'package:btr_chat/Screens/home_screen.dart';
import 'package:flutter/services.dart';

import '../../main.dart';
import 'bottom_nav.dart';
import 'maps.dart';

 // Splash
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _Splash();
}

class _Splash extends State<Splash> {

  @override
  void initState() {
    super.initState();



    API.get_self_info().then((value) {
      Future.delayed(const Duration(milliseconds:800),(){


        // exit full screen
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.indigoAccent,));

        // Navigate to home

        if(API.auth.currentUser != null){
          log("\n User : ${API.auth.currentUser}");
          // Dialogs.showSnackbar(context, FirebaseAuth.instance.currentUser as String);
          // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const Home_Screen()));
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => BottomNavDemo()));

        }
        // Navigate to login
        else{
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const Login_Screen()));
        }

        //Navigate to home screen
      });
    });
    // Future.delayed(const Duration(milliseconds:2000),(){
    //
    //
    //   // exit full screen
    //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.indigoAccent,));
    //
    //   // Navigate to home
    //
    //   if(API.auth.currentUser != null){
    //     log("\n User : ${API.auth.currentUser}");
    //     // Dialogs.showSnackbar(context, FirebaseAuth.instance.currentUser as String);
    //     // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const Home_Screen()));
    //     Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => BottomNavDemo()));
    //
    //   }
    //   // Navigate to login
    //   else{
    //     Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const Login_Screen()));
    //   }
    //
    //   //Navigate to home screen
    // });
  }
  @override
  Widget build(BuildContext context) {

    // Initialising media query
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body:Column(
        children: [
          Container(
            width: mq.width,
            height: mq.height*0.7,
            // margin: EdgeInsets.only(top:mq.height*0.07,left:mq.width*0.01,right:mq.width*0.01 ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('Assets/images/comm2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
      ),
              Container(
               margin: const EdgeInsets.only(top: 40,left: 10,right: 10),
               child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Community : '),
                          TextSpan(
                            text: 'where unity becomes strength and differences become assets',
                            style: TextStyle(
                              fontSize: 18,
                              letterSpacing: 0.1,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
             )


        ],
      ),
      // )
    );
  }
}

