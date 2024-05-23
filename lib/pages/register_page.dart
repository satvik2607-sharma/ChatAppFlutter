import 'dart:io';

import 'package:chat_app_flutter/consts.dart';
import 'package:chat_app_flutter/model/user_profile.dart';
import 'package:chat_app_flutter/services/alert_service.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:chat_app_flutter/services/database_service.dart';
import 'package:chat_app_flutter/services/navigation_service.dart';
import 'package:chat_app_flutter/widgets/custom_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> registerFormKey = GlobalKey();
  String? email;
  String? password;
  String? name;

  final GetIt getIt = GetIt.instance;
  late AuthService authService;
  late NavigationService navigationService;
  late AlertService alertService;
  bool isLoading = false;
  late DatabaseService databaseService;

  @override
  void initState() {
    authService = getIt.get<AuthService>();
    navigationService = getIt.get<NavigationService>();
    alertService = getIt.get<AlertService>();
    databaseService = getIt.get<DatabaseService>();
    super.initState();
  }

  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUi(),
    );
  }

  Widget _buildUi() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            _headerText(),
            if (!isLoading) _registerForm(),
            if (!isLoading) _alreadyHaveAccountText(),
            if (isLoading)
              Expanded(
                child: Center(
                  child: const CircularProgressIndicator(),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hi there!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Text(
            'Register yourself to get started',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.05),
      child: Form(
        key: registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // _pfpSelectionField(),
            CustomFormField(
              validationRegEx: NAME_VALIDATION_REGEX,
              height: MediaQuery.sizeOf(context).height * 0.1,
              hintText: 'Name',
              onSaved: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            CustomFormField(
              validationRegEx: EMAIL_VALIDATION_REGEX,
              height: MediaQuery.sizeOf(context).height * 0.1,
              hintText: 'Email',
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            CustomFormField(
              ObsecureText: true,
              validationRegEx: PASSWORD_VALIDATION_REGEX,
              height: MediaQuery.sizeOf(context).height * 0.1,
              hintText: 'Password',
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            _registerButton(),
          ],
        ),
      ),
    );
  }

  // Widget _pfpSelectionField() {
  //   return CircleAvatar(
  //     radius: MediaQuery.of(context).size.width * 0.15,
  //     backgroundImage: selectedImage != null
  //         ? FileImage(selectedImage!)
  //         : Image.asset('assets/profile_pic.jpg'),
  //   );
  // }

  Widget _registerButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          try {
            if (registerFormKey.currentState?.validate() ?? false) {
              registerFormKey.currentState?.save();
              bool result = await authService.registerUser(email!, password!);
              if (result) {
                await databaseService.createUserProfile(
                  userProfile: UserProfile(
                    uid: authService.user!.uid,
                    name: name,
                  ),
                );
                alertService.showToast(
                  text: 'User Registered Successfully',
                  icon: Icons.check,
                );
                navigationService.pushReplacementNamed("/home");
              }
            }
          } catch (e) {
            print(e);
            alertService.showToast(
                text: 'Error registering user. Please try again',
                icon: Icons.error);
          }
          setState(() {
            isLoading = false;
          });
        },
        color: Theme.of(context).primaryColor,
        child: const Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _alreadyHaveAccountText() {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text("Already have an account? "),
          GestureDetector(
            onTap: () {
              navigationService.pushReplacementNamed("/login");
            },
            child: const Text(
              'Login',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          )
        ],
      ),
    );
  }
}
