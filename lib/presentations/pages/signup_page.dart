import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                          const SizedBox(
                            height: 15,
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
                          const SizedBox(
                            height: 15,
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
                          const SizedBox(
                            height: 15,
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
                          const SizedBox(
                            height: 10,
                          ),
                          ButtonWidget(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await controller.signUp();
                              }
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
