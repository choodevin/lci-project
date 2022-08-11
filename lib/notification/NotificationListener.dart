import 'package:LCI/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../leave-application.dart';

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings);
  await notificationsPlugin.initialize(initializationSettings, onSelectNotification: (payload) async {
    if (payload != null) {
      List<String> fullPayload = payload.split("|");
      String payloadPrefix = fullPayload[0];
      String payloadData = fullPayload[1];
      if (payloadPrefix == "LEAVE") {
        await BuildApp.navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => LeaveApplicationMain(campaignId: payloadData)));
      }
    }
    return;
  });
}

Future<void> notificationReceiver(RemoteMessage message) async {
  var title = message.data['title'];
  var content = message.data['content'];
  var notificationId = message.data['notificationId'];
  print("RECEIVED MESSAGE");
  print("notificationId: $notificationId");
  if(notificationId == "0") {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails("0", "Leave Application", "Leave Application Notifications");
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(0, title, content, notificationDetails, payload: "LEAVE|");
  } else if (notificationId == "1") {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails("1", "Leave Action", "Leave Application Notifications");
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(0, title, content, notificationDetails, payload: "LEAVE|");
  }
}
