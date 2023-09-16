import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:emarket_buyer/app/presentations/controller/controller.dart';
import 'package:emarket_buyer/app/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends GetWidget<AuthController> {
  final _formKey = GlobalKey<FormState>();

  final LocationController locationController = Get.put(LocationController());

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.95,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Loading(
                loading: controller.loading,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    Text(
                      'Daftar',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 50,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                      child: AnimatedTextKit(
                        pause: const Duration(milliseconds: 1000),
                        repeatForever: false,
                        animatedTexts: [
                          TyperAnimatedText(
                            'Untuk Jajan',
                            textStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 35,
                              fontWeight: FontWeight.w900,
                              color: Colors.red,
                            ),
                            speed: const Duration(milliseconds: 100),
                          ),
                          TyperAnimatedText(
                            'Untuk Liat liat',
                            textStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 35,
                              fontWeight: FontWeight.w900,
                              color: Colors.blue,
                            ),
                            speed: const Duration(milliseconds: 100),
                          ),
                          TyperAnimatedText(
                            'Untuk Melanjutkan',
                            textStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 35,
                              fontWeight: FontWeight.w900,
                              color: Colors.green,
                            ),
                            speed: const Duration(milliseconds: 100),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Fields(
                            keyboardType: TextInputType.name,
                            hintText: 'Nama Lengkap',
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Color(0xff495057),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Nama tidak boleh kosong';
                              } else if (value.length < 3) {
                                return 'Nama tidak valid';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              controller.displayname = value!;
                            },
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Fields(
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Alamat Email',
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Color(0xff495057),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email tidak boleh kosong';
                              } else if (!value.contains('@')) {
                                return 'Email tidak valid';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              controller.email = value!;
                            },
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Fields(
                            keyboardType: TextInputType.phone,
                            hintText: 'Nomor Telepon',
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: Color(0xff495057),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Nomor Telepon tidak boleh kosong';
                              } else if (value.length < 10) {
                                return 'Nomor Telepon minimal 10 karakter';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              controller.phoneNumber = value!;
                            },
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Fields(
                            obscureText: true,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Color(0xff495057),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password tidak boleh kosong';
                              } else if (value.length < 6) {
                                return 'Password minimal 6 karakter';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              controller.password = value!;
                            },
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        BottomTextWidget(
                          onTap: () {
                            Get.back();
                          },
                          text1: 'SUdah Punya Akun?',
                          text2: 'Masuk',
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        ButtonWidget(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // await locationController.getCurrentLocation();
                              controller.signUp();
                            }

                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          title: 'Daftar',
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
