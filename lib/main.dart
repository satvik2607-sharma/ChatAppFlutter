import 'package:chat_app_flutter/pages/login_page.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:chat_app_flutter/services/navigation_service.dart';
import 'package:chat_app_flutter/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setup();
  runApp(MyApp());
}

Future<void> setup() async {
  await registerServices();
}

class MyApp extends StatelessWidget {
  final GetIt getIt = GetIt.instance;
  late NavigationService navigationService;
  late AuthService authService;
  MyApp({super.key}) {
    navigationService = getIt.get<NavigationService>();
    authService = getIt.get<AuthService>();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigationService.navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      routes: navigationService.routes,
      initialRoute: authService.user != null ? "/home" : "/login",
      debugShowCheckedModeBanner: false,
    );
  }
}
