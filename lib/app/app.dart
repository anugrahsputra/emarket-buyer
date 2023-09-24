import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'common/common.dart';
import 'presentations/controller/controller.dart';
import 'presentations/presentation.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialBinding: Binding(),
          title: 'Emarket Buyer',
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: const Color(0xFFFFFDFA),
            useMaterial3: true,
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFFFFFDFA)),
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
      },
    );
  }
}

class Root extends StatelessWidget {
  Root({super.key});

  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
      builder: (_) {
        return locationController.isInsideGeoFence
            ? _.user?.uid != null
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
