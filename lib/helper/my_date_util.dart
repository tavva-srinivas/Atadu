import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDateUtil{
  static String get_formatted_date({required BuildContext context,required String time}){

    final date = DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  // if last mesage time is not today then we show date otherwise we show time

  // get last message time (in chat )
  static String get_last_msg_time({required BuildContext context,required String sent_milli }){
    final DateTime sent = DateTime.fromMicrosecondsSinceEpoch(int.parse(sent_milli));
    final DateTime now = DateTime.now();
    if(sent.day == now.day && sent.month == now.month && now.year == sent.year){
      return TimeOfDay.fromDateTime(sent).format(context);
    }


    return "${sent.day} ${_getmonth(sent.month)}";
  }


    static String _getmonth(int month){
      if(month == 1){
        return "Jan";
      }
      else if(month == 2){
        return "Feb";
      }
      else if(month == 3){
        return "Mar";
      }
      else if(month == 4){
        return "Apr";
      }
      else if(month == 5){
        return "May";
      }
      else if(month == 6){
        return "Jun";
      } else if(month == 7){
        return "Jul";
      } else if(month == 8){
        return "Aug";
      }
      else if(month == 9){
        return "Sep";
      } else if(month == 10){
        return "Oct";
      } else if(month == 11){
        return "Nov";
      } else{
        return "Dec";
      }
    }
}