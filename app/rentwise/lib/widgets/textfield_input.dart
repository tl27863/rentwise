import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise/utils/colors.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPassword;
  final bool isEnabled;
  final String hintText;
  final TextInputType textInputType;
  const TextFieldInput({super.key, 
    required this.textEditingController,
    this.isPassword = false,
    this.isEnabled = true,
    required this.hintText,
    required this.textInputType}
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: !isEnabled,
      style: GoogleFonts.getFont(
          'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 16,
          letterSpacing: -0.3,
          color: const Color.fromARGB(255, 0, 0, 0),
      ),
      controller: textEditingController,
      decoration: InputDecoration(
        fillColor: !isEnabled ?
        const Color.fromARGB(255, 183, 183, 183)
        :
        bgColor,
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF334B48),
            width: 2.5
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF334B48),
            width: 2.5
          )
        ),
        hintStyle: GoogleFonts.getFont(
          'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 16,
          letterSpacing: -0.3,
          color: Color.fromARGB(255, 46, 46, 46),
        ),
        filled: true,
        contentPadding: const EdgeInsets.all(8)
      ),
      keyboardType: textInputType,
      obscureText: isPassword,
    );
  }
}