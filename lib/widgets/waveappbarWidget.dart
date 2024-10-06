import 'package:flutter/material.dart';

class WaveAppBar extends StatelessWidget {
  final Color waveColor;

  const WaveAppBar({Key? key, required this.waveColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        children: [
          TextSpan(
            text: '︵‿︵‿︵‿',
            style: TextStyle(color: waveColor),
          ),
          TextSpan(
            text: '︵‿︵‿︵‿',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
