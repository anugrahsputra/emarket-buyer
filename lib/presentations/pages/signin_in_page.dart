import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SigninPage extends GetWidget<AuthController> {
  SigninPage({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
                    const SizedBox(height: 180),
                    Form(
                      child: Column(
                        children: [
                          Fields(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Alamat Email',
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Color(0xff495057),
                            ),
                          ),
                          const SizedBox(height: 15),
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
                          const SizedBox(height: 10),
                          ButtonWidget(
                            onPressed: () {
                              controller.signIn(
                                emailController.text,
                                passwordController.text,
                              );
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
                        Get.toNamed('/signup');
                      },
                      text1: 'Belum Punya Akun?',
                      text2: 'Daftar',
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
