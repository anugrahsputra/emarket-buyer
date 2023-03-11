import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomTextWidget extends StatelessWidget {
  const BottomTextWidget({
    super.key,
    required this.text2,
    required this.text1,
    required this.onTap,
  });

  final String text1;
  final String text2;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          text: text1,
          style: GoogleFonts.roboto(
            color: const Color(0xff8A8D9F),
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          children: [
            TextSpan(
                text: ' $text2',
                style: GoogleFonts.roboto(
                  color: const Color(0xff212529),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                recognizer: TapGestureRecognizer()..onTap = onTap),
          ],
        ),
      ),
    );
  }
}
