// ignore_for_file: unrelated_type_equality_checks

import 'dart:developer';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:emarket_buyer/common/common.dart';
import 'package:emarket_buyer/firebase_options.dart';
import 'package:emarket_buyer/helper/local_notification_helper.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:emarket_buyer/services/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Got a message whilst in the foreground!');
    log('Message data: ${message.data}');

    if (message.notification != null) {
      log('Message also contained a notification: ${message.notification}');
    }
  });
  log('User granted premission: ${settings.authorizationStatus}');

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   Map<String, dynamic> data = message.data;

  //   SellerModel seller = SellerModel.fromSnapshot(jsonDecode(data['seller']!));
  //   BuyerModel buyer = BuyerModel.fromSnapshot(jsonDecode(data['buyer']!));
  //   log('New product available from ${seller.storeName} for buyer !');
  // });

  final LocalNotificationHelper localNotificationHelper =
      LocalNotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  await AndroidAlarmManager.initialize();
  await localNotificationHelper
      .initNotifications(flutterLocalNotificationsPlugin);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: Binding(),
      title: 'Emarket Buyer',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFa1cca5)),
        // colorSchemeSeed: const Color(0xffa1cca5),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
      home: Root(),
      getPages: Routes.routes,
    );
  }
}

class Root extends GetWidget<AuthController> {
  Root({super.key});

  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
      initState: (_) async {
        Get.put<BuyerController>(BuyerController());
      },
      builder: (_) {
        return locationController.isInsideGeoFence
            ? controller.user?.uid != null
                ? Get.find<NetworkController>().connectionStatus == 1 ||
                        Get.find<NetworkController>().connectionStatus == 2
                    ? const MainPage(initialIndex: 0)
                    : const NoConnectionPage()
                : SigninPage()
            : Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'Anda berada di luar area layanan kami',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
      },
    );
  }
}
