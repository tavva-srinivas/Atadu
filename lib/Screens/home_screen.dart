import 'package:btr_chat/Screens/profile_screen.dart';
import 'package:btr_chat/Widgets/chat_card.dart';
import 'package:btr_chat/api/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:btr_chat/classes/chat_user.dart';


class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.In,));
     API.get_self_info();
    super.initState();
  }

  List<Chat_user> users = [];

  List<Chat_user> _filter_users = [];
  bool _issearching = false;

  @override
  Widget build(BuildContext context) {
    // when searching if we press anywhere outside keyboard should close
    return GestureDetector(
       onTap: () => FocusScope.of(context).unfocus(),

      child: WillPopScope(
        // aim when searching is on if he press back button then it should go out of searching mode into home
        // pop scope triggers when pressed back button
        onWillPop:(){
          if(_issearching){
            setState(() {
              _issearching = false;
            });
            return Future.value(false);
          }else{
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigoAccent.shade200,
            centerTitle: true,
            elevation: 5,
            title: _issearching ? TextField(
              // writing cursor deoesnt come as soon as we press the textfield so autofocus
               autofocus: true,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,letterSpacing: 0.2
              ),
              onChanged: (search_string){
                _filter_users.clear();
                 // Search logic
                for(var i in users){
                  if(i.name!.toLowerCase().contains(search_string) || i.name!.toLowerCase().contains(search_string)){
                    _filter_users.add(i);
                  }
                  setState(() {
                    _filter_users;
                  });
                }
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Name,Email ...',
                hintStyle: TextStyle(
                  color: Colors.white
                ),
                prefixIcon: Icon(Icons.search,color: Colors.white,),
              ),
            ) : Text("Atadu",style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 25,
              color: Colors.white
            ),),
            actions: [
              IconButton(onPressed: (){
                setState(() {
                  _issearching = !_issearching;
                });
              }, icon:
              Icon(_issearching ?
                    CupertinoIcons.clear_circled_solid : Icons.search,color: Colors.white,)),
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder:(context) => Profile_Screen(user: API.me,)));
              }, icon: const Icon(Icons.more_vert_sharp,color: Colors.white)),
            ],
          ),
        
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FloatingActionButton(
              backgroundColor: Colors.indigoAccent,
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
              },
              child: const Icon(Icons.add,size: 34,color: Colors.white,),
            ),
          ),
        
          // asynchronously building widgets ---> used for real time updates
          body: StreamBuilder(
        
            // Snapshot --> tells about data retrieved from database --->
            // like any error, accessing data of database , any changes etc
            stream:API.get_other_users_snapshot(),
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
                  return const Center(child: CircularProgressIndicator(),);
        
                // if some or all data is loading then show it
                case ConnectionState.active:
                case ConnectionState.done:

                  final data = snapshot.data?.docs;
                  // if it is not null execute this otherwise return [];
                  users = data?.map((e) => Chat_user.fromJson(e.data())).toList() ?? [];
                  if(users.isNotEmpty) {
                    print("Going to if");
                    print("length is ${users.length}");
                    return ListView.builder(
                      // bounce effect when scrolled
                        padding: const EdgeInsets.only(top: 12),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _issearching ? _filter_users.length :users.length,
                        itemBuilder: (context, index) {
                          print("Users \n${users.length}");
                          // print(users[index]["last_mes"]);
                          return Chat_card(user:_issearching ? _filter_users[index] : users[index]);
                        });
                  }
                  else{
                    return const Text("No Connections Found :(",style: TextStyle(
                      fontSize:18,
                      fontWeight: FontWeight.w400,
                    ),textAlign: TextAlign.center,);
                  }
              }


            //   if(snapshot.hasData){
            //     final data = snapshot.data?.docs;
            //     for(var i in data!){
            //       list.add(i.data());
            //        print('Data ${jsonEncode(i.data())}');
            //     }
            //   }
            //   else{
            //     print("No data");
            //   }
            // return ListView.builder(
            //   // bounce effect when scrolled
            //   padding: EdgeInsets.only(top: 12),
            //   physics: BouncingScrollPhysics(),
            //   itemCount:list.length,
            //   itemBuilder: (context,index){
            //     print("\n${list.length}");
            //     print(list[index]["last_mes"]);
            //   return Chat_card(list[index]["name"],list[index]["last_msg"],list[index]["last_active"]);
            // });


            },
          ),
        ),
      ),
    );
  }
}
