import 'dart:developer';
import 'dart:io';

import 'package:btr_chat/Screens/home_screen.dart';
import 'package:btr_chat/helper/dialogues.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../api/api.dart';
import '../../main.dart';
import '../bottom_nav.dart';


class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  
  bool _Animate = false;
  
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500),(){
    setState(() {
      _Animate = true;
    });});
  }

  _handle_google_btn_click() {
    Dialogs.show_progress_bar(context);
   _signInWithGoogle().then((user) async {
     // for hiding progress bar
     Navigator.pop(context);
     if(user != null){
       log('User: ${(user.user)}');
       log('\nUser Additional info : ${user.additionalUserInfo}');

       if(await API.user_exsist()){
         API.get_self_info().then((value) => Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => BottomNavDemo() )));
       }
       // create uesr and then move to home screen
       else{
         API.create_user().then((value) {
           API.get_self_info().then((value) {
             Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => BottomNavDemo() ));
           });
         });
       }
     }
   });
  }

  // _singin means signin is a private function
  // if there is an error this _signInwithGoogle doesnt return usercredentials so use """?""" so
  // that it can return null also
  Future<UserCredential?> _signInWithGoogle() async {
    try{
      // check user connected with internet
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow (ie,pop Up)
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await API.auth.signInWithCredential(credential);
    }
    catch(e){
      print(e);
      log("\n sign in with google : $e");

      // Create widget in another field and call it when needed
       Dialogs.showSnackbar(context,"Unable to SignIn");

      return null;
    }
  }

  // sign

  @override
  Widget build(BuildContext context) {

    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent.shade200,
        centerTitle: true,
        elevation: 5,
        title: const Text("Login",style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 25,
            color: Colors.white
        ),),
      ),
      body: Stack(
        children: [
          // Welcome statement
        Positioned(
          top:mq.height*0.05,
           width: mq.width*6,
           left : mq.width*0.2,
          child: const Text("Welcome to Atadu",
                style:TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo
                ),
                      ),
            ),

          // Logo
          AnimatedPositioned(
          top: mq.height*.10,
            width: mq.width*0.76,
            right :_Animate ? mq.width*0.12 : -mq.width*0.5,
            duration: const Duration(milliseconds:500),
            child: SvgPicture.asset("Assets/images/icon.svg",height: 320,width: 320,)
        ),
          Positioned(
              top: mq.height*.60,
              width: mq.width*0.80,
              left: mq.width*0.1,
              height: mq.width*0.13,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.indigoAccent,
                  elevation: 6,
                ),
                //   style: ElevatedButton.styleFrom(
                //     padding: EdgeInsets.zero, // Set padding to zero
                //   ),
                  onPressed: (){
                 print("Helllo");
                  _handle_google_btn_click();
                  },
                  icon: Padding(
                    padding: const EdgeInsets.only(left:0,right:10),
                    child: CircleAvatar(
                      radius: 20,
                       backgroundColor: Colors.white,
                        child: Image.asset("Assets/images/search.png", height: 24,)),
                  ),
                  label: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: RichText(text: const TextSpan(
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400
                      ),
                      children: [
                        TextSpan(text: 'Login with'),
                        TextSpan(text: " Google",style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 19
                        ))
                      ]
                    ),
                    ),
                  )
              )
          )
        ],
      ),
    );
  }
}

