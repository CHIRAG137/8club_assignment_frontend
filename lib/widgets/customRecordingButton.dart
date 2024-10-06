import 'package:club8_dev/Utils/colors.dart';
import 'package:club8_dev/Utils/spacing.dart';
import 'package:flutter/material.dart';

class CustomRecordingButton extends StatelessWidget {
  const CustomRecordingButton({
    super.key,
    required this.isRecording,
    required this.onPressed,
  });

  final bool isRecording;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60 + Spacing.small,
      width: 60 + Spacing.small,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.borderColor,
          width: AppColors.borderWidth,
        ),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(Spacing.medium),
        child: Icon(
          isRecording ? Icons.stop : Icons.mic,
          color: AppColors.micIconColor,
          size: 24,
        ),
      ),
    );
  }
}
