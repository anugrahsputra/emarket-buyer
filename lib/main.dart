import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'common/common.dart';
import 'firebase_options.dart';
import 'presentations/controller/controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: Binding(),
      title: 'Emarket Buyer',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xffa1cca5),
        textTheme: GoogleFonts.robotoTextTheme(),
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
            ? MainPage(initialIndex: 0)
            : SigninPage();
      },
    );
  }
}
