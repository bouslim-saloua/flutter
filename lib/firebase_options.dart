
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
    apiKey: 'AIzaSyApJbt8stz56_PAcGMWhaalMe0hPYUpy9g',
    appId: '1:1050821731069:web:5f95fcebf0c8ed7bff1494',
    messagingSenderId: '1050821731069',
    projectId: 'atelier-s-bouslim-iir5g7',
    authDomain: 'atelier-s-bouslim-iir5g7.firebaseapp.com',
    storageBucket: 'atelier-s-bouslim-iir5g7.firebasestorage.app',
    measurementId: 'G-PRBMH7E6FT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyADEzNxD_gy46aGk51lsSZBdi338GiHDv0',
    appId: '1:1050821731069:android:a19486cf3f53e042ff1494',
    messagingSenderId: '1050821731069',
    projectId: 'atelier-s-bouslim-iir5g7',
    storageBucket: 'atelier-s-bouslim-iir5g7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAsAOe_dq7DnYg89JxdytJT42JQV0h28JI',
    appId: '1:1050821731069:ios:79d0b480fb6d7543ff1494',
    messagingSenderId: '1050821731069',
    projectId: 'atelier-s-bouslim-iir5g7',
    storageBucket: 'atelier-s-bouslim-iir5g7.firebasestorage.app',
    iosBundleId: 'com.example.produitsapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAsAOe_dq7DnYg89JxdytJT42JQV0h28JI',
    appId: '1:1050821731069:ios:79d0b480fb6d7543ff1494',
    messagingSenderId: '1050821731069',
    projectId: 'atelier-s-bouslim-iir5g7',
    storageBucket: 'atelier-s-bouslim-iir5g7.firebasestorage.app',
    iosBundleId: 'com.example.produitsapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyApJbt8stz56_PAcGMWhaalMe0hPYUpy9g',
    appId: '1:1050821731069:web:d1f1b1516f4526d7ff1494',
    messagingSenderId: '1050821731069',
    projectId: 'atelier-s-bouslim-iir5g7',
    authDomain: 'atelier-s-bouslim-iir5g7.firebaseapp.com',
    storageBucket: 'atelier-s-bouslim-iir5g7.firebasestorage.app',
    measurementId: 'G-3BHT9BBN5F',
  );

}