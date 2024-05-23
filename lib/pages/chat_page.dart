import 'dart:io';

import 'package:chat_app_flutter/model/chat.dart';
import 'package:chat_app_flutter/model/message.dart';
import 'package:chat_app_flutter/model/user_profile.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:chat_app_flutter/services/database_service.dart';
import 'package:chat_app_flutter/services/media_service.dart';
import 'package:chat_app_flutter/services/storage_service.dart';
import 'package:chat_app_flutter/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';

class ChatPage extends StatefulWidget {
  final UserProfile chatUser;
  ChatPage({super.key, required this.chatUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late AuthService _authService;
  late DatabaseService _databaseService;
  final GetIt getIt = GetIt.instance;
  late MediaService _mediaService;
  late StorageService _storageService;
  ChatUser? currentUser, otherUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authService = getIt.get<AuthService>();
    _databaseService = getIt.get<DatabaseService>();
    _mediaService = getIt.get<MediaService>();
    _storageService = getIt.get<StorageService>();
    currentUser = ChatUser(
      id: _authService.user!.uid,
      firstName: _authService.user!.displayName,
    );
    otherUser =
        ChatUser(id: widget.chatUser.uid!, firstName: widget.chatUser.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatUser.name!),
      ),
      body: _buildUi(),
    );
  }

  Widget _buildUi() {
    return StreamBuilder(
        stream: _databaseService.getChatData(currentUser!.id, otherUser!.id),
        builder: (context, snapshot) {
          Chat? chat = snapshot.data?.data();
          List<ChatMessage> messages = [];
          if (chat != null && chat.messages != null) {
            messages = _generateChatMessageList(chat.messages!);
          }
          return DashChat(
            messageOptions: MessageOptions(
              showTime: true,
              showCurrentUserAvatar: false,
              showOtherUsersAvatar: true,
            ),
            inputOptions: InputOptions(alwaysShowSend: true, trailing: [
              _mediaMessageButton(),
            ]),
            currentUser: currentUser!,
            onSend: sendMessage,
            messages: messages,
          );
        });
  }

  Future<void> sendMessage(ChatMessage chatMessage) async {
    if (chatMessage.medias?.isNotEmpty ?? false) {
      if (chatMessage.medias!.first.type == MediaType.image) {
        Message message = Message(
          senderId: currentUser!.id,
          content: chatMessage.medias!.first.url,
          sentAt: Timestamp.fromDate(chatMessage.createdAt),
          messageType: MessageType.Image,
        );
        await _databaseService.sendChatMessage(
            currentUser!.id, otherUser!.id, message);
      }
    } else {
      Message message = Message(
          senderId: currentUser!.id,
          content: chatMessage.text,
          sentAt: Timestamp.fromDate(chatMessage.createdAt),
          messageType: MessageType.Text);
      await _databaseService.sendChatMessage(
          currentUser!.id, otherUser!.id, message);
    }
  }

  List<ChatMessage> _generateChatMessageList(List<Message> messages) {
    List<ChatMessage> chatMessage = messages.map((m) {
      if (m.messageType == MessageType.Image) {
        return ChatMessage(
            user: m.senderId == currentUser!.id ? currentUser! : otherUser!,
            createdAt: m.sentAt!.toDate(),
            medias: [
              ChatMedia(
                url: m.content!,
                fileName: "",
                type: MediaType.image,
              )
            ]);
      } else {
        return ChatMessage(
          user: m.senderId == currentUser!.id ? currentUser! : otherUser!,
          text: m.content!,
          createdAt: m.sentAt!.toDate(),
        );
      }
    }).toList();
    chatMessage.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return chatMessage;
  }

  Widget _mediaMessageButton() {
    return IconButton(
      onPressed: () async {
        File? file = await _mediaService.getImageFromGallery();
        String chatId =
            generateChatId(uid1: currentUser!.id, uid2: otherUser!.id);
        if (file != null) {
          String? downloadUrl = await _storageService.uploadImageToChat(
              file: file, chatId: chatId);
          if (downloadUrl != null) {
            ChatMessage chatMessage = ChatMessage(
                user: currentUser!,
                createdAt: DateTime.now(),
                medias: [
                  ChatMedia(
                      url: downloadUrl, fileName: "", type: MediaType.image)
                ]);
            sendMessage(chatMessage);
          }
        }
      },
      icon: Icon(
        Icons.image,
        color: Colors.blue,
      ),
    );
  }
}
