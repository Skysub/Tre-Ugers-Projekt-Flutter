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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyAwkUCnmFl8HEAYsg9layoqOORlvhqa0G8',
    appId: '1:808817238237:web:b6670c00ee9aa385217b34',
    messagingSenderId: '808817238237',
    projectId: 'klatre-app1',
    authDomain: 'klatre-app1.firebaseapp.com',
    databaseURL: 'https://klatre-app1-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'klatre-app1.appspot.com',
    measurementId: 'G-2FQHRE08NE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYiuYsbJ-tJtwGoMljWHuF0pIaylGHFDk',
    appId: '1:808817238237:android:5d34d4bc6696ac70217b34',
    messagingSenderId: '808817238237',
    projectId: 'klatre-app1',
    databaseURL: 'https://klatre-app1-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'klatre-app1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAZpqPuw5oTb9eiuXt2_kZ90VZy2YDcU2g',
    appId: '1:808817238237:ios:e6132e7149e34187217b34',
    messagingSenderId: '808817238237',
    projectId: 'klatre-app1',
    databaseURL: 'https://klatre-app1-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'klatre-app1.appspot.com',
    iosClientId: '808817238237-adm1vuhfoqeuj8rl81gp3n0bqpip34po.apps.googleusercontent.com',
    iosBundleId: 'com.climb.it',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAZpqPuw5oTb9eiuXt2_kZ90VZy2YDcU2g',
    appId: '1:808817238237:ios:fa4b8fddb2c2a027217b34',
    messagingSenderId: '808817238237',
    projectId: 'klatre-app1',
    databaseURL: 'https://klatre-app1-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'klatre-app1.appspot.com',
    iosClientId: '808817238237-ie7nt5s7me27uh44508433n4jml5ful9.apps.googleusercontent.com',
    iosBundleId: 'com.climb.it.RunnerTests',
  );
}
