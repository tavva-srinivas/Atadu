
import 'dart:developer';
import 'dart:io';

import 'package:btr_chat/Screens/auth/loginScreen.dart';
import 'package:btr_chat/Widgets/chat_card.dart';
import 'package:btr_chat/api/api.dart';
import 'package:btr_chat/helper/dialogues.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';
import 'package:btr_chat/classes/chat_user.dart';

// To show signed in user info
class Profile_Screen extends StatefulWidget {
  final Chat_user user;
  const Profile_Screen({super.key,required this.user});

  @override
  State<Profile_Screen> createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen> {

  @override
  void initState() {
    API.get_self_info();
    super.initState();
  }

  //Form key --> So that we can know if there is changes in the form
  // stores form state
  final form_key = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {


    bool show_floating_btn = MediaQuery.of(context).viewInsets.bottom != 0;
    return GestureDetector(
      // for removing the keyboard whentouched anywhere
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
      // to avoid saying there is overflow in the bottom
          resizeToAvoidBottomInset: true,

        // resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.indigoAccent.shade200,
          centerTitle: true,
          elevation: 5,
          title: const Text("Profile ",style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Colors.white
          ),),
        ),

        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Visibility(
            visible: !show_floating_btn,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                // await FirebaseAuth.instance.signOut();
                // await GoogleSignIn().signOut();
                Dialogs.show_progress_bar(context);
                await API.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) => {
                    // for hiding progress dialog
                    Navigator.pop(context),
                    // for moving to home screen
                    Navigator.pop(context),
                    // for replacing home with login screen
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login_Screen()))
                  });
                });


              },
              label: Text("Logout",style: TextStyle(
                color: Colors.white
              ),),
              icon:  Icon(Icons.login_rounded,size: 28,color: Colors.white,)
            ),
          ),
        ),

        // form is used to validate/show error  when we left empty name and about when updating the profile
        body: Form(
          key: form_key,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width*0.02),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: mq.height*0.03,),

                        // user image
                        Stack(
                          children:[
                            ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                              child: _image != null ?
                              Image.file(
                                  File(_image!),
                                  width: mq.height*0.23,
                                  height: mq.height*0.23,
                                  // to properly show profile icon with a middle zoom
                                  fit: BoxFit.cover,
                                ) :
                              CachedNetworkImage(
                                width: mq.height*0.23,
                                height: mq.height*0.23,
                                imageUrl: widget.user.image!,
                                // to properly show profile icon
                                fit: BoxFit.cover,
                                // placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>  const CircleAvatar(
                                  backgroundColor: Colors.teal,
                                  child: Icon(CupertinoIcons.person,color: Colors.white,),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: -20,
                              child: MaterialButton(
                                elevation: 3,
                                shape: CircleBorder(),
                                onPressed: () {
                                  _showbottom_sheet();
                                },
                                color: Colors.white,
                                child: Icon(Icons.edit, size: 20, color: Colors.indigoAccent),
                              ),
                            ),
                          ]
                        ),

                          SizedBox(height: mq.height*0.025,),

                        // email
                        Text(widget.user.email!,
                        style: TextStyle(
                          color: Colors.black54,fontSize: 13
                        ),),

                        SizedBox(height: mq.height*0.05,),

                        // name and about of user
                        Padding(
                          padding: EdgeInsets.only(left: 6,right: 6),
                          child: TextFormField(
                            initialValue: widget.user.name,
                            onSaved: (new_name) => API.me.name = new_name ?? '' ,
                            validator: (new_name) => ((new_name != null) && (new_name.isNotEmpty)) ? null : 'Required Feild',
                            scrollPadding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom+40),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            decoration:InputDecoration(
                              prefixIcon: Icon(Icons.person,color: Colors.indigoAccent,),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              hintText: "ex:Srinivas",
                              label: Text("Name",style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.indigoAccent
                              ),)
                            ),
                          ),
                        ),

                        SizedBox(height: mq.height*0.016,),

                        Padding(
                          padding: EdgeInsets.only(left: 6,right: 6,),
                          child: TextFormField(
                            initialValue: widget.user.about,
                            onSaved: (new_about) => API.me.about = new_about ?? '' ,
                            validator: (new_about) => ((new_about != null) && (new_about.isNotEmpty)) ? null : '^ Required Feild',
                          scrollPadding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom+40),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.info,color: Colors.indigoAccent,),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                hintText: "ex:Sleepy",
                                label: Text("About",style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.indigoAccent
                                ),)
                            ),
                          ),
                        ),

                        SizedBox(height: mq.height*0.03,),

                        SizedBox(
                          height: mq.height * 0.06,
                          width: mq.width * 0.45,
                          child: ElevatedButton(
                            onPressed: () {
                              if(form_key.currentState!.validate()){

                    // When the submit button is pressed, we call currentState on the form key to get the FormState object.
                    //  provides methods  to interact with state of the form, including validation, data retrieval, and submission.
                                log("inside validator");
                                form_key.currentState!.save();
                                API.update_user();
                                Dialogs.showSnackbar(context,"Profile Update Successfully!");
                              }
                            },
                            style: ButtonStyle(
                              elevation:MaterialStateProperty.all<double>(6),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.indigoAccent), // Set the background color
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center, // Align children to the center horizontally
                              children: [
                                Icon(Icons.edit, size: 25, color: Colors.white), // Icon on the left
                                SizedBox(width: 8), // Add some spacing between the icon and the label
                                Text(
                                  "Update",
                                  style: TextStyle(fontSize: 14, color: Colors.white),
                                ), // Label in the middle
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 40,)
                      ],

                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }

  void _showbottom_sheet(){
    showModalBottomSheet(context: context,shape:RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topRight: Radius.circular(8),topLeft: Radius.circular(8))
    ) ,builder:(_){
      return Container(
        height: mq.height*0.32,
        width: mq.width*0.99,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), // Top-left corner radius
            topRight: Radius.circular(20), // Top-right corner radius
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Pick Profile Photo",style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700
              ),),
            ),
            SizedBox(height: mq.height*0.02,),
            Row(
              mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
              children: [
                  ElevatedButton(onPressed: () async {
                    final ImagePicker picker = ImagePicker(); // Pick an image.
                    final XFile? photo = await picker.pickImage(source: ImageSource.gallery,imageQuality: 100);
                    if(photo != null){
                      print("Image path : ${photo.path}");
                      setState(() {
                        _image = photo.path;
                      });
                      API.update_dp_firestorage(File(photo!.path)).then((value) {
                        print("image upload success");
                      });
                      Navigator.pop(context);
                    }

                  },
                   child: SvgPicture.asset("Assets/images/add-image-svgrepo-com.svg",width: mq.width*0.25,height :mq.height*0.12),
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Colors.white,
                    shape: CircleBorder(),
                    fixedSize: Size(mq.width*0.3, mq.height*0.18)
                  ),),

                ElevatedButton(onPressed: () async {
                  final ImagePicker picker = ImagePicker(); // Pick an image from camera
                  final XFile? photo = await picker.pickImage(source: ImageSource.camera,imageQuality: 100);
                  if(photo != null) {
                    print("Image path : ${photo.path}");
                    setState(() {
                      _image = photo.path;
                    });
                    API.update_dp_firestorage(File(photo!.path)).then((value) {
                      print("cam image successful");
                    });
                    Navigator.pop(context);
                  }
                },
                    child: SvgPicture.asset("Assets/images/camera.svg",width: mq.width*0.25,height :mq.height*0.12) ,
                    style: ElevatedButton.styleFrom(
                    // backgroundColor: Colors.white,
                    shape: CircleBorder(),
                    fixedSize: Size(mq.width*0.3, mq.height*0.18)
                    )
                ),
                SizedBox(height: mq.height*0.1,)
              ],
            )
          ],
        ),

      );
    });
  }

}
