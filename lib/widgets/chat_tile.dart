import 'package:chat_app_flutter/model/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final UserProfile userProfile;
  final Function onTap;
  ChatTile({super.key, required this.userProfile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      dense: false,
      title: Text(userProfile.name!),
    );
  }
}
