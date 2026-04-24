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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAtk1t7x4iBQsRLMhaL_fs-jvVrYT-wC1g',
    appId: '1:682905339476:web:a44f5be83b90af5f5e4fc1',
    messagingSenderId: '682905339476',
    projectId: 'reelzo-da371',
    authDomain: 'reelzo-da371.firebaseapp.com',
    databaseURL: 'https://reelzo-da371-default-rtdb.firebaseio.com',
    storageBucket: 'reelzo-da371.firebasestorage.app',
    measurementId: 'G-Q05NKZ2CX3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtmEA5_SeOHmF0yYsxO8em3vPjdZkmS0g',
    appId: '1:682905339476:android:68fd12a78190ac6c5e4fc1',
    messagingSenderId: '682905339476',
    projectId: 'reelzo-da371',
    databaseURL: 'https://reelzo-da371-default-rtdb.firebaseio.com',
    storageBucket: 'reelzo-da371.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOVaxubdjybw3vfRB5n8O5HljtKRpRKgI',
    appId: '1:682905339476:ios:ac1365715be1ae025e4fc1',
    messagingSenderId: '682905339476',
    projectId: 'reelzo-da371',
    databaseURL: 'https://reelzo-da371-default-rtdb.firebaseio.com',
    storageBucket: 'reelzo-da371.firebasestorage.app',
    iosBundleId: 'reelzo.honab.com',
  );
}