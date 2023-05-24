import 'dart:isolate';
import 'dart:ui';

import 'package:emarket_buyer/helper/helper.dart';
import 'package:emarket_buyer/main.dart';
import 'package:flutter/material.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
    port.listen(_handleMessage);
  }

  static void _handleMessage(dynamic data) {
    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }

  @pragma('vm:entry-point')
  static Future<void> callback() async {
    debugPrint('Notification coming');
    final LocalNotificationHelper notificationHelper =
        LocalNotificationHelper();
    await notificationHelper.showNotifications(flutterLocalNotificationsPlugin);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
