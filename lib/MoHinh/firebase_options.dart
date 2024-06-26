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
    apiKey: 'AIzaSyD3MzYLFF3JQk_iRLcMgzaUvj0Oc_6ozMQ',
    appId: '1:638551450653:web:7bd3471e8bf8d07a7152f4',
    messagingSenderId: '638551450653',
    projectId: 'gamesudoku-170ad',
    authDomain: 'gamesudoku-170ad.firebaseapp.com',
    storageBucket: 'gamesudoku-170ad.appspot.com',
    measurementId: 'G-D271712QN2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBCJ7ItXJC4uic9Uz83aItStCS02fxmDlc',
    appId: '1:638551450653:android:9c85feb93330fd7d7152f4',
    messagingSenderId: '638551450653',
    projectId: 'gamesudoku-170ad',
    storageBucket: 'gamesudoku-170ad.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAWrzP3uF1ZhjYwY1a6f7rzDBfniokSwCM',
    appId: '1:638551450653:ios:47164c87dfbccf797152f4',
    messagingSenderId: '638551450653',
    projectId: 'gamesudoku-170ad',
    storageBucket: 'gamesudoku-170ad.appspot.com',
    iosBundleId: 'com.example.sudoku',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAWrzP3uF1ZhjYwY1a6f7rzDBfniokSwCM',
    appId: '1:638551450653:ios:47164c87dfbccf797152f4',
    messagingSenderId: '638551450653',
    projectId: 'gamesudoku-170ad',
    storageBucket: 'gamesudoku-170ad.appspot.com',
    iosBundleId: 'com.example.sudoku',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD3MzYLFF3JQk_iRLcMgzaUvj0Oc_6ozMQ',
    appId: '1:638551450653:web:7118a0ac32083d097152f4',
    messagingSenderId: '638551450653',
    projectId: 'gamesudoku-170ad',
    authDomain: 'gamesudoku-170ad.firebaseapp.com',
    storageBucket: 'gamesudoku-170ad.appspot.com',
    measurementId: 'G-72G9FTEY3W',
  );
}
