import 'package:LCI/group-chat.dart';
import 'package:LCI/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
      if (payloadPrefix == "CHAT") {
        await BuildApp.navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => GroupChat(campaignId: payloadData)));
      }
    }
    return;
  });
}

Future<void> notificationReceiver(RemoteMessage message) async {
  print("RECEIVED MESSAGE");
  print(message.data['title']);
  print(message.data['content']);
  var title = message.data['title'];
  var content = message.data['content'];
  var targetCampaign = message.data['targetCampaign'];
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails("0", "Chat", "Chat Notifications");
  const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
  await _flutterLocalNotificationsPlugin.show(0, title, content, notificationDetails, payload: "CHAT|$targetCampaign");
}
