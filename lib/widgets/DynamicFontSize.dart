import 'package:flutter/material.dart';

class DynamicFontSize {
  double calculateFontSize({
    required double initialWidth,
    required double initialHeight,
    required double initialFontSize,
    required BuildContext context,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double scaleFactorWidth = screenWidth / initialWidth;
    final double scaleFactorHeight = screenHeight / initialHeight;
    final double scaleFactor = scaleFactorWidth < scaleFactorHeight
        ? scaleFactorWidth
        : scaleFactorHeight;
    return initialFontSize * scaleFactor;
  }
}