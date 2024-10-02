// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pigen_vpn/colors.dart';
import 'package:pigen_vpn/customText.dart';
import 'package:pigen_vpn/size.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final double width;
  final VoidCallback onPressed;

  const CustomTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width = 100.0,
    this.fontSize = AppSizes.fontSizeMedium,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: InkWell(
        borderRadius: BorderRadius.circular(50.0),
        splashColor: AppColors.primaryColor,
        onTap: onPressed,
        child: Container(
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            gradient: AppColors.primaryGradient,
            boxShadow: const [
              BoxShadow(
                color: AppColors.primaryColor,
                offset: Offset(0, 0.5),
                blurRadius: 1.5,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Center(
              child: CustomText(
                text: text,
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
