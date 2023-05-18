import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String?>();

class LocalNotificationHelper {
  static LocalNotificationHelper? _instance;

  LocalNotificationHelper._internal() {
    _instance = this;
  }

  factory LocalNotificationHelper() =>
      _instance ?? LocalNotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) async {
      final payload = details.payload;
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    final CartController cartController = Get.put(CartController());

    var channelId = "1";
    var channelName = "channel_01";
    var channelDescription = "Checkout reminder";

    var androidPlatformChannel = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
      enableLights: true,
      ticker: 'ticker',
      styleInformation: const DefaultStyleInformation(true, true),
    );

    var platformChannel = NotificationDetails(android: androidPlatformChannel);

    var titleNotification = "<b>Kamu belum checkout?</b>";

    var bodyNotification =
        'Masih Ada ${cartController.cartProducts.length} item di keranjang kamu';

    await flutterLocalNotificationsPlugin.show(
      0,
      titleNotification,
      bodyNotification,
      platformChannel,
      payload: cartController.cartProducts.length.toString(),
    );
  }

  void configureSelectionNotificationSubject(
      BuildContext context, String route) {
    selectNotificationSubject.stream.listen(
      (String? payload) async {
        await Get.toNamed(route);
      },
    );
  }
}
