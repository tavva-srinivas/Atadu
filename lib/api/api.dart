import 'dart:developer';

import 'package:btr_chat/classes/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../classes/chat_user.dart';
import 'dart:io';

class API{
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for getting data from cloud_firestore
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for getting data from cloud_storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  //variable to store  the user credentials
  static late Chat_user me;

  // for checking user exsists or not
   static Future<bool> user_exsist() async{
     return (await firestore.collection("Users").doc(auth.currentUser!.uid).get()).exists;
   }

   //  to get current user info and then storing in global variable
  static Future<bool> get_self_info() async {
    try {
      var user = await firestore.collection("Users").doc(auth.currentUser!.uid).get();
      if (user.exists) {
        me = Chat_user.fromJson(user.data()!);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

   // getter function which return of the type """User"""
  // User is a default class ---> for authentication
   static User get user => auth.currentUser!;

   // for creating a new user from the app
   static Future<void> create_user() async{

     final time = DateTime.now().millisecondsSinceEpoch.toString();

     final chatUser = Chat_user(
       // can also write directly write id : auth.currentUser().uid
       id:user.uid,
       name: user.displayName.toString(),
       email: user.email.toString(),
       about: "Hey I am using Atadu ...",
       image: user.photoURL.toString(),
       isOnline: "false",
       last_mes: '',
       lastActive: time,
       pushToken: '',
     );
     return (await firestore.collection("Users").doc(user.uid).set(chatUser.toJson()));
    }

    // get all the user that is displayed in home screen
    static Stream<QuerySnapshot<Map<String, dynamic>>> get_other_users_snapshot(){
      try {
        print("reaching here");
        return API.firestore.collection('Users').where(
            'id', isNotEqualTo: user.uid).snapshots();
      }
      catch(e){
        print("error is ${e}");
        return API.firestore.collection('Users').where(
            'id', isNotEqualTo: user.uid).snapshots();
      }
    }

    // Updating user info
    static Future<void> update_user() async{
     // .update() --> changes in the same document
      // .set() --> add changes to the new document
      await firestore.collection("Users").doc(auth.currentUser!.uid).update({'name':me.name,'about':me.about});
    }

    // Updating profile photo
    static Future<void> update_dp_firestorage(File file)async {

      // File provides methods and properties to read from, write to, and manipulate files.
      final img_type = file.path.split('.').last;

     final ref = await storage.ref().child('profile_imgs/${user.uid}.${img_type}');
        await ref.putFile(file,SettableMetadata(contentType: 'image/$img_type')).then((p0) {
       print("DATA transferred : ${p0.bytesTransferred/1000}kb");
     });
        me.image = await ref.getDownloadURL();
      await firestore.collection("Users").doc(auth.currentUser!.uid).update({'image':me.image});
    }


    ///************Chat related API's******************
  /// Chats(collection) ---> conversation_id(doc) --->messages(collection) --->message(doc

  // for getting conversation_id
  static String get_conversation_id(String id) => user.uid.hashCode  <= id.hashCode
      ? '${user.uid}_${id}'
      : '${id}_${user.uid}';

  // Get the chats    # For fetching data
  static Stream<QuerySnapshot<Map<String, dynamic>>> get_chat_snapshot(Chat_user user){
    return firestore.collection('Chats/${get_conversation_id(user.id!)}/messages').snapshots();
  }


  // for sending messages into the firebase
   static Future<void> send_msg(Chat_user chat_user,String msg) async{

    // message doc(name) --> time that is unique ;)
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    log("Time is ${time.toString()}");

    // message to send
    final Msg chat_msg = Msg(msg: msg,fromId: user.uid,read: "",toId: chat_user.id,type: Type.text,sent: time);
    final ref = firestore.collection('Chats/${get_conversation_id(chat_user.id!)}/messages');
    try {

      // document id --> sent time
      await ref.doc(time).set(chat_msg.toJson()).then((value) {
        print("Succesfully inserted");
        log("inserted in firebase");
      });
    }
    catch(e){print("the error is  : $e");}
   }


   // Updating read status of message
 static Future<void> update_msg_read_status(Msg message) async{
    try{
   final ref = firestore.collection('Chats/${get_conversation_id(message.fromId!)}/messages').doc(message.sent).update({'read':DateTime.now().millisecondsSinceEpoch.toString()});
   }
   catch(e){
      print(e);
   }
 }

 // getting the last message of the user
 static Stream<QuerySnapshot<Map<String, dynamic>>> last_msg(Chat_user user){
   return firestore.collection('Chats/${get_conversation_id(user.id!)}/messages').orderBy('sent',descending: true).limit(1).snapshots();
 }


}