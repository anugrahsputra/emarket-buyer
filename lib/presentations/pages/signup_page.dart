import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends GetWidget<AuthController> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();

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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Loading(
                loading: controller.loading,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 180,
                    ),
                    Form(
                      child: Column(
                        children: [
                          Fields(
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            hintText: 'Nama Lengkap',
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Color(0xff495057),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Fields(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Alamat Email',
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Color(0xff495057),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Fields(
                            controller: phoneNumberController,
                            keyboardType: TextInputType.phone,
                            hintText: 'Nomor Telepon',
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: Color(0xff495057),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Fields(
                            controller: passwordController,
                            obscureText: true,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Color(0xff495057),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ButtonWidget(
                            onPressed: () async {
                              controller.signUp(
                                nameController.text,
                                emailController.text,
                                'https://ui-avatars.com/api/?name=${nameController.text}',
                                passwordController.text,
                                phoneNumberController.text,
                              );
                              await locationController.getCurrentLocation();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            title: 'Daftar',
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    BottomTextWidget(
                      onTap: () {
                        Get.back();
                      },
                      text1: 'SUdah Punya Akun?',
                      text2: 'Masuk',
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
