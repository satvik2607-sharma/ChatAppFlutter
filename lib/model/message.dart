// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { Text, Image }

class Message {
  String? senderId;
  String? content;
  MessageType? messageType;
  Timestamp? sentAt;
  Message({
    required this.senderId,
    required this.content,
    required this.sentAt,
    required this.messageType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'content': content,
      'sentAt': sentAt,
      'messageType': messageType!.name
    };
  }

  Message.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    content = json['content'];
    sentAt = json['sentAt'];
    messageType = MessageType.values.byName(json['messageType']);
  }
}
