// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCwrnLrPDwubymVWLWalyrrzKEG1lufM9A',
    appId: '1:215235023497:web:30b5609d5b7ebfac67ec58',
    messagingSenderId: '215235023497',
    projectId: 'saasify-dev',
    authDomain: 'saasify-dev.firebaseapp.com',
    storageBucket: 'saasify-dev.appspot.com',
    measurementId: 'G-CNE64HGRSN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlnHI3D4ru4ajgfst2o0a2qR_-yYUJFwI',
    appId: '1:215235023497:android:dbb90efee11505d767ec58',
    messagingSenderId: '215235023497',
    projectId: 'saasify-dev',
    storageBucket: 'saasify-dev.appspot.com',
  );
}
