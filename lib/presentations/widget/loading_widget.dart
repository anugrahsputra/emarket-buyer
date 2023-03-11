import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key, required this.loading, required this.child})
      : super(key: key);
  final Rx<bool> loading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Obx(
          () => loading.value
              ? Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xffe9ecef),
                      ),
                    ),
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}
