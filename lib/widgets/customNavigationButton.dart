import 'package:club8_dev/blocs/gradient_button/gradient_button_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocProvider(
      create: (_) => GradientButtonBloc(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.small),
        child: BlocListener<GradientButtonBloc, GradientButtonState>(
          listener: (context, state) {
            if (state is GradientButtonEnabled) {
              // You can do something when the button is enabled
            }
          },
          child: BlocBuilder<GradientButtonBloc, GradientButtonState>(
            builder: (context, state) {
              // Update the BLoC state based on text input
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: state is GradientButtonEnabled
                        ? [
                            AppColors.darkBlack,
                            AppColors.grey,
                            AppColors.darkBlack,
                          ]
                        : [
                            AppColors.darkBlack,
                            AppColors.lightGrey,
                            AppColors.darkBlack,
                          ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: state is GradientButtonEnabled
                        ? AppColors.white
                        : AppColors.grey,
                    width: 0.5,
                  ),
                ),
                child: TextButton(
                  onPressed: state is GradientButtonEnabled ? onPressed : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Text(
                          buttonText,
                          style: TextStyle(
                            color: state is GradientButtonEnabled
                                ? AppColors.white
                                : AppColors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: Spacing.horizontalMedium),
                        Icon(
                          icon,
                          color: state is GradientButtonEnabled
                              ? AppColors.white
                              : AppColors.grey,
                          size: 20,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
