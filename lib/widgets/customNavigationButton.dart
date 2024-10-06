import 'package:flutter/material.dart';
import 'package:club8_dev/Utils/colors.dart';
import 'package:club8_dev/Utils/spacing.dart';

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
      padding: const EdgeInsets.symmetric(vertical: Spacing.small),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.darkBlack,
              AppColors.grey,
              AppColors.darkBlack,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.white,
            width: 0.5,
          ),
        ),
        child: TextButton(
          onPressed: () {
            // Call the onPressed method passed from ExperienceScreen
            onPressed.call();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Text(
                  buttonText,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: Spacing.horizontalMedium),
                Icon(
                  icon,
                  color: AppColors.white,
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
