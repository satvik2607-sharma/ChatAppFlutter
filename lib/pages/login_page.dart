import 'package:chat_app_flutter/consts.dart';
import 'package:chat_app_flutter/services/alert_service.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:chat_app_flutter/services/navigation_service.dart';
import 'package:chat_app_flutter/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> loginFormKey = GlobalKey();
  String? email;
  String? password;

  final GetIt getIt = GetIt.instance;

  late AuthService authService;
  late NavigationService navigationService;
  late AlertService alertService;

  @override
  void initState() {
    super.initState();
    authService = getIt.get<AuthService>();
    navigationService = getIt.get<NavigationService>();
    alertService = getIt.get<AlertService>();
  }

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
            _loginForm(),
            _createAccountText(),
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
            'Hi, Welcome Back!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Text(
            'Hello again, you have been missed',
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

  Widget _loginForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.05),
      child: Form(
        key: loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            _loginButton(),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        onPressed: () async {
          if (loginFormKey.currentState?.validate() ?? false) {
            loginFormKey.currentState?.save();
            bool result = await authService.login(email!, password!);
            print(result);
            if (result) {
              navigationService.pushReplacementNamed('/home');
              alertService.showToast(
                  text: 'Successfully Logged in', icon: Icons.check);
            } else {
              alertService.showToast(
                  text: 'Error logging in', icon: Icons.error);
            }
          }
        },
        color: Theme.of(context).primaryColor,
        child: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _createAccountText() {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text("Don't have an account? "),
          GestureDetector(
            onTap: () {
              navigationService.pushReplacementNamed("/register");
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          )
        ],
      ),
    );
  }
}
