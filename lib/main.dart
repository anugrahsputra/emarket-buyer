// ignore_for_file: unrelated_type_equality_checks

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:emarket_buyer/helper/helper.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'common/common.dart';
import 'firebase_options.dart';
import 'presentations/controller/controller.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        colorSchemeSeed: const Color(0xffa1cca5),
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
      home: const Root(),
      getPages: Routes.routes,
    );
  }
}

class Root extends GetWidget<AuthController> {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
      initState: (_) async {
        Get.put<BuyerController>(BuyerController());
      },
      builder: (_) {
        return controller.user?.uid != null
            ? Get.find<NetworkController>().connectionStatus == 1 ||
                    Get.find<NetworkController>().connectionStatus == 2
                ? MainPage(initialIndex: 0)
                : const NoConnectionPage()
            : SigninPage();
      },
    );
  }
}
