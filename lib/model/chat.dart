import 'dart:convert';

import 'package:chat_app_flutter/model/message.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Chat {
  String? id;
  List<String>? participants;
  List<Message>? messages;

  Chat({
    required this.id,
    required this.participants,
    required this.messages,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'participants': participants,
      'messages': messages?.map((m) => m.toMap()).toList(),
    };
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as String?,
      participants: List<String>.from(json['participants'] as List<dynamic>),
      messages: (json['messages'] as List<dynamic>)
          .map((m) => Message.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());
}
