import 'package:btr_chat/helper/my_date_util.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';
import '../classes/message.dart';
import '../main.dart';


class message_card extends StatefulWidget {
  final Msg mess;
  const message_card({super.key,required this.mess});

  @override
  State<message_card> createState() => _message_cardState();
}

class _message_cardState extends State<message_card> {


  @override
  Widget build(BuildContext context) {
    return API.user.uid == widget.mess.fromId ? green() : blue() ;
  }

  // Sender blue message design
  Widget blue(){
    // If you see others message then it will be updated to him
    if( widget.mess.read!.isEmpty){
      print("hello read is empty : ${widget.mess.read}");
      API.update_msg_read_status(widget.mess);
    }
    else{
      print("going to else : ${widget.mess.read}");
    }
    return  Row(
      children: [
        Container(
            margin: EdgeInsets.only(left:mq.width*0.02,right:mq.width*0.02,top:mq.width*0.02),
            padding: EdgeInsets.only(top:mq.width*0.01,right:mq.width*0.01,left:mq.width*0.01,bottom: mq.width*0.02 ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255,221,245,255),// Background color
              borderRadius: BorderRadius.only(topLeft:Radius.circular(20) ,topRight:Radius.circular(20),bottomRight:Radius.circular(20)), // Rounded corners
              border: Border.all(color: Colors.lightBlue, ),
            ),
            child:Row(
                children : [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: mq.width*0.6),
                    child: Container(
                      child:Text(widget.mess.msg ?? "",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16
                        ),
                      ),
                    ),
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                      // for adding time
                      Padding(
                        padding: const EdgeInsets.only(top: 16,left: 5,right: 2),
                        child: Text(MyDateUtil.get_formatted_date(context: context, time: widget.mess.sent.toString()) ?? "",style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 11
                        ),),
                      ),
                      // if(widget.mess.read.toString().isNotEmpty)
                      //   Icon(Icons.done_all_rounded,size: 18,color: Colors.blue.shade900,)
                    ],
                  )
                ])
        ),
      ],
    );

  }

  // Green Our message design
  Widget green(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
                        margin: EdgeInsets.only(left:mq.width*0.02,right:mq.width*0.02,top:mq.width*0.02),
                        padding: EdgeInsets.only(top:mq.width*0.02,right:mq.width*0.01,left:mq.width*0.025,bottom: mq.width*0.02 ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(185,218, 255, 176), // Background color
                          borderRadius: BorderRadius.only(topLeft:Radius.circular(20) ,topRight:Radius.circular(20),bottomLeft:Radius.circular(20)), // Rounded corners
                          border: Border.all(color: Colors.green.shade800 ),
                        ),
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children : [
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: mq.width*0.7),
                                  child: Container(
                                    child:Text(widget.mess.msg ?? "",
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: mq.width*0.05,)
                               ]
                               ),
                                 Row(
                                     mainAxisAlignment: MainAxisAlignment.end,
                                     crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          // for adding time
                                          Padding(
                                            padding: EdgeInsets.all(0),
                                            // padding: const EdgeInsets.only(top: 16,left: 5,right: 1),
                                            child: Text(MyDateUtil.get_formatted_date(context: context, time: widget.mess.sent.toString()) ?? "",style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 11
                                            ),),
                                          ),
                                          widget.mess.read.toString().isNotEmpty
                                              ? Icon(Icons.done_all_rounded, size: 18, color: Colors.blue.shade900)
                                              : SizedBox(),
                                        ],
                                          ),
                                            ]),

        ),
      ],
    );
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.end,
    //   crossAxisAlignment: CrossAxisAlignment.end,
    //   children: [
    //     Container(
    //       margin: EdgeInsets.all(mq.width*0.02),
    //       padding: EdgeInsets.only(top:mq.width*0.02,left:mq.width*0.01,right: mq.width*0.03,bottom: mq.width*0.03 ),
    //       decoration: BoxDecoration(
    //         color: Color.fromARGB(255,218, 255, 176), // Background color
    //         borderRadius: BorderRadius.only(topLeft:Radius.circular(14) ,topRight:Radius.circular(14),bottomLeft:Radius.circular(15)), // Rounded corners
    //         border: Border.all(color: Colors.green, ),
    //       ),
    //       child: Row(
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.only(top: 14,right: 5),
    //             child: Text(widget.mess.sent ?? "",style: TextStyle(
    //                 color: Colors.black54,
    //                 fontSize: 10
    //             ),),
    //           ),
    //           Text(widget.mess.msg ?? "",
    //             style: TextStyle(
    //                 color: Colors.black87,
    //                 fontSize: 15.5
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}
