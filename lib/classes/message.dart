import 'package:flutter/material.dart';

class Msg {
  String? msg;
  String? fromId;
  String? read;
  String? toId;
  Type? type;
  String? sent;

  Msg(
      { this.msg, this.fromId, this.read, this.toId, this.type, this.sent});

  //This constructor takes a JSON object as input and extracts values
  // from it to initialize the properties of the Msg object.
  Msg.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();;
    fromId = json['from_id'].toString();
    read = json['read'].toString();
    toId = json['to_id'].toString();
    // .name is a property when wee use .name it return enumtype in string
  // like Type.image.name return string "image"
    // here ""type""" variable just represents a ""text"" or ""image""
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // to remove null errors we are using toString
    data['msg'] = this.msg;
    data['from_id'] = this.fromId;
    data['read'] = this.read;
    data['to_id'] = this.toId;
    data['type'] = this.type.toString();
    data['sent'] = this.sent;
    return data;
  }
}

enum Type{
  text,
  image
}

