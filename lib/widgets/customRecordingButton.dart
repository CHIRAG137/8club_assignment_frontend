import 'package:club8_dev/Utils/colors.dart';
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
      height: 60,
      width: 60,
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
        child: const Icon(
          Icons.mic,
          color: AppColors.micIconColor,
          size: 18,
        ),
      ),
    );
  }
}
