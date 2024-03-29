import 'package:cached_network_image/cached_network_image.dart';
import 'package:emarket_buyer/app/presentations/controller/controller.dart';
import 'package:emarket_buyer/app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Profilepage extends StatelessWidget {
  Profilepage({Key? key}) : super(key: key);

  final authController = Get.put(AuthController());
  final buyerController = Get.put(BuyerController());
  final checkoutController = Get.put(CheckoutController());
  final database = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
      ),
      body: GetBuilder<BuyerController>(
        init: buyerController,
        initState: (_) async {
          buyerController.buyer =
              await database.getBuyer(authController.user!.uid);
        },
        builder: (controller) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildProfileCard(),
                  SizedBox(height: 25.h),
                  title('Pengaturan Akun'),
                  buildMenuCard([
                    cards('Profil', Icons.person, () {
                      Get.toNamed(
                        '/edit-profile-page',
                        arguments: buyerController.buyer,
                      );
                    }),
                    const Divider(
                      height: 0,
                      thickness: 1,
                    ),
                    cards('Akun', Icons.account_box, () {
                      Get.toNamed('/edit-account-page');
                    }),
                  ]),
                  SizedBox(height: 25.h),
                  title('Lainnya'),
                  buildMenuCard([
                    cards('Bantuan', Icons.help, () {}),
                    const Divider(
                      height: 0,
                      thickness: 1,
                    ),
                    cards('Tentang', Icons.info, () {}),
                  ]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xffa1cca5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage:
                CachedNetworkImageProvider(buyerController.buyer.photoUrl),
          ),
          SizedBox(
            width: 10.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                buyerController.buyer.displayName,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                buyerController.buyer.phoneNumber,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              authController.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }

  buildMenuCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xfff8f9fa),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  cards(String title, IconData icon, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xfff8f9fa),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xff212529),
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  title(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 99, 103, 107),
        ),
      ),
    );
  }
}
