import 'package:club8_dev/Utils/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final double textFieldHeight;
  final double textSize;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.textFieldHeight,
    required this.textSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: textFieldHeight,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLength: 250,
        maxLines: null,
        expands: true,
        style: TextStyle(fontSize: textSize),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          hintStyle: const TextStyle(
            fontSize: 18,
            color: AppColors.hintTextColor,
          ),
          filled: true,
          fillColor: AppColors.fillColor,
          counterText: '',
        ),
      ),
    );
  }
}
