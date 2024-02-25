import 'dart:convert';
import 'dart:developer';

import 'package:btr_chat/Widgets/message_card.dart';
import 'package:btr_chat/classes/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../api/api.dart';
import '../classes/message.dart';
import '../main.dart';


class Chat_Screen extends StatefulWidget {

  final Chat_user user;
  const Chat_Screen({super.key,required this.user});

  @override
  State<Chat_Screen> createState() => _Chat_ScreenState();
}

class _Chat_ScreenState extends State<Chat_Screen> {


  // Storing messages
  late List<Msg> mess ;

  // controller for sending text
  final _text_controller  = TextEditingController();

  //for showing or hiding emojy
  bool _show_emojy = false;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
         onWillPop:(){
            if(_show_emojy){
              setState(() {
              _show_emojy = false;
            });
              return Future.value(false);
            }else{
            return Future.value(true);
            }
        },
        child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.indigoAccent.shade200,
                automaticallyImplyLeading: false,
                flexibleSpace: SafeArea(child: _appbar()),

              ),
            backgroundColor: Color.fromARGB(235,225, 240, 255),
            body: Column(
              children: [
                _chatinput(),

                    // condition to show emojy
                    _show_emojy == true ?
                    SizedBox(
                      child: EmojiPicker(
                      onBackspacePressed: () {
                      // Do something when the user taps the backspace button (optional)
                      // Set it to null to hide the Backspace-Button
                      },
                      textEditingController: _text_controller, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                      config: Config(
                      height: mq.height*0.32,
                      // bgColor: const Color(0xFFF2F2F2),
                      checkPlatformCompatibility: true,
                      emojiViewConfig: EmojiViewConfig(
                      // Issue: https://github.com/flutter/flutter/issues/28894
                      emojiSizeMax: 32 *
                      (foundation.defaultTargetPlatform == TargetPlatform.iOS
                      ?  1.20
                          :  1.0),
                      ),
                      swapCategoryAndBottomBar:  false,
                      skinToneConfig: const SkinToneConfig(),
                      categoryViewConfig: const CategoryViewConfig(),
                      bottomActionBarConfig: const BottomActionBarConfig(),
                      searchViewConfig: const SearchViewConfig(),
                      ),
                      ),
                    )
                        : SizedBox()
              ],
            ),
          ),
      ),
    );
  }

  Widget _appbar(){
    return InkWell(
      onTap: (){},
      child: Container(
        height: 100,
        color: Colors.indigoAccent.shade200,
        child: Row(
          children: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back_ios_new,size: 22,),color: Colors.white,),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                width: mq.height*0.05,
                height: mq.height*0.05,
                imageUrl: widget.user.image!,
                // placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>  const CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(CupertinoIcons.person,color: Colors.white,),
                ),
              ),
            ),
            SizedBox(width: mq.width*0.05,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.user.name!,style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500
                ),),
                Text(widget.user.lastActive!,style:TextStyle(
                  fontSize: 12,
                  color: Colors.white
                ) ,)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _chatinput(){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.indigoAccent.shade200, // Set your desired color here
    ));

    return  Flexible(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: mq.height*0.85
        ),
        child: Column(
          children: [
            Flexible(
              child: StreamBuilder(
                stream:API.get_chat_snapshot(widget.user),
                // Snapshot --> tells about data retrieved from database --->
                // like any error, accessing data of database , any changes etc
                // stream:API.get_other_users_snapshot(),
                // has greater purpose when data is changed
                builder:(context,snapshot){

                  // Showing loading when fetching data
                  switch(snapshot.connectionState){

                    case ConnectionState.waiting:
                    //     It might happen before the stream is actively connected or after it has been closed.
                    //     In practical terms, it often means that no initial data has been emitted from
                    //     the stream yet, or the stream has terminated without emitting any data.
                    //     the stream has terminated without emitting any data.
                    case ConnectionState.none:
                      return SizedBox();

                  // if some or all data is loading then show it
                    case ConnectionState.active:
                    case ConnectionState.done:
                    // final data = snapshot.data?.docs;
                    // // if it is not null execute this otherwise return [];
                    // users = data?.map((e) => Chat_user.fromJson(e.data())).toList() ?? [];

                    final data = snapshot.data?.docs;
                    // print(jsonEncode(data![0].data()));
                     print("Name  : ${API.user.uid}");
                    mess = data?.map((e) => Msg.fromJson(e.data())).toList() ?? [];

                    if(mess.isNotEmpty) {
                        //messages
                        return ListView.builder(
                          // bounce effect when scrolled
                            padding: const EdgeInsets.only(top: 12),
                            physics: const BouncingScrollPhysics(),
                            itemCount: mess.length,
                            itemBuilder: (context, index) {
                              print("Users \n${mess.length}");
                              // print(users[index]["last_mes"]);
                              return message_card(mess: mess[index]);
                            });
                      }
                      else{
                        return Center(
                          child: const Text("Say Hii! 👋",style: TextStyle(
                            fontSize:22,
                            fontWeight: FontWeight.w300,
                          ),textAlign: TextAlign.center,),
                        );
                      }
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      children: [
                        SizedBox(width:10,),
                        IconButton(onPressed: () {
                           FocusScope.of(context).unfocus();
                          setState(() {
                            _show_emojy = !_show_emojy;
                            print("show emojy is $_show_emojy");
                          });
                        },
                           icon: Icon(Icons.emoji_emotions_rounded,color: Colors.blue.shade400,)
                        ),
                        SizedBox(width:10,),

                        //write message
                        // Expanded(
                        //   // Texting
                        //     child:TextField(
                        //       controller: _text_controller,
                        //       keyboardType: TextInputType.multiline,
                        //       maxLines: null,
                        //       decoration: InputDecoration(
                        //           hintText: "Type something ...",
                        //           hintStyle: TextStyle(color: Colors.indigoAccent.withOpacity(0.5),
                        //               fontWeight: FontWeight.w400),
                        //           border: InputBorder.none
                        //       ),
                        //     )
                        // ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              constraints: BoxConstraints(maxHeight: 200), // Set the maximum height here
                              child: TextField(
                                onTap: (){
                                  if(_show_emojy){
                                    setState(() {
                                      _show_emojy = false;
                                    });
                                  }
                                },
                                controller: _text_controller,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                  hintText: "Type something ...",
                                  hintStyle: TextStyle(color: Colors.indigoAccent.withOpacity(0.5), fontWeight: FontWeight.w400),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width:10,),
                        Icon(Icons.image,color: Colors.blue.shade400,),
                        SizedBox(width:10,),
                        Icon(Icons.camera_alt,color: Colors.blue.shade400,),
                        SizedBox(width:10,),
                      ],
                    ),
                  ),
                ),

                // Send icon
                MaterialButton(
                    onPressed:(){
                      print("reaching material button");
                      print(_text_controller.text.isNotEmpty);
                      if( _text_controller.text.isNotEmpty) {
                        log("Reaching if");
                        print("inside if");
                        API.send_msg(widget.user, _text_controller.text).then((value) => log("Updated in firebase"));
                        _text_controller.text = '';
                      }
                    },
                    minWidth: 0,
                    color: Colors.green,
                    padding: EdgeInsets.only(left:10,right: 6,top: 10,bottom: 10),
                    shape: CircleBorder(),
                    child:Icon(Icons.send,color:Colors.white,size: 25,)
                ),
                SizedBox(width:mq.width*0.01,)
              ],
            ),
            // SizedBox(height: mq.height*0.05,)
          ],
        // ),
        ),
      ),
    );


  }
}
