import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/spacing.dart';

/// A custom AppBar widget that features a wave effect in its title.
class WaveAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Constructs a [WaveAppBar].
  const WaveAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Icon(
        Icons.arrow_back_sharp,
        color: AppColors.appBarIconColor,
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.all(Spacing.small), 
          child: Icon(
            Icons.close,
            color: AppColors.appBarIconColor,
          ),
        ),
      ],
      title: RichText(
        text: const TextSpan(
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: '︵‿︵‿︵‿',
              style: TextStyle(color: AppColors.waveColor),
            ),
            TextSpan(
              text: '︵‿︵‿︵‿',
              style: TextStyle(color: AppColors.waveTextColor),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.appBarBackground,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Defines the height of the AppBar
}
