import 'package:flutter/material.dart';

class AppSizes {
  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 20.0;
  static const double fontSizeExtraLarge = 24.0;

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;

  // Button Sizes
  static const double buttonHeight = 48.0;
  static const double buttonWidth = double.infinity;

  // Radius
  static const double borderRadiusSmall = 10.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusLarge = 30.0;
  static const double borderRadiusExtraLarge = 50.0;

  // Custom Sizes for Responsive Layouts (example)
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
}

extension EmptyPadding on num {
  SizedBox get h => SizedBox(height: toDouble());

  SizedBox get w => SizedBox(width: toDouble());
}
