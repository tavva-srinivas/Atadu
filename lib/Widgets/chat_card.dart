import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Screens/Chat_sceen.dart';
import '../api/api.dart';
import '../classes/message.dart';
import '../helper/my_date_util.dart';
import '../main.dart';
import '../classes/chat_user.dart';

class Chat_card extends StatefulWidget {
  // Key is an object used to uniquely identify a widget. Every widget can have a Key
  // const Chat_card({super.key});

  Chat_user user;
  Chat_card({super.key, required this.user});

  @override
  State<Chat_card> createState() => _Chat_cardState();
}

class _Chat_cardState extends State<Chat_card> {

  Msg? _mess  ;
   List<Msg> last_msg = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal:4,vertical:5),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => Chat_Screen(user : widget.user)));
        },

        child:StreamBuilder(
          stream: API.last_msg(widget.user),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
           final data = snapshot.data?.docs;
           final last_msg = data?.map((e) => Msg.fromJson(e.data())).toList() ?? [];

          if(last_msg.isNotEmpty) {
            _mess = last_msg[0];
          }
            return ListTile(
// leading: const CircleAvatar(
//   backgroundColor: Colors.teal,
//   child: Icon(CupertinoIcons.person,color: Colors.white,),
// ),
                leading: ClipRRect(
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

                // group name
                title: Text(widget.user.name! ),
                // group last message
                subtitle: Text(_mess != null ? _mess!.msg ?? "" : widget.user.about ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,),

            // group last seen
                // trailing: Text(widget.user.lastActive ?? "",style: const TextStyle(
                //   color: Colors.black54,
                // ),),
              trailing: _mess == null
                  ? null
                  : _mess!.read?.isEmpty == true && _mess!.fromId != API.user.uid
                  ? Container(
                width: mq.height * 0.02,
                height: mq.height * 0.02,
                decoration: BoxDecoration(
                  color: Colors.lightGreenAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
              )
                  : Text(MyDateUtil.get_formatted_date(context: context, time: _mess!.sent!) ),
                );
          }

        )
      ),
    );
  }
}


// ListTile(
// // leading: const CircleAvatar(
// //   backgroundColor: Colors.teal,
// //   child: Icon(CupertinoIcons.person,color: Colors.white,),
// // ),
// leading: ClipRRect(
// borderRadius: BorderRadius.circular(8),
// child: CachedNetworkImage(
// width: mq.height*0.05,
// height: mq.height*0.05,
// imageUrl: widget.user.image!,
// // placeholder: (context, url) => CircularProgressIndicator(),
// errorWidget: (context, url, error) =>  const CircleAvatar(
// backgroundColor: Colors.teal,
// child: Icon(CupertinoIcons.person,color: Colors.white,),
// ),
// ),
// ),
//
// // group name
// title: Text(widget.user.name! ),
// // group last message
// subtitle: Text(widget.user.last_mes ?? "",maxLines: 1,),
// // group last seen
// // trailing: Text(widget.user.lastActive ?? "",style: const TextStyle(
// //   color: Colors.black54,
// // ),),
// trailing: Container(
// width: mq.height*0.01,
// height: mq.height*0.01,
// decoration: BoxDecoration(
// color: Colors.lightGreenAccent,
// borderRadius: BorderRadius.circular(10)
// ),
// ),
// ),
