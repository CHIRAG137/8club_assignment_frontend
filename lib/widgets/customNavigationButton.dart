import 'package:club8_dev/Utils/colors.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String buttonText;
  final IconData? icon;
  final TextEditingController controller;
  final VoidCallback onPressed;

  const GradientButton({
    Key? key,
    required this.buttonText,
    this.icon,
    required this.controller,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: controller.text.isEmpty
                ? [
                    AppColors.darkBlack,
                    AppColors.lightGrey,
                    AppColors.darkBlack,
                  ]
                : [
                    AppColors.darkBlack,
                    AppColors.grey,
                    AppColors.darkBlack,
                  ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: controller.text.isEmpty ? AppColors.grey : AppColors.white,
            width: 0.5,
          ),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Text(
                  buttonText,
                  style: TextStyle(
                    color: controller.text.isEmpty
                        ? AppColors.grey
                        : AppColors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  icon,
                  color: controller.text.isEmpty
                      ? AppColors.grey
                      : AppColors.white,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
