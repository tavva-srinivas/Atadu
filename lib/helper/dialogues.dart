import 'package:flutter/material.dart';

class Dialogs{
  // Can be called from any class using this class name

  static void showSnackbar(BuildContext context,String msg){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg,
        textAlign: TextAlign.center,),
          backgroundColor: Colors.blue.withOpacity(0.8),
          behavior: SnackBarBehavior.floating,
        ),
    );}

  static void show_progress_bar(BuildContext context){
    showDialog(context: context, builder: (context)=>
        const Center(child: CircularProgressIndicator())
    );
  }



}