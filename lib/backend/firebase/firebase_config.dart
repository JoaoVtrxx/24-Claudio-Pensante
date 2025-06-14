import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDi9f2rdXB9ffexGfV6bdjABFEnTHA52Rc",
            authDomain: "code-race-2aa77.firebaseapp.com",
            projectId: "code-race-2aa77",
            storageBucket: "code-race-2aa77.firebasestorage.app",
            messagingSenderId: "877236744865",
            appId: "1:877236744865:web:5061b3d69130b2c4a876e0",
            measurementId: "G-V714R4F5MB"));
  } else {
    await Firebase.initializeApp();
  }
}
