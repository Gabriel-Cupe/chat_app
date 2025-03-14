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
  apiKey: 'AIzaSyBlCnGiAaxS9lmERTW07jbgWgtAc8GTzWs',
  appId: '1:64913963017:web:60a7dc7e706d3b2cdde0d8',
  messagingSenderId: '64913963017',
  projectId: 'jandy-6a3e0',
  authDomain: 'jandy-6a3e0.firebaseapp.com',
  storageBucket: 'jandy-6a3e0.firebasestorage.app',
  measurementId: 'G-9774NGN7QR',
  databaseURL: 'https://jandy-6a3e0-default-rtdb.firebaseio.com', // 🔥 Agrega esto
);

static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyDzYgCxZmoCzw4ST4RNYBqifE1Ifq9bRCY',
  appId: '1:64913963017:android:3cf4fb373c5e7f85dde0d8',
  messagingSenderId: '64913963017',
  projectId: 'jandy-6a3e0',
  storageBucket: 'jandy-6a3e0.firebasestorage.app',
  databaseURL: 'https://jandy-6a3e0-default-rtdb.firebaseio.com', // 🔥 Agrega esto
);


  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA9slcdDKYL8fs_BwR_veM33eX3eOQ-J8o',
    appId: '1:64913963017:ios:ad4a4693c28aecaadde0d8',
    messagingSenderId: '64913963017',
    projectId: 'jandy-6a3e0',
    storageBucket: 'jandy-6a3e0.firebasestorage.app',
    iosBundleId: 'com.example.jandy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA9slcdDKYL8fs_BwR_veM33eX3eOQ-J8o',
    appId: '1:64913963017:ios:ad4a4693c28aecaadde0d8',
    messagingSenderId: '64913963017',
    projectId: 'jandy-6a3e0',
    storageBucket: 'jandy-6a3e0.firebasestorage.app',
    iosBundleId: 'com.example.jandy',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBlCnGiAaxS9lmERTW07jbgWgtAc8GTzWs',
    appId: '1:64913963017:web:20091022e51c0951dde0d8',
    messagingSenderId: '64913963017',
    projectId: 'jandy-6a3e0',
    authDomain: 'jandy-6a3e0.firebaseapp.com',
    storageBucket: 'jandy-6a3e0.firebasestorage.app',
    measurementId: 'G-745MFFJ63Y',
  );
}
