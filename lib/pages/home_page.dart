import 'package:chat_app_flutter/model/user_profile.dart';
import 'package:chat_app_flutter/pages/chat_page.dart';
import 'package:chat_app_flutter/services/alert_service.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:chat_app_flutter/services/database_service.dart';
import 'package:chat_app_flutter/services/navigation_service.dart';
import 'package:chat_app_flutter/widgets/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthService authService;
  late NavigationService navigationService;
  late AlertService alertService;
  late DatabaseService databaseService;

  final GetIt getIt = GetIt.instance;

  @override
  void initState() {
    authService = getIt.get<AuthService>();
    navigationService = getIt.get<NavigationService>();
    alertService = getIt.get<AlertService>();
    databaseService = getIt.get<DatabaseService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Messages",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              bool result = await authService.logout();
              if (result) {
                navigationService.pushReplacementNamed("/login");
                alertService.showToast(
                    text: 'Successfully logged out!', icon: Icons.check);
              } else {
                alertService.showToast(
                    text: 'Error logging out!', icon: Icons.error);
              }
            },
            icon: Icon(Icons.logout),
            color: Colors.red,
          )
        ],
      ),
      body: _buildUi(),
    );
  }

  Widget _buildUi() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: _chatsList(),
      ),
    );
  }

  Widget _chatsList() {
    return StreamBuilder(
        stream: databaseService.getUserProfiles(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final users = snapshot.data!.docs;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                UserProfile user = users[index].data();
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ChatTile(
                    userProfile: user,
                    onTap: () async {
                      final chatExists = await databaseService.checkChatExists(
                          authService.user!.uid, user.uid!);
                      if (!chatExists) {
                        await databaseService.createNewChat(
                            authService.user!.uid, user.uid!);
                      }
                      navigationService.push(
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            chatUser: user,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Unable to load data'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
