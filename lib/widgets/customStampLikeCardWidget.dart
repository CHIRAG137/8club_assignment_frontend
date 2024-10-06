import 'package:club8_dev/Utils/colors.dart';
import 'package:club8_dev/widgets/customTicketClipperWidget.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class StampLikeCard extends StatefulWidget {
  final dynamic experience;

  const StampLikeCard({Key? key, required this.experience}) : super(key: key);

  @override
  _StampLikeCardState createState() => _StampLikeCardState();
}

class _StampLikeCardState extends State<StampLikeCard> {
  bool isSelected = false;
  Color selectedColor = AppColors.black;

  Color getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final double tiltAngle = (random.nextInt(31) - 10) * (pi / 180);

    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          selectedColor = isSelected ? getRandomColor() : AppColors.black;
        });
      },
      child: Transform.rotate(
        angle: tiltAngle,
        child: ClipPath(
          clipper: TicketClipper(),
          child: Container(
            color: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  height: 110,
                  width: 110,
                  color: selectedColor,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          widget.experience['name'].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Positioned(
                        top: 24,
                        left: 20,
                        right: 20,
                        child: Image.network(
                          widget.experience['icon_url'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
