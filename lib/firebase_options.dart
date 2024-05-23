// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBK0L4-FV--1HPAJiwuo8MJzH3yVTr6M6k',
    appId: '1:230732874153:web:81ed729330447e40fb84b8',
    messagingSenderId: '230732874153',
    projectId: 'chatappflutter-c26ec',
    authDomain: 'chatappflutter-c26ec.firebaseapp.com',
    storageBucket: 'chatappflutter-c26ec.appspot.com',
    measurementId: 'G-B3M10XQD83',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCCsyszeySWOEhxpwZcqARku4c2_SGAlEc',
    appId: '1:230732874153:android:8fb1d66c94f10e1cfb84b8',
    messagingSenderId: '230732874153',
    projectId: 'chatappflutter-c26ec',
    storageBucket: 'chatappflutter-c26ec.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCV_q6QTyyOs0FebIB9Gi-fkqDHnqPgA7I',
    appId: '1:230732874153:ios:53450fbc81c3a1ccfb84b8',
    messagingSenderId: '230732874153',
    projectId: 'chatappflutter-c26ec',
    storageBucket: 'chatappflutter-c26ec.appspot.com',
    iosBundleId: 'com.example.chatAppFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCV_q6QTyyOs0FebIB9Gi-fkqDHnqPgA7I',
    appId: '1:230732874153:ios:53450fbc81c3a1ccfb84b8',
    messagingSenderId: '230732874153',
    projectId: 'chatappflutter-c26ec',
    storageBucket: 'chatappflutter-c26ec.appspot.com',
    iosBundleId: 'com.example.chatAppFlutter',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBK0L4-FV--1HPAJiwuo8MJzH3yVTr6M6k',
    appId: '1:230732874153:web:81aa881ff4ca165ffb84b8',
    messagingSenderId: '230732874153',
    projectId: 'chatappflutter-c26ec',
    authDomain: 'chatappflutter-c26ec.firebaseapp.com',
    storageBucket: 'chatappflutter-c26ec.appspot.com',
    measurementId: 'G-2XYBEXJKFV',
  );
}
