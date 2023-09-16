import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:emarket_buyer/app/presentations/controller/controller.dart';
import 'package:emarket_buyer/app/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SigninPage extends GetWidget<AuthController> {
  SigninPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50.h),
                    SvgPicture.asset(
                      'assets/logo/logo.svg',
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      'Masuk untuk ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 45,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                      child: AnimatedTextKit(
                        pause: const Duration(milliseconds: 1000),
                        repeatForever: false,
                        totalRepeatCount: 5,
                        animatedTexts: [
                          TyperAnimatedText(
                            'Jajan',
                            textStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 45,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                            speed: const Duration(milliseconds: 100),
                          ),
                          TyperAnimatedText(
                            'Liat liat',
                            textStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 45,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue,
                            ),
                            speed: const Duration(milliseconds: 100),
                          ),
                          TyperAnimatedText(
                            'Melanjutkan',
                            textStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 45,
                              fontWeight: FontWeight.w700,
                              color: Colors.green,
                            ),
                            speed: const Duration(milliseconds: 100),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 60.h),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
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
                              } else if (!value.isEmail) {
                                return 'Email tidak valid';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              controller.email = value!;
                            },
                          ),
                          SizedBox(height: 15.h),
                          Fields(
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
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
                            Get.toNamed('/signup');
                          },
                          text1: 'Belum Punya Akun?',
                          text2: 'Daftar',
                        ),
                        SizedBox(height: 15.h),
                        ButtonWidget(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              controller.signIn();
                            }
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          title: 'Masuk',
                        ),
                      ],
                    ),
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
