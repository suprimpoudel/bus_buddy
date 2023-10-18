import 'package:bus_buddy_user/utils/helper/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  Logging.log("Title is ${message.notification?.title}", isInfo: true);
  Logging.log("Body is ${message.notification?.body}", isInfo: true);
  Logging.log("Payload is ${message.data}", isInfo: true);
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    Logging.log("Token is $fcmToken", isInfo: true);

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
