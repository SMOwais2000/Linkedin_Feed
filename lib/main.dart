import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'home_page/home_page.dart';
import 'notificationservice/local_notification_service.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  //? in a place of ! in the below line
  print(message.notification?.title);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
