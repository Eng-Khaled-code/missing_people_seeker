
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web =FirebaseOptions(
      apiKey: "AIzaSyCboxWjpjnFPrT9bfcc4iLetNxZDAr5Qzc",
      authDomain: "mpss-d477f.firebaseapp.com",
      projectId: "mpss-d477f",
      storageBucket: "mpss-d477f.appspot.com",
      messagingSenderId: "941095566314",
      appId: "1:941095566314:web:ca6f3ec94628a535d2d093",
      measurementId: "G-BPZQCFX6RV"
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyAvrSyuv1BUQkh5bXeCpC07siuAmGuP2mI",
    appId: '1:941095566314:android:3a5e2a0b2e6ad101d2d093',
    messagingSenderId: '941095566314',
    projectId: 'mpss-d477',
    databaseURL: "https://mpss-d477.firebaseio.com",
    storageBucket: "mpss-d477.appspot.com",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBHiU8thwitS0nvLM9eGa3wPt_vniE4NI0',
    appId: '1:941095566314:ios:566be9d07195c056d2d093',
    messagingSenderId: '941095566314',
    projectId: 'mpss-d477',
    databaseURL: "https://mpss-d477.firebaseio.com",
    storageBucket: "mpss-d477.appspot.com",
    iosBundleId: 'com.engoo.finalmps',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBHiU8thwitS0nvLM9eGa3wPt_vniE4NI0',
    appId: '1:941095566314:ios:566be9d07195c056d2d093',
    messagingSenderId: '941095566314',
    projectId: 'mpss-d477',
    databaseURL: "https://mpss-d477.firebaseio.com",
    storageBucket: "mpss-d477.appspot.com",
    iosBundleId: 'com.engoo.finalmps',
  );
}