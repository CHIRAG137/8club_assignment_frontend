import 'package:club8_dev/Utils/spacing.dart';
import 'package:flutter/material.dart';

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    const double semiCircleRadius = Spacing.small; 
    const double gapLength = Spacing.small;

    path.moveTo(0, 0);

    // Top side: semicircles with gaps
    for (double i = 0; i < size.width; i += 2 * semiCircleRadius + gapLength) {
      path.lineTo(i + gapLength, 0);
      path.arcToPoint(
        Offset(i + gapLength + 2 * semiCircleRadius, 0),
        radius: const Radius.circular(semiCircleRadius),
        clockwise: false,
      );
    }

    // Right side: semicircles with gaps
    for (double i = 0; i < size.height; i += 2 * semiCircleRadius + gapLength) {
      path.lineTo(size.width, i + gapLength);
      path.arcToPoint(
        Offset(size.width, i + gapLength + 2 * semiCircleRadius),
        radius: const Radius.circular(semiCircleRadius),
        clockwise: false,
      );
    }

    // Bottom side: semicircles with gaps
    for (double i = size.width; i > 0; i -= 2 * semiCircleRadius + gapLength) {
      path.lineTo(i - gapLength, size.height);
      path.arcToPoint(
        Offset(i - gapLength - 2 * semiCircleRadius, size.height),
        radius: const Radius.circular(semiCircleRadius),
        clockwise: false,
      );
    }

    // Left side: semicircles with gaps
    for (double i = size.height; i > 0; i -= 2 * semiCircleRadius + gapLength) {
      path.lineTo(0, i - gapLength);
      path.arcToPoint(
        Offset(0, i - gapLength - 2 * semiCircleRadius),
        radius: const Radius.circular(semiCircleRadius),
        clockwise: false,
      );
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
