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
      height: 60, // Adjust height as needed
      width: 60, // Adjust width as needed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18), // Rounded corners
        border: Border.all(
          color: Colors.white, // Border color
          width: 1, // Border width
        ),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        shape: const CircleBorder(),
        child: Icon(
          Icons.mic, // Use microphone icon
          color: Colors.white,
          size: 18, // Adjust the size of the icon
        ),
      ),
    );
  }
}
