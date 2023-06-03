import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Loading(
                loading: controller.loading,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 180),
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
                          const SizedBox(height: 15),
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
                          const SizedBox(height: 10),
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
